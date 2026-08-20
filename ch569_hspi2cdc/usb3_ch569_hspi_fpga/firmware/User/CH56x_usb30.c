#include "CH56x_common.h"
#include "CH56x_usb30_lib.h"
#include "CH56x_usb30.h"
#include "main.h"
#include "reverse_bridge.h"

#include "usb_def.h"

static volatile struct {
    struct usb_setup_packet setup;
} s_inst_usb_core;
static uint8_t s_usb_address = 0;
static bool s_usbep2in_loop_test = false;

/*
 * 此例程为USB3.0 device使用例程
 * 主机可向1号端点突发4包数据后然后从1号端点取走4包数据
 * 主机可连续向2号端点下传数据 同时也可连续从2号端点取数据
 * */
/* Global define */
/* Global Variable */
UINT8V        tx_lmp_port = 0;
UINT8V        link_sta = 0;
static UINT32 SetupLen = 0;
static UINT8  SetupReqCode = 0;
static PUINT8 pDescr;

__attribute__((aligned(16))) volatile UINT8 endp0RTbuff[512] __attribute__((section(".DMADATA")));  //端点0数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp1RTbuff[PACKET_SIZE] __attribute__((section(".DMADATA"))); //端点1数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp2RTbuff[PACKET_SIZE*PACKET_MAX_NUM] __attribute__((section(".DMADATA"))); //端点2数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp3RTbuff[0] __attribute__((section(".DMADATA"))); //端点3数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp4RTbuff[0] __attribute__((section(".DMADATA"))); //端点4数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp5RTbuff[0] __attribute__((section(".DMADATA"))); //端点5数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp6RTbuff[0] __attribute__((section(".DMADATA"))); //端点6数据收发缓冲区
__attribute__((aligned(16))) volatile UINT8 endp7RTbuff[0] __attribute__((section(".DMADATA"))); //端点7数据收发缓冲区


#define SIZE_DEVICE_DESC      		 18
#define SIZE_CONFIG_DESC       		 57
#define SIZE_STRING_LANGID     		 4
#define SIZE_STRING_VENDOR     	     8
#define SIZE_STRING_PRODUCT    	     36
#define SIZE_STRING_SERIAL      	 22
#define SIZE_STRING_OS      		 18
#define SIZE_BOS_DESC      			 15
#define SIZE_MSOS20DescriptorSet     72
#define SIZE_PropertyHeader			 142
#define SIZE_CompactId				 40
#define SIZE_GetStatus				 2


/*超速设备描述符*/
const UINT8 SS_DeviceDescriptor[] = {
    USB_DEVICE_DESCRIPTOR_INIT(USB_3_0, 0xFF, 0xFF, 0xFF, 0x359f, 0x3001, 0x0100, 0x01),
};

/*超速配置描述符*/
const UINT8 SS_ConfigDescriptor[] = {
    USB_CONFIG_DESCRIPTOR_INIT(SIZE_CONFIG_DESC, 0x01, 0x01, USB_CONFIG_BUS_POWERED, 800),
            //interface_descriptor
    USB_INTERFACE_DESCRIPTOR_INIT(0x00, 0x00, 0x03, 0xff, 0xff, 0xff, 0x00),
            //Endpoint 1 Descriptor
    USB_ENDPOINT_DESCRIPTOR_INIT(USB_ENDPOINT_IN(0x01), USB_ENDPOINT_TYPE_BULK, 1024, 0x00),
    USB_SUPERSPEED_ENDPOINT_COMPANION_DESCRIPTOR_INIT(DEF_ENDP1_IN_BURST_LEVEL - 1, 0x00, 0x0000),

    //endp1_descriptor
    USB_ENDPOINT_DESCRIPTOR_INIT(USB_ENDPOINT_OUT(0x01), USB_ENDPOINT_TYPE_BULK, 1024, 0x00),
    USB_SUPERSPEED_ENDPOINT_COMPANION_DESCRIPTOR_INIT(DEF_ENDP1_OUT_BURST_LEVEL - 1, 0x00, 0x0000),

    //endp2_descriptor
    USB_ENDPOINT_DESCRIPTOR_INIT(USB_ENDPOINT_IN(0x02), USB_ENDPOINT_TYPE_BULK, 1024, 0x00),
    USB_SUPERSPEED_ENDPOINT_COMPANION_DESCRIPTOR_INIT(DEF_ENDP2_IN_BURST_LEVEL - 1, 0x00, 0x0000),
};

// ===== String Descriptor Lang ID=====
// ====================================//

const UINT8 StringLangID[] = {
    USB_LANGID_INIT(0x0409),
};

// ====================================
// =====   String Descriptor 1    =====
// ====================================
const UINT8 StringVendor[] = {
        8, // length of this descriptor
        USB_DESCRIPTOR_TYPE_STRING,
        'W', 0x00,
        'C', 0x00,
        'H', 0x00
};

// ====================================
// =====   String Descriptor 2    =====
// ====================================
const UINT8 StringProduct[] =
    {
        36,         //该描述符的长度为38字节
        USB_DESCRIPTOR_TYPE_STRING,       //字符串描述符的类型编码为0x03
        'W', 0x00, //W
        'C', 0x00, //C
        'H', 0x00, //H
        ' ', 0x00, //
        'U', 0x00, //U
        'S', 0x00, //S
        'B', 0x00, //B
        '3', 0x00, //3
        '.', 0x00, //.
        '0', 0x00, //0
        ' ', 0x00, //
        'D', 0x00, //D
        'E', 0x00, //E
        'V', 0x00, //V
        'I', 0x00, //I
        'C', 0x00, //C
        'E', 0x00, //E
};

