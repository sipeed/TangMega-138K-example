/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_usb30.c
* Author             : WCH
* Version            : V1.0
* Date               : 2023/02/16
*
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#include "CH56x_common.h"
#include "CH56x_usb30_LIB.h"
#include "CH56x_usb20.h"
#include "CH56x_usb30.h"
#include "cdc.h"

/* Global Variable */
UINT8V tx_lmp_port = 0;
UINT8V link_sta = 0;
UINT32V vitrul_buad  = 115200;
static UINT32 SetupLen = 0;
static UINT8 SetupReqCode = 0;
static PUINT8 pDescr;
__attribute__ ((aligned(16))) UINT8 endp0RTbuff[512]  __attribute__((section(".DMADATA"))); //Endpoint 0 data receiving and sending buffer
__attribute__ ((aligned(16))) UINT8 endp1RTbuff[4096] __attribute__((section(".DMADATA"))); //Endpoint 1 data receiving and sending buffer
__attribute__ ((aligned(16))) UINT8 endp2Rxbuff[4096] __attribute__((section(".DMADATA"))); //Endpoint 2 data receiving and sending buffer
__attribute__ ((aligned(16))) UINT8 endp2Txbuff[4096] __attribute__((section(".DMADATA"))); //Endpoint 2 data receiving and sending buffer


/*Superspeed device descriptor*/
const UINT8 SS_DeviceDescriptor[] =
{
    0x12,   // bLength
    0x01,   // DEVICE descriptor type
    0x00,   // 3.00
    0x03,
    0x02,  // device class
    0x00,  // device sub-class
    0x00,  // vendor specific protocol
    0x09,   // max packet size 512B
    0x86,   // vendor id 0x1a86
    0x1a,
    0x0c,   // product id 0xfe0c
    0xfe,
    0x01,   // bcdDevice 0x0111
    0x00,
    0x01,   // manufacturer index string
    0x02,   // product index string
    0x03,   // serial number index string
    0x01    // number of configurations
};

/*Superspeed Configuration Descriptor*/
const UINT8 SS_ConfigDescriptor[] =
{
     0x09,   // length of this descriptor
     0x02,   // CONFIGURATION (2)
     85,   // total length includes endpoint descriptors (should be 1 more than last address)
     0x00,   // total length high byte
     0x02,   // number of interfaces
     0x01,   // configuration value for this one
     0x00,   // configuration - string is here, 0 means no string
     0x80,   // attributes - bus powered, no wakeup
     0x64,   // max power - 800 ma is 100 (64 hex)


     0x09,   // length of the interface descriptor
     0x04,   // INTERFACE (4)
     0x00,   // Zero based index 0f this interface
     0x00,   // Alternate setting value (?)
     0x01,   // Number of endpoints (not counting 0)
     0x02,   // Interface class, ff is vendor specific
     0x02,   // Interface sub-class
     0x01,   // Interface protocol
     0x00,   // Index to string descriptor for this interface

     0x05,   /* bLength: Endpoint Descriptor size */
     0x24,   /* bDescriptorType: CS_INTERFACE */
     0x00,   /* bDescriptorSubtype: Header Func Desc */
     0x10,   /* bcdCDC: spec release number */
     0x01,

     0x05,   /* bFunctionLength */
     0x24,   /* bDescriptorType: CS_INTERFACE */
     0x01,   /* bDescriptorSubtype: Call Management Func Desc */
     0x00,
     0x01,

     0x04,
     0x24,
     0x02,
     0x02,

     0x05,
     0x24,
     0x06,
     0x00,
     0x01,

     0x07,   // length of this endpoint descriptor
     0x05,   // ENDPOINT (5)
     0x81,   // endpoint direction (80 is in) and address
     0x03,   // transfer type - 00 = control, 01 = iso, 10 = bulk, 11 = int
     0x00,   // max packet size - 1024 bytes
     0x04,   // max packet size - high
     0x08,   // polling interval in milliseconds (1 for iso)

     0x06,   // length of this endpoint compansion descriptor
     0x30,
     0x00,   // max burst size
     0x00,   // no stream
     0x00,
     0x00,

     0x09,   // length of the interface descriptor
     0x04,   // INTERFACE (4)
     0x01,   // Zero based index 0f this interface
     0x00,   // Alternate setting value (?)
     0x02,   // Number of endpoints (not counting 0)
     0x0a,   // Interface class, ff is vendor specific
     0x00,   // Interface sub-class
     0x00,   // Interface protocol
     0x00,   // Index to string descriptor for this interface

     //Endpoint 2 Descriptor
     0x07,   // length of this endpoint descriptor
     0x05,   // ENDPOINT (5)
     0x82,   // endpoint direction (80 is in) and address
     0x02,   // transfer type - 00 = control, 01 = iso, 10 = bulk, 11 = int
     0x00,   // max packet size - 1024 bytes
     0x04,   // max packet size - high
     0x00,   // polling interval in milliseconds (1 for iso)

     0x06,   // length of this endpoint compansion descriptor
     0x30,
     0x00,   // max burst size
     0x00,   // no stream
     0x00,
     0x00,

     //endp2_descriptor
     0x07,   // length of this endpoint descriptor
     0x05,   // ENDPOINT (5)
     0x02,   // endpoint direction (00 is out) and address
     0x02,   // transfer type - 00 = control, 01 = iso, 10 = bulk, 11 = int
     0x00,   // max packet size - 1024 bytes
     0x04,   // max packet size - high
     0x00,    // polling interval in milliseconds (1 for iso)

     0x06,   // length of this endpoint compansion descriptor
     0x30,
     0x00,   // max burst size
     0x00,   // no stream
     0x00,
     0x00
};

