
#include <stdbool.h>

#include "CH56x_common.h"
#include "CH56x_usb30_lib.h"
#include "CH56x_usb30.h"
#include "HSPI.h"

#include "main.h"
#include "logic_cmd.h"
#include "reverse_bridge.h"

#ifdef DEBUG
static volatile uint32_t s_dbg_hspi_rx_cnt;
static volatile uint64_t s_dbg_systick_cnt;
static volatile uint8_t s_dbg_hspi_rx_systick_print;
static volatile uint32_t s_dbg_hspi_addr0;
static volatile uint32_t s_dbg_hspi_addr1;
static volatile uint32_t s_dbg_usb_ep2_addr_offset;
static volatile uint32_t s_dbg_hspi_ov_flag = 0;
static volatile uint32_t s_dbg_ov_hspi_rx = 0;
static volatile uint64_t s_dbg_ov_systick_cnt = 0;
static volatile uint64_t s_dbg_hspi_first_pkt_systick = 0;
static volatile uint32_t s_dbg_crc_errors;
static volatile uint32_t s_dbg_seq_errors;
static volatile uint32_t s_dbg_fifo_overflows;
static volatile uint32_t s_dbg_pause_count;
static volatile uint8_t s_dbg_max_depth;
#endif

void HSPI_Benchmark_ResetStats(void)
{
#ifdef DEBUG
    s_dbg_crc_errors = 0;
    s_dbg_seq_errors = 0;
    s_dbg_fifo_overflows = 0;
    s_dbg_pause_count = 0;
    s_dbg_max_depth = 0;
#endif
}

int main()
{
    /* Keep CH569 at the requested 120 MHz baseline; do not use the original
     * slogic example's 160 MHz overclock while validating USB3. */
    SystemInit(120000000);
/* Debug serial port initialization */
    DebugInit(115200);
    Delay_Init(GetSysClock());

    SLOGIC_LOG("\x0c");
    SLOGIC_LOG_TICK(GetSysTick());
    SLOGIC_LOG("System Started!\r\n");
    SLOGIC_LOG("  -Reset=%s\r\n",(char*[]){"SW","POR","WDOG","PIN"}[R8_RST_BOOT_STAT&RB_RESET_FLAG]);
    SLOGIC_LOG("  -ChipID=0x%02X\r\n", R8_CHIP_ID);
    SLOGIC_LOG("  -Clock=%dMHz\r\n", GetSysClock()/1000000);

    SLOGIC_LOG("  -DataPath=HSPI16 to USB3 bulk IN\r\n");

    // hexdump(USBSS_BASE, 0xf4, 4);

    /* reset global values BEGIN */
    g_hspi_rx_cnt = 0;
    g_usb_ep2in_cnt = 0;
#ifdef DEBUG
        s_dbg_hspi_rx_cnt = 0;
        s_dbg_systick_cnt= 0;
        s_dbg_hspi_rx_systick_print = 0;
#endif
    for (int i = 0; i < 4096/4/2; i++) {
        ((uint32_t *)endp2RTbuff)[i] = i | 0xC0000000;
    }
    /* reset global values END */

//USB初始化
    R32_USB_CONTROL = 0;
    PFIC_SetPriority(HSPI_IRQn, 0xF0);
    PFIC_SetPriority(USBSS_IRQn, 0xD0);
    PFIC_SetPriority(LINK_IRQn, 0xC0);
    PFIC_EnableIRQ(USBSS_IRQn);
    PFIC_EnableIRQ(LINK_IRQn);
    USB30D_init(ENABLE);          //USB3.0初始化 初始化之前确保USB3.0两个中断使能
    mDelaymS(500);
    // hexdump(USBSS_BASE, 0xf4, 4);

    /* HSPI port initialization */
    HSPI_Init((uint32_t)&endp2RTbuff);
    PFIC_EnableIRQ(HSPI_IRQn);
    SLOGIC_LOG("HSPI Slave MODE\r\n");
    SLOGIC_LOG("HSPI Rx=0x%08x@0x%5x\r\n", &endp2RTbuff, sizeof(endp2RTbuff));

    SLOGIC_LOG_TICK(GetSysTick());
    Reverse_Bridge_Init();
    while(1) {

#ifdef DEBUG
        static uint32_t dbg_ov_print_cnt = 0;
        if(s_dbg_hspi_rx_systick_print){
            dbg_ov_print_cnt++;
            s_dbg_hspi_rx_systick_print = 0;
            SLOGIC_LOG("rx=%08x crc=%u seq=%u fifo=%u depth_max=%u pauses=%u, ",
                       s_dbg_hspi_rx_cnt, s_dbg_crc_errors, s_dbg_seq_errors,
                       s_dbg_fifo_overflows, s_dbg_max_depth, s_dbg_pause_count);
            SLOGIC_LOG_TICK(s_dbg_systick_cnt);
            if (s_dbg_hspi_ov_flag && dbg_ov_print_cnt%16==0) {
                SLOGIC_LOG("q OV, hspi rx=%08x, ", s_dbg_ov_hspi_rx); SLOGIC_LOG_TICK(s_dbg_ov_systick_cnt);
                SLOGIC_LOG("first rx "); SLOGIC_LOG_TICK(s_dbg_hspi_first_pkt_systick);
            }
        }
#endif

    //    hexdump((void*)0x20020000, 16*4, 4);
    }
    return 0;
}