// ====================================
// =====   String Descriptor 3    =====
// ====================================
const UINT8 StringSerial[] = {
    22, // length of this descriptor
    USB_DESCRIPTOR_TYPE_STRING,
    '0', 0x00,
    '1', 0x00,
    '2', 0x00,
    '3', 0x00,
    '4', 0x00,
    '5', 0x00,
    '6', 0x00,
    '7', 0x00,
    '8', 0x00,
    '9', 0x00,
};

const UINT8 OSStringDescriptor[] = {
    18, // length of this descriptor
    USB_DESCRIPTOR_TYPE_STRING,
    'M', 0x00,
    'S', 0x00,
    'F', 0x00,
    'T', 0x00,
    '1', 0x00,
    '0', 0x00,
    '0', 0x00,
    0x01,
    0x00
};

const UINT8 BOSDescriptor[] = {
    0x05, // bLength: Size of descriptor
    USB_DESCRIPTOR_TYPE_BINARY_OBJECT_STORE, // bDescriptorType: BOS Descriptor type
    WBVAL(0x000f), // wTotalLength: Length of this descriptor and all of its sub descriptors
    0x01, // bNumDeviceCaps: The number of separate device capability descriptors in the BOS

    //dev_cap_descriptor1
    0x0a, // bLength: Size of descriptor
    USB_DESCRIPTOR_TYPE_DEVICE_CAPABILITY, // bDescriptorType: DEVICE CAPABILITY type
    USB_DEVICE_CAPABILITY_SUPERSPEED_USB, // bDevCapabilityType: superspeed usb device capability
    0x00, // bmAttributes
    WBVAL(0x0008), // wSpeedsSupported: ss
    0x03, // bFunctionalitySupport: the lowest speed is ss speed
    0x0a, // bU1DevExitLat: 10us
    WBVAL(0x07ff), // wU2DevExitLat: 2047us
};

const UINT8 MSOS20DescriptorSet[] =
    {
        // Microsoft OS 2.0 Descriptor Set Header
        0x0A, 0x00,             // wLength - 10 bytes
        0x00, 0x00,             // MSOS20_SET_HEADER_DESCRIPTOR
        0x00, 0x00, 0x03, 0x06, // dwWindowsVersion 每 0x06030000 for Windows Blue
        0x48, 0x00,             // wTotalLength 每 72 bytes
                    // Microsoft OS 2.0 Registry Value Feature Descriptor
        0x3E, 0x00,             // wLength - 62 bytes
        0x04, 0x00,             // wDescriptorType 每 4 for Registry Property
        0x04, 0x00,             // wPropertyDataType - 4 for REG_DWORD
        0x30, 0x00,             // wPropertyNameLength 每 48 bytes
        0x53, 0x00, 0x65, 0x00, // Property Name - ※SelectiveSuspendEnabled§
        0x6C, 0x00, 0x65, 0x00,
        0x63, 0x00, 0x74, 0x00,
        0x69, 0x00, 0x76, 0x00,
        0x65, 0x00, 0x53, 0x00,
        0x75, 0x00, 0x73, 0x00,
        0x70, 0x00, 0x65, 0x00,
        0x6E, 0x00, 0x64, 0x00,
        0x45, 0x00, 0x6E, 0x00,
        0x61, 0x00, 0x62, 0x00,
        0x6C, 0x00, 0x65, 0x00,
        0x64, 0x00, 0x00, 0x00,
        0x04, 0x00,            // wPropertyDataLength 每 4 bytes
        0x01, 0x00, 0x00, 0x00 // PropertyData - 0x00000001
};

const UINT8 PropertyHeader[] =
    {
        0x8e, 0x00, 0x00, 0x00, 0x00, 01, 05, 00, 01, 00,
        0x84, 0x00, 0x00, 0x00,
        0x01, 0x00, 0x00, 0x00,
        0x28, 0x00,
        0x44, 0x00, 0x65, 0x00, 0x76, 0x00, 0x69, 0x00, 0x63, 0x00, 0x65, 0x00, 0x49, 0x00, 0x6e,
        0x00, 0x74, 0x00, 0x65, 0x00, 0x72, 0x00, 0x66, 0x00, 0x61, 0x00, 0x63, 0x00, 0x65, 0x00, 0x47, 0x00, 0x55, 0x00, 0x49, 0x00, 0x44, 0x00, 0x00, 0x00,

        0x4e, 0x00, 0x00, 0x00,
        0x7b, 0x00, 0x31, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34, 0x00, 0x35, 0x00, 0x36, 0x00, 0x37, 0x00, 0x38, 0x00,
        0x2d, 0x00, 0x31, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34, 0x00,
        0x2d, 0x00, 0x31, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34, 0x00,
        0x2d, 0x00, 0x31, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34, 0x00, 0x2d, 0x00, 0x31, 0x00, 0x32, 0x00, 0x33, 0x00,
        0x34, 0x00, 0x35, 0x00, 0x36, 0x00, 0x37, 0x00, 0x38, 0x00, 0x39, 0x00, 0x41, 0x00, 0x42, 0x00, 0x43, 0x00,
        0x7d, 0x00, 0x00, 0x00};