/*String Descriptor Lang ID*/
const UINT8 StringLangID[] =
{
    0x04,   // this descriptor length
    0x03,   // descriptor type
    0x09,   // Language ID 0 low byte
    0x04    // Language ID 0 high byte
};

/*String Descriptor Vendor*/
const UINT8 StringVendor[] =
{
    0x08,   // length of this descriptor
    0x03,
    'W',
    0x00,
    'C',
    0x00,
    'H',
    0x00
};


/*String Descriptor Product*/
const UINT8 StringProduct[]=
{
    38,         //38 bytes in length
    0x03,       //Type code
    0x57, 0x00, //W
    0x43, 0x00, //C
    0x48, 0x00, //H
    0x20, 0x00, //
    0x55, 0x00, //U
    0x53, 0x00, //S
    0x42, 0x00, //B
    0x33, 0x00, //3
    0x2e, 0x00, //.
    0x30, 0x00, //0
    0x20, 0x00, //
    0x44, 0x00, //D
    0x45, 0x00, //E
    0x56, 0x00, //V
    0x49, 0x00, //I
    0x43, 0x00, //C
    0x45, 0x00, //E
    0x20, 0x00
};

/*String Descriptor Serial*/
UINT8 StringSerial[] =
{
    0x16,   // length of this descriptor
    0x03,
    '0',
    0x00,
    '1',
    0x00,
    '2',
    0x00,
    '3',
    0x00,
    '4',
    0x00,
    '5',
    0x00,
    '6',
    0x00,
    '7',
    0x00,
    '8',
    0x00,
    '9',
    0x00,
};

const UINT8 OSStringDescriptor[] =
{
    0x12,   // length of this descriptor
    0x03,
    'M',
    0x00,
    'S',
    0x00,
    'F',
    0x00,
    'T',
    0x00,
    '1',
    0x00,
    '0',
    0x00,
    '0',
    0x00,
    0x01,
    0x00
};

const UINT8 BOSDescriptor[] =
{
    0x05,   // length of this descriptor
    0x0f,   // CONFIGURATION (2)
    0x16,   // total length includes endpoint descriptors (should be 1 more than last address)
    0x00,   // total length high byte
    0x02,   // number of device cap

    //dev_cap_descriptor1
    0x07,
    0x10,   // DEVICE CAPABILITY type
    0x02,   // USB2.0 EXTENSION
    0x06,
    0x00,
    0x00,
    0x00,

    //dev_cap_descriptor2
    0x0a,   // length of this descriptor
    0x10,   // DEVICE CAPABILITY type
    0x03,   // superspeed usb device capability
    0x00,   //
    0x0e,   // ss/hs/fs
    0x00,
    0x01,   // the lowest speed is full speed
    0x0a,   // u1 exit latency is 10us
    0xff,   // u1 exit latency is 8us
    0x07
};


/*******************************************************************************
 * @fn      USB30_BUS_RESET
 *
 * @brief   USB3.0 bus reset
 *
 * @return  None
 */
void USB30_BUS_RESET(void)
{
    R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
    R8_SAFE_ACCESS_SIG = 0xa8;
    R8_RST_WDOG_CTRL = 0x40 | RB_SOFTWARE_RESET;
}

/*******************************************************************************
 * @fn      USB30D_init
 *
 * @brief   USB3.0 initialization
 *
 * @return  None
 */
