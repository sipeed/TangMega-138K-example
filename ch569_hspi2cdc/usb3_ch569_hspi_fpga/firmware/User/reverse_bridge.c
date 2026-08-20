#include "CH56x_common.h"
#include "CH56x_usb30_lib.h"
#include "CH56x_usb30.h"
#include "reverse_bridge.h"

#define REV_SLOTS 16U
enum { REV_IDLE, REV_STREAM, REV_REPORT_WAIT, REV_REPORT_USB };

static volatile UINT8 rev_state, usb_armed, hspi_busy;
static volatile UINT32 produced, consumed;
static volatile UINT16 slot_length[REV_SLOTS];
static volatile UINT32 total_bytes, data_bytes, frames, fifo_errors;

static UINT32 get_le32(volatile UINT8 *p) {
    return (UINT32)p[0] | ((UINT32)p[1]<<8) |
           ((UINT32)p[2]<<16) | ((UINT32)p[3]<<24);
}
static volatile UINT8 *slot_ptr(UINT32 seq) {
    return &endp2RTbuff[(seq % REV_SLOTS) * PACKET_SIZE];
}
static UINT32 depth(void) { return produced - consumed; }

static void hspi_reset(void) {
    R8_HSPI_INT_EN=0;
    R8_HSPI_CTRL=RB_HSPI_ALL_CLR|RB_HSPI_TRX_RST;
    R8_HSPI_CTRL=0; R8_HSPI_INT_FLAG=0x0f;
    R8_HSPI_TX_SC=0; R8_HSPI_RX_SC=0;
}
static void hspi_tx_init(void) {
    hspi_reset();
    R32_PA_DIR|=(1UL<<9)|(1UL<<10)|(1UL<<11)|(1UL<<21);
    R32_PA_DRV|=(1UL<<11);
    R8_HSPI_CFG=RB_HSPI_MODE|RB_HSPI_DAT16_MOD;
    R8_HSPI_AUX=RB_HSPI_REQ_FT|RB_HSPI_TCK_MOD;
    R32_HSPI_UDF0=0x0000ffff;
    R8_HSPI_INT_EN=RB_HSPI_IE_T_DONE|RB_HSPI_IE_FIFO_OV;
    R8_HSPI_CTRL=RB_HSPI_ENABLE|RB_HSPI_DMA_EN;
}
static void arm_usb_out(void) {
    if (usb_armed || depth() >= REV_SLOTS-1 || rev_state!=REV_STREAM) return;
    USBSS->UEP1_RX_DMA=(UINT32)(UINT8 *)slot_ptr(produced);
    USB30_OUT_ClearIT(ENDP_1);
    USB30_OUT_Set(ENDP_1,ACK,DEF_ENDP1_OUT_BURST_LEVEL);
    USB30_Send_ERDY(ENDP_1|OUT,DEF_ENDP1_OUT_BURST_LEVEL);
    usb_armed=1;
}
static void start_hspi(void) {
    if (hspi_busy || consumed==produced || rev_state!=REV_STREAM) return;
    UINT16 len=slot_length[consumed%REV_SLOTS];
    R32_HSPI_TX_ADDR0=(UINT32)(UINT8 *)slot_ptr(consumed);
    R16_HSPI_DMA_LEN0=len-1;
    R8_HSPI_INT_FLAG=0x0f;
    hspi_busy=1;
    R8_HSPI_CTRL|=RB_HSPI_SW_ACT;
}
static void report_rx_init(void) {
    hspi_reset();
    R8_HSPI_CFG=RB_HSPI_DAT16_MOD;
    R8_HSPI_AUX=RB_HSPI_REQ_FT|RB_HSPI_TCK_MOD;
    R32_HSPI_RX_ADDR0=(UINT32)(UINT8 *)endp1RTbuff;
    R8_HSPI_INT_EN=RB_HSPI_IE_R_DONE|RB_HSPI_IE_FIFO_OV;
    R8_HSPI_CTRL=RB_HSPI_ENABLE|RB_HSPI_DMA_EN;
    rev_state=REV_REPORT_WAIT;
}

void Reverse_Bridge_Init(void) { rev_state=REV_IDLE; }
UINT8 Reverse_Bridge_Active(void) { return rev_state!=REV_IDLE; }
UINT8 Reverse_Report_Active(void) { return rev_state==REV_REPORT_USB; }
void Reverse_Bridge_Start(void) {
    produced=consumed=0; total_bytes=data_bytes=frames=fifo_errors=0;
    usb_armed=hspi_busy=0; rev_state=REV_STREAM;
    hspi_tx_init(); arm_usb_out();
}
void Reverse_USB_OUT_Complete(UINT16 len) {
    if (rev_state!=REV_STREAM || !usb_armed || !len || len>PACKET_SIZE) return;
    usb_armed=0;
    slot_length[produced%REV_SLOTS]=len;
    if (produced==0) total_bytes=get_le32(&slot_ptr(produced)[8]);
    else data_bytes+=len;
    produced++;
    start_hspi();
    arm_usb_out();
}
void Reverse_HSPI_IRQHandler(UINT8 flags) {
    if (flags&RB_HSPI_IF_T_DONE) {
        R8_HSPI_INT_FLAG=RB_HSPI_IF_T_DONE;
        if (hspi_busy) {
            hspi_busy=0; consumed++; frames++;
            if (frames>1 && data_bytes>=total_bytes) report_rx_init();
            else { start_hspi(); arm_usb_out(); }
        }
    }
    if (flags&RB_HSPI_IF_R_DONE) {
        R8_HSPI_INT_FLAG=RB_HSPI_IF_R_DONE;
        if (rev_state==REV_REPORT_WAIT) {
            UINT16 len=R16_HSPI_RX_LEN0; if (!len||len>1024) len=64;
            USBSS->UEP2_TX_DMA=(UINT32)(UINT8 *)endp1RTbuff;
            USB30_IN_Set(ENDP_2,ENABLE,ACK,1,len);
            USB30_Send_ERDY(ENDP_2|IN,1);
            rev_state=REV_REPORT_USB;
        }
    }
    if (flags&RB_HSPI_IF_FIFO_OV) {
        R8_HSPI_INT_FLAG=RB_HSPI_IF_FIFO_OV; fifo_errors++;
    }
}
void Reverse_Report_USB_Done(void) {
    USB30_IN_ClearIT(ENDP_2);
    USB30_IN_Set(ENDP_2,ENABLE,NRDY,0,1024);
    rev_state=REV_IDLE;
}