const UINT8 CompactId[] =
    {
        0x28, 0x00, 0x00, 0x00, 0x00, 0x01, 0x04, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
        0x57, 0x49, 0x4e, 0x55, 0x53, 0x42, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

UINT8 GetStatus[] =
    {
        0x01, 0x00};

/*******************************************************************************
 * @fn      USB30_BUS_RESET
 *
 * @brief   USB3.0总线复位，代码中选择复位方式，建议采用只复位USB的方式，如果连接有问题，可以采用复位单片机的方式
 *
 * @return   None
 */
void USB30_BUS_RESET()
{
    USB30D_init(DISABLE); //USB3.0初始化
    /* This function runs from LINK_IRQHandler.  Sleeping here makes the host
     * time out during SuperSpeed configuration and retrain forever. */
    USB30D_init(ENABLE); //USB3.0初始化
}

/*******************************************************************************
 * @fn      USB30D_init
 *
 * @brief   USB3.0设备初始化
 *
 * @return   None
 */
void USB30D_init(bool sta)
{
    UINT16 i, s;
    if(sta)
    {
        s = USB30_Device_Init();
        if(s)
        {
            PRINT("Init err\n");
            while(1)
                ;
        }
        USBSS->UEP_CFG = EP0_R_EN | EP0_T_EN | EP1_R_EN | EP1_T_EN | EP2_T_EN;// | EP2_R_EN | EP3_R_EN | EP3_T_EN | EP4_R_EN | EP4_T_EN | EP5_R_EN | EP5_T_EN | EP6_R_EN | EP6_T_EN | EP7_R_EN | EP7_T_EN; // set end point rx/tx enable

        USBSS->UEP0_DMA = (UINT32)(UINT8 *)endp0RTbuff;

        USBSS->UEP1_TX_DMA = (UINT32)(UINT8 *)endp1RTbuff;
        USBSS->UEP2_TX_DMA = (UINT32)(UINT8 *)endp2RTbuff;

        USBSS->UEP1_RX_DMA = (UINT32)(UINT8 *)endp1RTbuff;

        USB30_OUT_Set(ENDP_1, ACK, DEF_ENDP1_OUT_BURST_LEVEL); // endpoint1 receive setting

        //USB30_IN_Set(ENDP_2, ENABLE, ACK, DEF_ENDP2_IN_BURST_LEVEL, 1024); // endpoint2 send setting
    }
    else
    {
        USB30_Switch_Powermode(POWER_MODE_2);
        USBSS->LINK_CFG = PIPE_RESET | LFPS_RX_PD;
        USBSS->LINK_CTRL = GO_DISABLED | POWER_MODE_3;
        USBSS->LINK_INT_CTRL = 0;
        USBSS->USB_CONTROL = USB_FORCE_RST | USB_ALL_CLR;
    }
}

/*******************************************************************************
 * @fn      USB30_NonStandardReq
 *
 * @brief   USB3.0非标准请求处理函数
 *
 * @return   长度
 */
UINT16 USB30_NonStandardReq()
{
    struct usb_setup_packet *setup = &s_inst_usb_core.setup;
    UINT16 len = 0;
    switch (setup->bRequest) {
    case 0x8f:
        switch (HI_BYTE(setup->wValue)) {
        case 0xff:
            s_usbep2in_loop_test = LO_BYTE(setup->wValue);
            /* Do not print from a USBSS callback: at 115200 baud a short
             * line blocks time-critical link processing for milliseconds. */
            if (s_usbep2in_loop_test)
                USB30_IN_Set(ENDP_2, ENABLE, ACK, DEF_ENDP2_IN_BURST_LEVEL, 1024); // endpoint2 send setting
            else
                USB30_IN_Set(ENDP_2, ENABLE, NRDY, DEF_ENDP2_IN_BURST_LEVEL, 1024); // endpoint2 send setting
            break;
        case 0x00:
            switch (LO_BYTE(setup->wValue)) {
                case 0x7f: /* Start CMD */
                    /* Arm rather than starting immediately.  The 20 ms grace
                     * period lets the host submit its first bulk-IN transfer
                     * before a 225 MB/s producer can fill the 64 KiB ring. */
                    USB30_IN_Set(ENDP_2, ENABLE, NRDY, DEF_ENDP2_IN_BURST_LEVEL, 1024); // endpoint2 send setting
                    /* Do not rewrite active HSPI DMA addresses from EP0.
                     * Queue alignment is established at the first complete
                     * frame after the grace period. */
                    g_h2u_produced = 0;
                    g_h2u_consumed = 0;
                    g_usb_ep2_active = 0;
                    g_h2u_packet_ov_flag = 0;
                    HSPI_Benchmark_ResetStats();
                    g_usb_stream_start_tick = GetSysTick() + USB_STREAM_START_DELAY_TICKS;
                    g_usb_stream_state = 1;
                    break;
                case 0x7e: /* PC -> USB3 OUT -> HSPI -> FPGA benchmark */
                    Reverse_Bridge_Start();
                    break;
                default:
                    s_usbep2in_loop_test = 0;
                    UART_SendCMD(LO_BYTE(setup->wValue));
                    break;
            }
            break;
        default:
            len = USB_DESCR_UNSUPPORTED;
            break;
        }
        break;
    default:
        //        PRINT("stall\n");
        len = USB_DESCR_UNSUPPORTED;
        break;
    }
    return len;
}

static uint8_t std_loop_test_buf[512];
/*******************************************************************************
 * @fn      USB30_StandardReq
 *
 * @brief   USB3.0标准请求
 *
 * @return   长度
 */
UINT16 USB30_StandardReq()
{
    struct usb_setup_packet *setup = &s_inst_usb_core.setup;
    UINT16 len = 0;
    SetupReqCode = setup->bRequest;
    SetupLen = setup->wLength;
    switch (setup->bRequest) {
    case USB_REQUEST_CLEAR_FEATURE:
        break;
    case USB_REQUEST_GET_CONFIGURATION:
        break;
    case USB_REQUEST_GET_DESCRIPTOR:
        switch (HI_BYTE(setup->wValue)) {
        case USB_DESCRIPTOR_TYPE_DEVICE:
            if(SetupLen > SIZE_DEVICE_DESC)
                SetupLen = SIZE_DEVICE_DESC;
            pDescr = (PUINT8)SS_DeviceDescriptor;
            break;
        case USB_DESCRIPTOR_TYPE_CONFIGURATION:
            if(SetupLen > SIZE_CONFIG_DESC)
                SetupLen = SIZE_CONFIG_DESC;
            pDescr = (PUINT8)SS_ConfigDescriptor;
            break;
        case USB_DESCRIPTOR_TYPE_BINARY_OBJECT_STORE:
            if(SetupLen > SIZE_BOS_DESC)
                SetupLen = SIZE_BOS_DESC;
            pDescr = (PUINT8)BOSDescriptor;
            break;
        case USB_DESCRIPTOR_TYPE_STRING:
            switch (LO_BYTE(setup->wValue)) {
            case USB_STRING_LANGID_INDEX:
                if(SetupLen > SIZE_STRING_LANGID)
                    SetupLen = SIZE_STRING_LANGID;
                pDescr = (PUINT8)StringLangID;
                break;
            case USB_STRING_MFC_INDEX:
                if(SetupLen > SIZE_STRING_VENDOR)
                    SetupLen = SIZE_STRING_VENDOR;
                pDescr = (PUINT8)StringVendor;
                break;
            case USB_STRING_PRODUCT_INDEX:
                if(SetupLen > SIZE_STRING_PRODUCT)
                    SetupLen = SIZE_STRING_PRODUCT;
                pDescr = (PUINT8)StringProduct;
                break;
            case USB_STRING_SERIAL_INDEX:
                if(SetupLen > SIZE_STRING_SERIAL)
                    SetupLen = SIZE_STRING_SERIAL;
                pDescr = (PUINT8)StringSerial;
                break;
            case USB_OSDESC_STRING_DESC_INDEX:
                if(SetupLen > SIZE_STRING_OS)
                    SetupLen = SIZE_STRING_OS;
                pDescr = (PUINT8)OSStringDescriptor;
                break;
            default:
                SetupReqCode = INVALID_REQ_CODE; //无效的请求码
                break;
            }
            break;
        default:
            SetupReqCode = INVALID_REQ_CODE; //无效的请求码
            break;
        }
        if (INVALID_REQ_CODE == SetupReqCode) {
            len = USB_DESCR_UNSUPPORTED;
            break;
        }
        len = SetupLen >= USB_CTRL_EP_MPS ? USB_CTRL_EP_MPS : SetupLen; //本次传输长度
        memcpy(endp0RTbuff, pDescr, len);                           // device  /*加载上传数据 */
        SetupLen -= len;
        pDescr += len;
        break;
    case USB_REQUEST_GET_INTERFACE:
        break;
    case USB_REQUEST_GET_STATUS:
        if ((USB_REQUEST_DIR_IN | USB_REQUEST_RECIPIENT_DEVICE)
            == setup->bmRequestType) {
            switch (LO_BYTE(setup->wValue)) {
            case 0x00: // STANDARD_STATUS
                // 00 00
                SetupLen = 2;
                endp0RTbuff[0] = 0x00;
                endp0RTbuff[1] = 0x00;
                len = 2;
                SetupLen -= len;
                break;
            case 0x01: // PTM_STATUS only a Device
                // xx xx xx xx
            default: // Reserved
                break;
            }
        }
        break;
    case USB_REQUEST_SET_ADDRESS:
        if ((USB_REQUEST_DIR_OUT | USB_REQUEST_RECIPIENT_DEVICE)
            == setup->bmRequestType) {
                if ((setup->wValue <= 127) && (0 == (setup->wIndex | setup->wLength))) {
                    s_usb_address = setup->wValue;
                }
            }
        break;
    case USB_REQUEST_SET_CONFIGURATION:
        break;
    case USB_REQUEST_SET_DESCRIPTOR:
        break;
    case USB_REQUEST_SET_FEATURE:
        break;
    case USB_REQUEST_SET_INTERFACE:
        break;
    case USB_REQUEST_SET_ISOCH_DELAY:
        break;
    case USB_REQUEST_SET_SEL:
        break;
    case USB_REQUEST_SYNCH_FRAME:
        break;
    case USB_REQUEST_LOOPBACK_DATA_WRITE:
        pDescr = &std_loop_test_buf[setup->wIndex];
        break;
    case USB_REQUEST_LOOPBACK_DATA_READ:
        pDescr = &std_loop_test_buf[setup->wIndex];
        len = SetupLen >= USB_CTRL_EP_MPS ? USB_CTRL_EP_MPS : SetupLen; //本次传输长度
        memcpy(endp0RTbuff, pDescr, len);                           // device  /*加载上传数据 */
        SetupLen -= len;
        pDescr += len;
        break;
    default:
        len = USB_DESCR_UNSUPPORTED;
        break;
    }
    return len;
}

/*******************************************************************************
 * @fn      EP0_IN_Callback
 *
 * @brief   USB3.0端点0IN事务回调
 *
 * @return   发送长度
 */
UINT16 EP0_IN_Callback(void)
{
    UINT16 len = 0;
    switch(SetupReqCode) {
    case USB_REQUEST_GET_DESCRIPTOR:
    case USB_REQUEST_LOOPBACK_DATA_READ:
        len = SetupLen >= ENDP0_MAXPACK ? ENDP0_MAXPACK : SetupLen;
        memcpy(endp0RTbuff, pDescr, len);
        SetupLen -= len;
        pDescr += len;
        break;
    }
    // PRINT("%u, %02x %02x %02x %02x\r\n", SS_TX_CONTRL(ENDP_0) & UEPx_TRX_CTRL_TLEN_MASK, endp0RTbuff[0], endp0RTbuff[1], endp0RTbuff[2], endp0RTbuff[3]);
    return len;
}

/*******************************************************************************
 * @fn      EP0_OUT_Callback
 *
 * @brief   USB3.0端点0OUT回调
 *
 * @return   长度
 */
UINT16 EP0_OUT_Callback(void)
{
    UINT16 len = SS_RX_CONTRL(ENDP_0) & UEPx_TRX_CTRL_TLEN_MASK;
    // PRINT("%u, %02x %02x %02x %02x\r\n", len, endp0RTbuff[0], endp0RTbuff[1], endp0RTbuff[2], endp0RTbuff[3]);
    switch(SetupReqCode) {
    case USB_REQUEST_LOOPBACK_DATA_WRITE:
        memcpy(pDescr, endp0RTbuff, len);
        SetupLen -= len;
        pDescr += len;
        break;
    }
    return 0;
}

/*******************************************************************************
 * @fn      USB30_Setup_Status
 *
 * @brief   USB3.0控制传输状态阶段回调
 *
 * @return   None
 */
void USB30_Setup_Status(void)
{
    struct usb_setup_packet *setup = &s_inst_usb_core.setup;
    switch(setup->bRequest) {
    case USB_REQUEST_SET_ADDRESS:
        USB30_Device_Setaddress(s_usb_address); // SET ADDRESS
        /* Keep SET_ADDRESS completion timing deterministic. */
        break;
    }
}

/*******************************************************************************
 * @fn      USBSS_IRQHandler
 *
 * @brief   USB3.0 Interrupt Handler.
 *
 * @return   None
 */
__attribute__((interrupt("WCH-Interrupt-fast")))
void USBSS_IRQHandler(void) //USBSS interrupt service
{
    // USB30_IRQHandler();
	uint32_t usb_status = USBSS->USB_STATUS;
	if ((usb_status & USB_ACT_FLAG) == 0) {
		if ((usb_status & USB_LMP_RX_FLAG) != 0) {
			if ((USBSS->LMP_RX_DATA0 & 0x1e0) == 0xa0) {
				USBSS->LMP_TX_DATA0 = 0x2c0;
				USBSS->LMP_TX_DATA1 = 0;
				USBSS->LMP_TX_DATA2 = 0;
			}
			USBSS->USB_STATUS = USB_LMP_RX_FLAG;
		} else if ((usb_status & USB_ITP_FLAG) != 0) {
            USB30_ITP_Callback(USBSS->USB_ITP);
            USBSS->USB_STATUS = USB_ITP_FLAG;
        }
        return;
	}

    // USB3 INT
    uint8_t ep = (usb_status >> 8) & 0x7;
    uint8_t ep_in = (usb_status >> (12-7)) & 0x80;
    if (ep != 0) {
        // USB3 EP1 to EP7 management
        switch(ep_in|ep) {
            case 0x81:
                EP1_IN_Callback(); break;
            case 0x82:
                EP2_IN_Callback(); break;
            case 0x01:
                EP1_OUT_Callback(); break;
            case 0x02:
                EP2_OUT_Callback(); break;
            default:
                break;
        }
    } else {
        // USB3 EP0 management
        uint16_t req_len;
        if (ep_in != 0) {
            // EP0 IN
            static uint32_t seqn = 0;
            // PRINT("IN\r\n");
            req_len = EP0_IN_Callback();
            seqn = seqn + 1;
            if (req_len == 0) {
                // EP0 IN completed
                seqn = 0;
                SS_RX_CONTRL(ENDP_0) = (ACK << UEPx_TRX_CTRL_STAT_POS)
                                        | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS);
                SS_TX_CONTRL(ENDP_0) = (true << UEPx_TRX_CTRL_LPF_POS)
                                        | (ACK << UEPx_TRX_CTRL_STAT_POS)
                                        | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS);
                USB30_Send_ERDY(ENDP_0|OUT, NUMP_1);
            } else {
                SS_RX_CONTRL(ENDP_0) = 0;
                SS_TX_CONTRL(ENDP_0) = (true << UEPx_TRX_CTRL_LPF_POS)
                                        | (ACK << UEPx_TRX_CTRL_STAT_POS)
                                        | (UEPx_TRX_CTRL_SEQN_MASK & (seqn << UEPx_TRX_CTRL_SEQN_POS))
                                        | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS)
                                        | (UEPx_TRX_CTRL_TLEN_MASK & (req_len << UEPx_TRX_CTRL_TLEN_POS));

                USB30_Send_ERDY(ENDP_0|OUT, NUMP_1);
            }
        } else {
            // EP0 Out or Setup or Status
            uint32_t uep0_rx_ctrl = USBSS->UEP0_RX_CTRL;

            if ((uep0_rx_ctrl& UEPx_TRX_CTRL_SETUP_MASK) != 0) {
                // EP0 Setup Stage
                SS_TX_CONTRL(ENDP_0) = (false << UEPx_TRX_CTRL_LPF_POS)
                                    | (NRDY << UEPx_TRX_CTRL_STAT_POS)
                                    | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                    | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS);
                SS_RX_CONTRL(ENDP_0) = (NRDY << UEPx_TRX_CTRL_STAT_POS)
                                    | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                    | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS);
                struct usb_setup_packet *setup = &s_inst_usb_core.setup;
                memcpy(setup, endp0RTbuff, USB_SIZEOF_SETUP_PACKET);
                // PRINT("\r\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\nSetup: "
                //         "T=0x%02x, R=0x%02x, V=0x%04x, I=0x%04x, L=0x%04x\r\n",
                //         setup->bmRequestType, setup->bRequest, setup->wValue,
                //         setup->wIndex, setup->wLength);

                if ((USB_REQUEST_TYPE_MASK & setup->bmRequestType) == USB_REQUEST_TYPE_STANDARD)
                    req_len = USB30_StandardReq();
                else
                    req_len = USB30_NonStandardReq();

                if (req_len > USB_CTRL_EP_MPS) {
                    SS_TX_CONTRL(ENDP_0) = (false << UEPx_TRX_CTRL_LPF_POS)
                                            | (STALL << UEPx_TRX_CTRL_STAT_POS)
                                            | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                            | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS)
                                            | (0 << UEPx_TRX_CTRL_TLEN_POS);
                    /* Never block the USBSS interrupt on UART output. */
                } else {
                    uint8_t d2h = USB_REQUEST_DIR_MASK & setup->bmRequestType;
                    if (d2h) {
                        SS_TX_CONTRL(ENDP_0) = (true << UEPx_TRX_CTRL_LPF_POS)
                                                | (ACK << UEPx_TRX_CTRL_STAT_POS)
                                                | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                                | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS)
                                                | (UEPx_TRX_CTRL_TLEN_MASK & (req_len << UEPx_TRX_CTRL_TLEN_POS));
                        USB30_Send_ERDY(ENDP_0|IN, NUMP_1);
                    } else {
                        SS_RX_CONTRL(ENDP_0) = (ACK << UEPx_TRX_CTRL_STAT_POS)
                                                | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                                | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS)
                                                | (0 << UEPx_TRX_CTRL_TLEN_POS);
                        USB30_Send_ERDY(ENDP_0|OUT, NUMP_1);
                    }
                }
            } else if ((uep0_rx_ctrl & UEPx_TRX_CTRL_STATUS_MASK) != 0) {
                // EP0 Status Stage
                // PRINT("STATUS\r\n");
                USB30_Setup_Status();
                SS_RX_CONTRL(ENDP_0) = 0;
                SS_TX_CONTRL(ENDP_0) = 0;
            } else {
                // EP0 Out
                // PRINT("OUT\r\n");
                EP0_OUT_Callback();
                SS_RX_CONTRL(ENDP_0) = (ACK << UEPx_TRX_CTRL_STAT_POS)
                                        | (0 << UEPx_TRX_CTRL_SEQN_POS)
                                        | (NUMP_1 << UEPx_TRX_CTRL_NUMP_POS)
                                        | (0 << UEPx_TRX_CTRL_TLEN_POS);
                USB30_Send_ERDY(ENDP_0|OUT, NUMP_1);
            }
        }
    }
}