__attribute__((interrupt("WCH-Interrupt-fast"))) void HSPI_IRQHandler(void)
{
    if (Reverse_Bridge_Active()) {
        Reverse_HSPI_IRQHandler(R8_HSPI_INT_FLAG);
        return;
    }
    if(R8_HSPI_INT_FLAG & RB_HSPI_IF_R_DONE){  //Single packet received completed
        R8_HSPI_INT_FLAG = RB_HSPI_IF_R_DONE;  //Clear Interrupt

        // /* if ov, return */
        // if (g_h2u_packet_ov_flag)
        //     return;

        //Determine whether the CRC is correct
        if(R8_HSPI_RTX_STATUS & RB_HSPI_CRC_ERR){  //CRC check err
            s_dbg_crc_errors++;
        }

        //Whether the serial number received matches, (do not match, modify the package serial number)
        if(R8_HSPI_RTX_STATUS & RB_HSPI_NUM_MIS){  //do not match
            s_dbg_seq_errors++;
        }

        //CRC is correct, received serial number matches (data received correctly)
        if((R8_HSPI_RTX_STATUS & (RB_HSPI_CRC_ERR|RB_HSPI_NUM_MIS))==0){
            // SLOGIC_LOG((const char *[]){"S\r", "S.\r", "S..\r", "S...\r"}[g_hspi_rx_cnt%4]);
            g_hspi_rx_cnt ++;

#ifdef DEBUG
            if(g_hspi_rx_cnt%10240 == 0){
                s_dbg_hspi_rx_cnt = g_hspi_rx_cnt;
                s_dbg_systick_cnt = GetSysTick();
                s_dbg_hspi_rx_systick_print = 1;
                s_dbg_hspi_addr0 = R32_HSPI_RX_ADDR0;
                s_dbg_hspi_addr1 = R32_HSPI_RX_ADDR1;
                s_dbg_usb_ep2_addr_offset = g_usb_send_addr_offset;
            }
            if (!s_dbg_hspi_first_pkt_systick) s_dbg_hspi_first_pkt_systick = GetSysTick();
#endif
            /* The toggle observed after R_DONE identifies the address which
             * has just completed (hardware has already toggled to the other
             * receive register).  Capture it before changing either address. */
            uint8_t completed_addr0 = !!(R8_HSPI_RX_SC & RB_HSPI_RX_TOG);
            uint32_t completed_offset = (completed_addr0 ? R32_HSPI_RX_ADDR0 :
                                                           R32_HSPI_RX_ADDR1) -
                                        g_hspi_rx_addr_base;
            uint8_t completed_slot = completed_offset / PACKET_SIZE;

            /* Until the host explicitly arms EP2, continuously accept and
             * discard FPGA frames.  This avoids a guaranteed startup STALL.
             * Start on a fresh ring after the host has had 20 ms to queue IN. */
            if (g_usb_stream_state != 2) {
                if (g_usb_stream_state == 1 &&
                    (int64_t)(GetSysTick() - g_usb_stream_start_tick) >= 0) {
                    g_h2u_produced = 0;
                    g_h2u_consumed = 0;
                    g_h2u_first_slot = completed_slot;
                    g_h2u_next_slot = 2;
                    g_usb_ep2_active = 0;
                    g_h2u_packet_ov_flag = 0;
                    g_usb_stream_state = 2;
                } else {
                    return;
                }
            }
            /* if ov, return */
            /* 写在这是为了让前面DEBUG功能正常 */
            if (g_h2u_packet_ov_flag) {
                if(R8_HSPI_INT_FLAG & RB_HSPI_IF_FIFO_OV){   //FIFO OV
                    R8_HSPI_INT_FLAG = RB_HSPI_IF_FIFO_OV;  //Clear Interrupt
                    s_dbg_fifo_overflows++;
                }
                return;
            }

            uint32_t produced = g_h2u_produced;
            if (produced - g_h2u_consumed >= PACKET_MAX_NUM) {
#ifdef DEBUG
                s_dbg_hspi_ov_flag = 1;
                s_dbg_ov_hspi_rx = g_hspi_rx_cnt;
                s_dbg_ov_systick_cnt = GetSysTick();
#endif
                /* FIXME: send cmd and reset HSPI and USB */
                // UART_SendCMD(CMD_CNT(0));

                g_h2u_packet_ov_flag = 1;
            } else {
                g_h2u_slot_queue[produced % PACKET_MAX_NUM] = completed_slot;
                g_h2u_produced = produced + 1;
            }

            if (!g_h2u_packet_ov_flag && !g_usb_ep2_active) {
                g_usb_ep2_active = 1;
                g_usb_send_addr_offset = h2u_slot_offset(g_h2u_consumed);
                USBSS->UEP2_TX_DMA = (uint32_t)(UINT8 *)endp2RTbuff + g_usb_send_addr_offset;
                USB30_IN_Set(ENDP_2, ENABLE, ACK, DEF_ENDP2_IN_BURST_LEVEL, 1024);  //能够发送 nump 包
                USB30_Send_ERDY(ENDP_2 | IN, DEF_ENDP2_IN_BURST_LEVEL);//通知主机取4包
            }

            if(completed_addr0) {
                g_hspi_rx_addr0_offset = (uint32_t)g_h2u_next_slot * PACKET_SIZE;
                R32_HSPI_RX_ADDR0 = g_hspi_rx_addr_base + g_hspi_rx_addr0_offset;
            } else {
                g_hspi_rx_addr1_offset = (uint32_t)g_h2u_next_slot * PACKET_SIZE;
                R32_HSPI_RX_ADDR1 = g_hspi_rx_addr_base + g_hspi_rx_addr1_offset;
            }
            g_h2u_next_slot = (g_h2u_next_slot + 1) % PACKET_MAX_NUM;
            /* Apply backpressure only between complete HSPI frames.  Clearing
             * ENABLE withdraws CH569 receive-ready, so the FPGA waits before
             * starting its next frame instead of overwriting the USB ring. */
            if (h2u_depth() >= PACKET_PAUSE_WATERMARK) {
                R8_HSPI_CTRL &= ~RB_HSPI_ENABLE;
                g_hspi_paused = 1;
                s_dbg_pause_count++;
            }
            if (h2u_depth() > s_dbg_max_depth)
                s_dbg_max_depth = h2u_depth();
        }
    }

    if(R8_HSPI_INT_FLAG & RB_HSPI_IF_FIFO_OV){   //FIFO OV
        R8_HSPI_INT_FLAG = RB_HSPI_IF_FIFO_OV;  //Clear Interrupt
        s_dbg_fifo_overflows++;
    }

}


/*********************************************************************
 * @fn      HardFault_Handler
 *
 * @brief   Example of basic HardFault Handler called if an exception occurs
 *
 * @return  none
 */
__attribute__((interrupt("WCH-Interrupt-fast"))) void HardFault_Handler(void)
{
    SLOGIC_LOG("HardFault\r\n");
    SLOGIC_LOG(" SP=0x%08X\r\n", __get_SP());
    SLOGIC_LOG(" MIE=0x%08X\r\n", __get_MIE());
    SLOGIC_LOG(" MSTATUS=0x%08X\r\n", __get_MSTATUS());
    SLOGIC_LOG(" MCAUSE=0x%08X\r\n", __get_MCAUSE());
}