void USB30D_init(FunctionalState sta) {
    UINT16 i,s;
    if (sta) {
        USB30_Device_Init();

        USBSS->UEP0_DMA     = (UINT32)(UINT8 *)endp0RTbuff;
        USBSS->UEP1_TX_DMA  = (UINT32)(UINT8 *)endp1RTbuff;
        USBSS->UEP2_TX_DMA  = (UINT32)(UINT8 *)endp2Txbuff;
        USBSS->UEP2_RX_DMA  = (UINT32)(UINT8 *)endp2Rxbuff;

        USBSS->UEP_CFG = EP0_R_EN | EP0_T_EN | EP1_T_EN | EP2_R_EN | EP2_T_EN;// set end point rx/tx enable

        USB30_OUT_Set(ENDP_2, ACK, 1);

    }
    else {
        USB30_Switch_Powermode(POWER_MODE_2);
        USBSS->LINK_CFG = PIPE_RESET | LFPS_RX_PD;
        USBSS->LINK_CTRL = GO_DISABLED | POWER_MODE_3;
        USBSS->LINK_INT_CTRL = 0;
        USB30_Device_forceclr();
    }
}

/*******************************************************************************
 * @fn      USB30_NonStandardReq
 *
 * @brief   USB3.0 Nonstandard request processing function
 *
 * @return  Length
 */
UINT16 USB30_NonStandardReq() {
    UINT16 len = 0;

    SetupReqCode = UsbSetupBuf->bRequest;
    SetupLen = UsbSetupBuf->wLength;
    switch (SetupReqCode) {

        /*  Open the serial port and send the baud rate  */
        case 0x20:
            USB30_OUT_Set(ENDP_0, ACK, 1 );
            break;
        /*  Read the current serial port configuration  */
        case 0x21:
            *(UINT32  *)&endp0RTbuff[50] = vitrul_buad;
            endp0RTbuff[54]=0x00;endp0RTbuff[55]=0x00;endp0RTbuff[56]=0x08;
            SetupLen = 7;
            break;
        /*  Close uart  */
        case 0x22:
            CDC_Variable_Clear();
            break;
        default:
            printf("stall\n");
            SetupReqCode = INVALID_REQ_CODE;
            return USB_DESCR_UNSUPPORTED;
            break;
    }
    len = SetupLen >= ENDP0_MAXPACK ? ENDP0_MAXPACK : SetupLen;
    memcpy(endp0RTbuff, &endp0RTbuff[50], len);
    SetupLen -= len;
    pDescr += len;
    return len;
}

/*******************************************************************************
 * @fn      USB30_StandardReq
 *
 * @brief   USB3.0 Standard request
 *
 * @return  Length
 */