/*******************************************************************************
 * @fn      LINK_IRQHandler
 *
 * @brief   USB3.0 Link Interrupt Handler.
 *
 * @return   None
 */
__attribute__((interrupt("WCH-Interrupt-fast")))
void LINK_IRQHandler() //USBSS link interrupt service
{
    // PRINT("LINK=%08X\r\n", USBSS->LINK_INT_FLAG);
    if(USBSS->LINK_INT_FLAG & LINK_Ux_EXIT_FLAG) // device enter U2
    {
        USBSS->LINK_CFG = CFG_EQ_EN | DEEMPH_CFG | TERM_EN;
        USB30_Switch_Powermode(POWER_MODE_0);
        USBSS->LINK_INT_FLAG = LINK_Ux_EXIT_FLAG;
    }
    if(USBSS->LINK_INT_FLAG & LINK_RDY_FLAG) // POLLING SHAKE DONE
    {
        USBSS->LINK_INT_FLAG = LINK_RDY_FLAG;
        if(tx_lmp_port) // LMP, TX PORT_CAP & RX PORT_CAP
        {
            USBSS->LMP_TX_DATA0 = LINK_SPEED | PORT_CAP | LMP_HP;
            USBSS->LMP_TX_DATA1 = UP_STREAM | NUM_HP_BUF;
            USBSS->LMP_TX_DATA2 = 0x0;
            tx_lmp_port = 0;
        }
        /* Never block the LINK interrupt on UART output. */
        //成功USB3.0通讯
        // link_sta = 3;
        // PFIC_DisableIRQ(TMR0_IRQn);
        // R8_TMR0_CTRL_MOD = RB_TMR_ALL_CLEAR;
        // R8_TMR0_INTER_EN = 0;
        // PFIC_DisableIRQ(USBHS_IRQn);
        // USB20_Device_Init(DISABLE);
    }

    if(USBSS->LINK_INT_FLAG & LINK_INACT_FLAG)
    {
        USBSS->LINK_INT_FLAG = LINK_INACT_FLAG;
        USB30_Switch_Powermode(POWER_MODE_2);
    }
    if(USBSS->LINK_INT_FLAG & LINK_DISABLE_FLAG) // GO DISABLED
    {
        USBSS->LINK_INT_FLAG = LINK_DISABLE_FLAG;
        /* Never block the LINK interrupt on UART output. */
        // link_sta = 1;
        // USB30D_init(DISABLE);
        // PFIC_DisableIRQ(USBSS_IRQn);
        // R8_TMR0_CTRL_MOD = RB_TMR_ALL_CLEAR;
        // R8_TMR0_INTER_EN = 0;
        // PFIC_DisableIRQ(TMR0_IRQn);
        // PFIC_EnableIRQ(USBHS_IRQn);
        // USB20_Device_Init(ENABLE);
        USB30_BUS_RESET();
    }
    if(USBSS->LINK_INT_FLAG & LINK_RX_DET_FLAG)
    {
        USBSS->LINK_INT_FLAG = LINK_RX_DET_FLAG;
        USB30_Switch_Powermode(POWER_MODE_2);
    }
    if(USBSS->LINK_INT_FLAG & TERM_PRESENT_FLAG) // term present , begin POLLING
    {
        USBSS->LINK_INT_FLAG = TERM_PRESENT_FLAG;
        if(USBSS->LINK_STATUS & LINK_PRESENT)
        {
            USB30_Switch_Powermode(POWER_MODE_2);
            USBSS->LINK_CTRL |= POLLING_EN;
        }
        else
        {
            USBSS->LINK_INT_CTRL = 0;
            mDelayuS(2);
            USB30_BUS_RESET();
        }
    }
    if(USBSS->LINK_INT_FLAG & LINK_TXEQ_FLAG) // POLLING SHAKE DONE
    {
        tx_lmp_port = 1;
        USBSS->LINK_INT_FLAG = LINK_TXEQ_FLAG;
        USB30_Switch_Powermode(POWER_MODE_0);
    }
    if(USBSS->LINK_INT_FLAG & WARM_RESET_FLAG)
    {
        USBSS->LINK_INT_FLAG = WARM_RESET_FLAG;
        USB30_Switch_Powermode(POWER_MODE_2);
        USBSS->LINK_CTRL |= TX_WARM_RESET;
        while(USBSS->LINK_STATUS & RX_WARM_RESET)
            ;
        USBSS->LINK_CTRL &= ~TX_WARM_RESET;
        mDelayuS(2);
        USB30_BUS_RESET();
        USB30_Device_Setaddress(0);
    }
    if(USBSS->LINK_INT_FLAG & HOT_RESET_FLAG) //主机可能会下发hot reset,需注意端点的配置
    {
        USBSS->USB_CONTROL |= 1 << 31;
        USBSS->LINK_INT_FLAG = HOT_RESET_FLAG; // HOT RESET begin
        USBSS->UEP0_TX_CTRL = 0;
        USB30_IN_Set(ENDP_1, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_2, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_3, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_4, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_5, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_6, DISABLE, NRDY, 0, 0);
        USB30_IN_Set(ENDP_7, DISABLE, NRDY, 0, 0);
        USB30_OUT_Set(ENDP_1, NRDY, 0);
        USB30_OUT_Set(ENDP_2, NRDY, 0);
        USB30_OUT_Set(ENDP_3, NRDY, 0);
        USB30_OUT_Set(ENDP_4, NRDY, 0);
        USB30_OUT_Set(ENDP_5, NRDY, 0);
        USB30_OUT_Set(ENDP_6, NRDY, 0);
        USB30_OUT_Set(ENDP_7, NRDY, 0);

        USB30_Device_Setaddress(0);
        USBSS->LINK_CTRL &= ~TX_HOT_RESET; // HOT RESET end
    }
    if(USBSS->LINK_INT_FLAG & LINK_GO_U1_FLAG) // device enter U1
    {
        USB30_Switch_Powermode(POWER_MODE_1);
        USBSS->LINK_INT_FLAG = LINK_GO_U1_FLAG;
    }
    if(USBSS->LINK_INT_FLAG & LINK_GO_U2_FLAG) // device enter U2
    {
        USB30_Switch_Powermode(POWER_MODE_2);
        USBSS->LINK_INT_FLAG = LINK_GO_U2_FLAG;
    }
    if(USBSS->LINK_INT_FLAG & LINK_GO_U3_FLAG) // device enter U2
    {
        USB30_Switch_Powermode(POWER_MODE_2);
        USBSS->LINK_INT_FLAG = LINK_GO_U3_FLAG;
    }
}
/***************Endpointn IN Transaction Processing*******************/
/*******************************************************************************
 * @fn      EP1_IN_Callback
 *
 * @brief   USB3.0 endpoint1 in callback.
 *
 * @return   None
 */
void EP1_IN_Callback(void)
{
    UINT8 nump;
    nump = USB30_IN_Nump(ENDP_1); //nump: 剩余待发送包数量
    if(nump == 0) {                                                             //全部发完
        USBSS->UEP1_TX_DMA = (UINT32)(UINT8 *)endp1RTbuff;        //突发传输 DMA地址偏移 需重重置
        USB30_IN_ClearIT(ENDP_1);                                 //清除端点状态 仅保留包序列号
        USB30_OUT_Set(ENDP_1, ACK, DEF_ENDP1_OUT_BURST_LEVEL);    //设置端点能够接收4包
        USB30_Send_ERDY(ENDP_1 | OUT, DEF_ENDP1_OUT_BURST_LEVEL); //通知主机发4包
    } else { //还剩nump包未发完; 在突发过程中主机可能一次不能取走全部的数据包 因此要判断当前剩余包数量 通知主机还有几包未取,end of burst位需写enable
        USB30_IN_ClearIT(ENDP_1);                   //清除端点状态 仅保留包序列号
        USB30_IN_Set(ENDP_1, ENABLE, ACK, nump, 1024); //能够发送1包
        USB30_Send_ERDY(ENDP_1 | IN, nump);
    }
}

/*******************************************************************************
 * @fn      EP2_IN_Callback
 *
 * @brief   USB3.0 endpoint2 in callback.
 *
 * @return   None
 */