UINT16 USB30_StandardReq() {
    UINT16 len = 0;

    SetupReqCode = UsbSetupBuf->bRequest;
    SetupLen = UsbSetupBuf->wLength;

    if (( UsbSetupBuf->bRequestType & USB_REQ_TYP_MASK) != USB_REQ_TYP_STANDARD)
    {
       len= USB30_NonStandardReq();
    }
    else
    {
        switch (SetupReqCode) {
            case USB_GET_DESCRIPTOR:
                switch (UsbSetupBuf->wValueH) {
                    case USB_DESCR_TYP_DEVICE:
                        if (SetupLen > SIZE_DEVICE_DESC)
                            SetupLen = SIZE_DEVICE_DESC;
                        pDescr = (PUINT8) SS_DeviceDescriptor;
                        break;
                    case USB_DESCR_TYP_CONFIG:
                        if (SetupLen > SIZE_CONFIG_DESC)
                            SetupLen = SIZE_CONFIG_DESC;
                        pDescr = (PUINT8) SS_ConfigDescriptor;
                        break;
                    case USB_DESCR_TYP_BOS:
                        if (SetupLen > SIZE_BOS_DESC)
                            SetupLen = SIZE_BOS_DESC;
                        pDescr = (PUINT8) BOSDescriptor;
                        break;
                    case USB_DESCR_TYP_STRING:
                        switch (UsbSetupBuf->wValueL) {
                            case USB_DESCR_LANGID_STRING:
                                if (SetupLen > SIZE_STRING_LANGID)
                                    SetupLen = SIZE_STRING_LANGID;
                                pDescr = (PUINT8) StringLangID;
                                break;
                            case USB_DESCR_VENDOR_STRING:
                                if (SetupLen > SIZE_STRING_VENDOR)
                                    SetupLen = SIZE_STRING_VENDOR;
                                pDescr = (PUINT8) StringVendor;
                                break;
                            case USB_DESCR_PRODUCT_STRING:
                                if (SetupLen > SIZE_STRING_PRODUCT)
                                    SetupLen = SIZE_STRING_PRODUCT;
                                pDescr = (PUINT8) StringProduct;
                                break;
                            case USB_DESCR_SERIAL_STRING:
                                if (SetupLen > SIZE_STRING_SERIAL)
                                    SetupLen = SIZE_STRING_SERIAL;
                                pDescr = (PUINT8) StringSerial;
                                break;
                            case USB_DESCR_OS_STRING:
                                if (SetupLen > SIZE_STRING_OS)
                                    SetupLen = SIZE_STRING_OS;
                                pDescr = (PUINT8) OSStringDescriptor;
                                break;
                            default:
                                len = USB_DESCR_UNSUPPORTED;
                                SetupReqCode = INVALID_REQ_CODE;
                                break;
                        }
                        break;
                    default:
                        len = USB_DESCR_UNSUPPORTED;
                        SetupReqCode = INVALID_REQ_CODE;
                        break;
                    }
                len = SetupLen >= ENDP0_MAXPACK ? ENDP0_MAXPACK : SetupLen;
                memcpy(endp0RTbuff, pDescr, len);
                SetupLen -= len;
                pDescr += len;
                break;
            case USB_SET_ADDRESS:
                SetupLen = UsbSetupBuf->wValueL;
                break;
            case 0x31:
                SetupLen = UsbSetupBuf->wValueL;
                break;
            case 0x30:
                break;
            case USB_SET_CONFIGURATION:
                break;
            case USB_GET_STATUS:
                len = 2;
                endp0RTbuff[0] = 0x01;
                endp0RTbuff[1] = 0x00;
                SetupLen = 0;
                break;
            case USB_CLEAR_FEATURE:
                switch(UsbSetupBuf->wIndexL){
                    case 0x82:
                        USB30_IN_ClearIT( ENDP_2 );
                        USB30_IN_Set( ENDP_2 , ENABLE , ACK , 1 , 0);
                        USB30_Send_ERDY( ENDP_2 | IN , 1 );
                        break;
                }
                break;
            case USB_SET_FEATURE:
                break;
            case USB_SET_INTERFACE:
                break;
            default:
                len = USB_DESCR_UNSUPPORTED;
                SetupReqCode = INVALID_REQ_CODE;
                printf(" stall \n");
                break;
        }
    }
    return len;
}

/*******************************************************************************
 * @fn      EP0_IN_Callback
 *
 * @brief   USB3.0 Endpoint 0 IN transaction callback
 *
 * @return  Send length
 */
UINT16 EP0_IN_Callback(void) {
    UINT16 len = 0;
    switch (SetupReqCode) {
        case USB_GET_DESCRIPTOR:
            len = SetupLen >= ENDP0_MAXPACK ? ENDP0_MAXPACK : SetupLen;
            memcpy(endp0RTbuff, pDescr, len);
            SetupLen -= len;
            pDescr += len;
            break;
    }
    return len;
}

/*******************************************************************************
 * @fn      EP0_OUT_Callback
 *
 * @brief   USB3.0 Endpoint 0 OUT transaction callback
 *
 * @return  Length
 */
UINT16 EP0_OUT_Callback() {
    UINT32 baudrate;

    /* save bauds */
    baudrate = endp0RTbuff[ 0 ];
    baudrate += ((UINT32)endp0RTbuff[ 1 ] << 8 );
    baudrate += ((UINT32)endp0RTbuff[ 2 ] << 16 );
    baudrate += ((UINT32)endp0RTbuff[ 3 ] << 24 );

    vitrul_buad = baudrate;

    CDC_Uart_Init(baudrate);

    return 0;
}

/*******************************************************************************
 * @fn      USB30_Setup_Status
 *
 * @brief   USB3.0 Control transfer status stage callback
 *
 * @return  None
 */