void EP2_IN_Callback(void)
{
    if (Reverse_Report_Active()) {
        Reverse_Report_USB_Done();
        return;
    }
    if (g_h2u_packet_ov_flag) {
        USB30_IN_ClearIT(ENDP_2);
        USB30_IN_Set(ENDP_2, ENABLE, STALL, 0, 1024);  // STALL
        return;
    }

    UINT8 nump = USB30_IN_Nump(ENDP_2); //nump 剩余待发送包数量
    g_usb_ep2in_cnt += DEF_ENDP2_IN_BURST_LEVEL - nump;

    USB30_IN_ClearIT(ENDP_2);           //清除端点状态 仅保留包序列号
    if(0 == nump){                      //4KB 全部发完
        g_h2u_consumed++;
        if (g_hspi_paused && h2u_depth() <= PACKET_RESUME_WATERMARK) {
            R8_HSPI_CTRL |= RB_HSPI_ENABLE;
            g_hspi_paused = 0;
        }
        if (g_h2u_consumed != g_h2u_produced) {
            g_usb_send_addr_offset = h2u_slot_offset(g_h2u_consumed);
            USBSS->UEP2_TX_DMA = (UINT32)(UINT8 *)endp2RTbuff + g_usb_send_addr_offset;                 //突发传输 DMA地址偏移 需重重置
            nump = DEF_ENDP2_IN_BURST_LEVEL;
        } else {
            g_usb_ep2_active = 0;
            /* Close the empty-to-nonempty race with HSPI_IRQHandler: after
             * publishing inactive, recheck the producer before returning
             * NRDY. */
            if (g_h2u_consumed != g_h2u_produced) {
                g_usb_ep2_active = 1;
                g_usb_send_addr_offset = h2u_slot_offset(g_h2u_consumed);
                USBSS->UEP2_TX_DMA = (UINT32)(UINT8 *)endp2RTbuff + g_usb_send_addr_offset;
                nump = DEF_ENDP2_IN_BURST_LEVEL;
            } else {
                USB30_IN_Set(ENDP_2, ENABLE, NRDY, 0, 1024);
                return;
            }
        }
    }
    USB30_IN_Set(ENDP_2, ENABLE, ACK, nump, 1024);  //能够发送 nump 包
    USB30_Send_ERDY(ENDP_2 | IN, nump);             //通知主机取 nump 包
}

/*******************************************************************************
 * @fn      EP3_IN_Callback
 *
 * @brief   USB3.0 endpoint3 in callback.
 *
 * @return   None
 */
void EP3_IN_Callback(void)
{
}

/*******************************************************************************
 * @fn      EP4_IN_Callback
 *
 * @brief   USB3.0 endpoint4 in callback.
 *
 * @return   None
 */
void EP4_IN_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP5_IN_Callback
 *
 * @brief   USB3.0 endpoint5 in callback.
 *
 * @return   None
 */
void EP5_IN_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP6_IN_Callback
 *
 * @brief   USB3.0 endpoint6 in callback.
 *
 * @return   None
 */
void EP6_IN_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP7_IN_Callback
 *
 * @brief   USB3.0 endpoint7 in callback.
 *
 * @return   None
 */
void EP7_IN_Callback(void)
{
}
/***************Endpointn OUT Transaction Processing*******************/

/*******************************************************************************
 * @fn      EP1_OUT_Callback
 *
 * @brief   USB3.0 endpoint1 out callback.
 *
 * @return   None
 */
void EP1_OUT_Callback(void)
{
    UINT16 rx_len;
    UINT8  nump;
    UINT8  status;
    USB30_OUT_Status(ENDP_1, &nump, &rx_len, &status); //获取接收到的包数量   rxlen 为最后一包的包长度
    if (Reverse_Bridge_Active()) {
        UINT16 packets_received = DEF_ENDP1_OUT_BURST_LEVEL - nump;
        UINT16 total = packets_received ?
            (UINT16)((packets_received - 1U) * 1024U + rx_len) : 0;
        USB30_OUT_ClearIT(ENDP_1);
        USB30_OUT_Set(ENDP_1, NRDY, 0);
        Reverse_USB_OUT_Complete(total);
    } else if(nump == 0) {
        USB30_OUT_ClearIT(ENDP_1);                                         //清除端点所有状态 仅保留包序列
        USBSS->UEP1_RX_DMA = (UINT32)(UINT8 *)endp1RTbuff;                 //突发模式下由于地址自动偏移 地址需重置
        USB30_OUT_Set(ENDP_1, ACK, DEF_ENDP1_OUT_BURST_LEVEL);
        USB30_Send_ERDY(ENDP_1 | OUT, DEF_ENDP1_OUT_BURST_LEVEL);
    } else { //还可以接收nump包
        USB30_OUT_ClearIT(ENDP_1);
        USB30_OUT_Set(ENDP_1, ACK, nump);    //能够接收nump包
        USB30_Send_ERDY(ENDP_1 | OUT, nump); //通知主机下发nump包
    }
}

/*******************************************************************************
 * @fn      EP2_OUT_Callback
 *
 * @brief   USB3.0 endpoint2 out callback.
 *
 * @return   None
 */
void EP2_OUT_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP3_OUT_Callback
 *
 * @brief   USB3.0 endpoint3 out callback.
 *
 * @return   None
 */
void EP3_OUT_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP4_OUT_Callback
 *
 * @brief   USB3.0 endpoint4 out callback.
 *
 * @return   None
 */
void EP4_OUT_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP5_OUT_Callback
 *
 * @brief   USB3.0 endpoint5 out callback.
 *
 * @return   None
 */
void EP5_OUT_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP6_OUT_Callback
 *
 * @brief   USB3.0 endpoint6 out callback.
 *
 * @return   None
 */
void EP6_OUT_Callback(void)
{
}
/*******************************************************************************
 * @fn      EP7_OUT_Callback
 *
 * @brief   USB3.0 endpoint7 out callback.
 *
 * @return   None
 */
void EP7_OUT_Callback(void)
{
}

/*******************************************************************************
 * @fn      USB30_ITP_Callback
 *
 * @brief   USB3.0 ITP回调函数
 *
 * @return   None
 */
void USB30_ITP_Callback(UINT32 ITPCounter)
{
}