void USB30_Setup_Status(void) {
    switch (SetupReqCode) {
    case USB_SET_ADDRESS:
        USB30_Device_Setaddress(SetupLen); // SET ADDRESS
        break;
    case 0x31:
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
void USBSS_IRQHandler (void)            //USBSS interrupt service
{
    USB30_IRQHandler();
}

/*******************************************************************************
 * @fn      TMR0_IRQHandler
 *
 * @brief   USB3.0 Connection failure timeout processing
 *
 * @return  None
 */
void TMR0_IRQHandler( ) {
    R8_TMR0_INTER_EN |= 1;
    PFIC_DisableIRQ(TMR0_IRQn);
    R8_TMR0_CTRL_MOD = RB_TMR_ALL_CLEAR;
    if(link_sta == 1 ){
        link_sta =0;
        PFIC_DisableIRQ(USBSS_IRQn);
        PFIC_DisableIRQ(LINK_IRQn);
        USB30D_init(DISABLE);
        return;
    }
    if(link_sta != 3){
        PFIC_DisableIRQ(USBSS_IRQn);
        PFIC_DisableIRQ(LINK_IRQn);
        USB30D_init(DISABLE);
        PRINT("USB2.0\n");
        R32_USB_CONTROL = 0;
        PFIC_EnableIRQ(USBHS_IRQn);
        USB20_Device_Init(ENABLE);
    }
    link_sta=1;
    return;
}


/*******************************************************************************
 * @fn      LINK_IRQHandler
 *
 * @brief   USB3.0 Link Interrupt Handler.
 *
 * @return   None
 */
void LINK_IRQHandler() //USBSS link interrupt service
{
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
        /*Successful USB3.0 communication*/
        link_sta = 3;
        PFIC_DisableIRQ(TMR0_IRQn);
        R8_TMR0_CTRL_MOD = RB_TMR_ALL_CLEAR;
        R8_TMR0_INTER_EN = 0;
        PFIC_DisableIRQ(USBHS_IRQn);
        USB20_Device_Init(DISABLE);
    }

    if(USBSS->LINK_INT_FLAG & LINK_INACT_FLAG)
    {
        USBSS->LINK_INT_FLAG = LINK_INACT_FLAG;
        USB30_Switch_Powermode(POWER_MODE_2);
    }
    if(USBSS->LINK_INT_FLAG & LINK_DISABLE_FLAG) // GO DISABLED
    {
        USBSS->LINK_INT_FLAG = LINK_DISABLE_FLAG;
        link_sta = 1;
        USB30D_init(DISABLE);
        PFIC_DisableIRQ(USBSS_IRQn);
        R8_TMR0_CTRL_MOD = RB_TMR_ALL_CLEAR;
        R8_TMR0_INTER_EN = 0;
        PFIC_DisableIRQ(TMR0_IRQn);
        PFIC_EnableIRQ(USBHS_IRQn);
        USB20_Device_Init(ENABLE);
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
        while(USBSS->LINK_STATUS & RX_WARM_RESET);
        USBSS->LINK_CTRL &= ~TX_WARM_RESET;
        mDelayuS(2);
        USB30_BUS_RESET();
        USB30_Device_Setaddress(0);

    }
    if(USBSS->LINK_INT_FLAG & HOT_RESET_FLAG) //The host may send hot reset,Note the configuration of the endpoint
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
        USBSS->LINK_CTRL &= ~TX_HOT_RESET;     // HOT RESET end
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

/*******************************************************************************
 * @fn      EP2_OUT_Callback
 *
 * @brief   USB3.0 endpoint2 out callback.
 *
 * @return   None
 */
void EP2_OUT_Callback()
{
     UINT16 rx_len;
     UINT8 nump;
     UINT8 status;
     USB30_OUT_Status(ENDP_2,&nump,&rx_len,&status);

     USBByteCount = rx_len;
     USB30_OUT_ClearIT(ENDP_2);
     USB30_OUT_Set( ENDP_2 , NRDY , 0 );

     DownloadPoint2_Busy = 0;
}

/*******************************************************************************
 * @fn      EP2_IN_Callback
 *
 * @brief   USB3.0 endpoint2 in callback.
 *
 * @return   None
 */
void EP2_IN_Callback()
{
    UINT8 nump;
    USB30_IN_ClearIT( ENDP_2 );
    USB30_IN_Set( ENDP_2 , ENABLE , NRDY , 0 , 0);
    UploadPoint2_Busy = 0;
}


/***************Endpointn IN Transaction Processing*******************/
void EP1_IN_Callback()
{

}

void EP3_IN_Callback()
{

}


void EP4_IN_Callback()
{

}


void EP5_IN_Callback()
{

}


void EP6_IN_Callback()
{

}


void EP7_IN_Callback()
{

}


/***************Endpointn OUT Transaction Processing*******************/
void EP1_OUT_Callback()
{

}

void EP3_OUT_Callback()
{

}

void EP4_OUT_Callback()
{

}


void EP5_OUT_Callback()
{

}


void EP6_OUT_Callback()
{

}


void EP7_OUT_Callback()
{

}

/*******************************************************************************
 * @fn      USB30_ITP_Callback
 *
 * @brief   USB3.0 ITP callback function
 *
 * @return  None
 */
void  USB30_ITP_Callback(UINT32 ITPCounter)
{

}
