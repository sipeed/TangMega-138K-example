/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_usb30_lib.h
* Author             : WCH
* Version            : V1.1
* Date               : 2020/12/23
* Description        :
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
*******************************************************************************/
#ifndef USB30_CH56X_USB30_LIB_H_
#define USB30_CH56X_USB30_LIB_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "CH56x_common.h"

// LINK_CFG
#define TERM_EN                 (1<<1)
#define PIPE_RESET              (1<<3)
#define LFPS_RX_PD              (1<<5)
#define CFG_EQ_EN               (1<<6)
#define DEEMPH_CFG              (1<<8)

// LINK_CTRL
#define POWER_MODE_MASK         (0x03<<0)
#define POWER_MODE_0            (0x00<<0)
#define POWER_MODE_1            (0x01<<0)
#define POWER_MODE_2            (0x02<<0)
#define POWER_MODE_3            (0x03<<0)
#define GO_DISABLED             (1<<4)
#define POLLING_EN              (1<<12)
#define TX_HOT_RESET            (1<<16)
#define RX_HOT_RESET            (1<<24)

// LINK_INT_CTRL
// LINK_INT_FLAG
#define LINK_RDY_FLAG           (1<<0)
#define LINK_RECOV_FLAG         (1<<1)
#define LINK_INACT_FLAG         (1<<2)
#define LINK_DISABLE_FLAG       (1<<3)
#define LINK_GO_U3_FLAG         (1<<4)
#define LINK_GO_U2_FLAG         (1<<5)
#define LINK_GO_U1_FLAG         (1<<6)
#define LINK_GO_U0_FLAG         (1<<7)
#define LINK_U3_WAKE_FLAG       (1<<8)
#define LINK_Ux_REJECT_FLAG     (1<<9)
#define TERM_PRESENT_FLAG       (1<<10)
#define LINK_TXEQ_FLAG          (1<<11)
#define LINK_Ux_EXIT_FLAG       (1<<12)
#define WARM_RESET_FLAG         (1<<13)
#define U3_WAKEUP_FLAG          (1<<14)
#define HOT_RESET_FLAG          (1<<15)
#define LINK_RX_DET_FLAG        (1<<20)

// LINK_STATUS
#define LINK_PRESENT            (1<<0)
#define RX_WARM_RESET           (1<<1)
#define LINK_BUSY               (1<<2)
#define LINK_READY              (1<<3)
#define LINK_TXEQ               (1<<6)
#define GO_RX_DET               (1<<7)
#define TX_WARM_RESET           (1<<8)
#define TX_Ux_EXIT              (1<<9)

// LINK_HP_BUF_CTRL
// LINK_ERR_STATUS
// LINK_ERR_CNT

// USB_CONTROL
#define DMA_EN                  (1<<0)
#define USB_ALL_CLR             (1<<1)
#define USB_FORCE_RST           (1<<2)
#define INT_BUSY_EN             (1<<3)
#define DIR_ABORT               (1<<4)
#define SETUP_FLOW_EN           (1<<5)    // if enable, data stage/status stage will begin after send ERDY
#define ITP_EN                  (1<<6)
#define HOST_MODE               (1<<7)

#define USB_ACT_IE              (1<<16)
#define USB_LMP_RX_IE           (1<<17)
#define USB_LMP_TX_IE           (1<<18)
#define USB_ITP_IE              (1<<19)
#define USB_OV_IE               (1<<20)
#define USB_ERDY_IE             (1<<21)

#define USB_ADDR_MASK           (0xff<<24)

// USB_STATUS
// #define USB_ACT_FLAG            (0x01)
// #define USB_LMP_RX_FLAG         (0x02)
// #define USB_LMP_TX_FLAG         (0x04)
// #define USB_ITP_FLAG            (0x08)
// #define USB_OV_FLAG             (0x10)
// #define USB_ERDY_FLAG           (0x20)
// #define USB_EP_ACT              (0xf<<8)
// #define USB_EP_DIR              (0x1<<12)

// HOST_STATUS
// USB_RX_LEN
// USB_ITP
// USB_ITP_ADJ
// LINK_ISO_DLY
// LINK_STREAM_ID
// LINK_ROUTE_STRING
// USB_FC_CTRL
#define USB_FC_CTRL_ERDY_OUT    (0x1)
#define USB_FC_CTRL_ERDY_IN     (0x3)
#define USB_FC_CTRL_ENDP_MASK   (0xf<<2)
#define USB_FC_CTRL_ENDP(P)     ((P)<<2)
#define USB_FC_CTRL_NUMP_MASK   (0x7<<6)
#define USB_FC_CTRL_NUMP(P)     ((P)<<6)

// LMP_TX_DATA0
// LMP_TX_DATA1
// LMP_TX_DATA2
// LMP_PORT_CAP
// LMP_RX_DATA0
// LMP_RX_DATA1
// LMP_RX_DATA2
// TP_RX_DATA0
// TP_RX_DATA1
// TP_RX_DATA2
// UEP_CFG
#define EP0_R_EN                (1<<0)
#define EP1_R_EN                (1<<1)
#define EP2_R_EN                (1<<2)
#define EP3_R_EN                (1<<3)
#define EP4_R_EN                (1<<4)
#define EP5_R_EN                (1<<5)
#define EP6_R_EN                (1<<6)
#define EP7_R_EN                (1<<7)

#define EP0_T_EN                (1<<8)
#define EP1_T_EN                (1<<9)
#define EP2_T_EN                (1<<10)
#define EP3_T_EN                (1<<11)
#define EP4_T_EN                (1<<12)
#define EP5_T_EN                (1<<13)
#define EP6_T_EN                (1<<14)
#define EP7_T_EN                (1<<15)

#define EP1_R_ISO               (1<<17)
#define EP2_R_ISO               (1<<18)
#define EP3_R_ISO               (1<<19)
#define EP4_R_ISO               (1<<20)
#define EP5_R_ISO               (1<<21)
#define EP6_R_ISO               (1<<22)
#define EP7_R_ISO               (1<<23)

// UEP0_DMA
// UEP0_RX_CTRL
// UEP0_TX_CTRL
// UEP1_TX_DMA
// UEP1_RX_DMA

// UEP1_RX_CTRL
// UEP1_TX_CTRL
#define UEPx_TRX_CTRL_TLEN_POS        (0U)
#define UEPx_TRX_CTRL_TLEN_LEN        (11U)
#define UEPx_TRX_CTRL_TLEN_MASK       (((1U << UEPx_TRX_CTRL_TLEN_LEN) - 1) << UEPx_TRX_CTRL_TLEN_POS)
#define UEPx_TRX_CTRL_TLEN_UNMASK     (~(((1U << UEPx_TRX_CTRL_TLEN_LEN) - 1) << UEPx_TRX_CTRL_TLEN_POS))
#define UEPx_TRX_CTRL_NUMP_POS        (16U)
#define UEPx_TRX_CTRL_NUMP_LEN        (5U)
#define UEPx_TRX_CTRL_NUMP_MASK       (((1U << UEPx_TRX_CTRL_NUMP_LEN) - 1) << UEPx_TRX_CTRL_NUMP_POS)
#define UEPx_TRX_CTRL_NUMP_UNMASK     (~(((1U << UEPx_TRX_CTRL_NUMP_LEN) - 1) << UEPx_TRX_CTRL_NUMP_POS))
#define UEPx_TRX_CTRL_SEQN_POS        (21U)
#define UEPx_TRX_CTRL_SEQN_LEN        (5U)
#define UEPx_TRX_CTRL_SEQN_MASK       (((1U << UEPx_TRX_CTRL_SEQN_LEN) - 1) << UEPx_TRX_CTRL_SEQN_POS)
#define UEPx_TRX_CTRL_SEQN_UNMASK     (~(((1U << UEPx_TRX_CTRL_SEQN_LEN) - 1) << UEPx_TRX_CTRL_SEQN_POS))
#define UEPx_TRX_CTRL_STAT_POS        (26U)
#define UEPx_TRX_CTRL_STAT_LEN        (2U)
#define UEPx_TRX_CTRL_STAT_MASK       (((1U << UEPx_TRX_CTRL_STAT_LEN) - 1) << UEPx_TRX_CTRL_STAT_POS)
#define UEPx_TRX_CTRL_STAT_UNMASK     (~(((1U << UEPx_TRX_CTRL_STAT_LEN) - 1) << UEPx_TRX_CTRL_STAT_POS))
#define UEPx_TRX_CTRL_LPF_POS         (28U)
#define UEPx_TRX_CTRL_LPF_LEN         (1U)
#define UEPx_TRX_CTRL_LPF_MASK        (((1U << UEPx_TRX_CTRL_LPF_LEN) - 1) << UEPx_TRX_CTRL_LPF_POS)
#define UEPx_TRX_CTRL_LPF_UNMASK      (~(((1U << UEPx_TRX_CTRL_LPF_LEN) - 1) << UEPx_TRX_CTRL_LPF_POS))
#define UEPx_TRX_CTRL_STATUS_POS      (29U)
#define UEPx_TRX_CTRL_STATUS_LEN      (1U)
#define UEPx_TRX_CTRL_STATUS_MASK     (((1U << UEPx_TRX_CTRL_STATUS_LEN) - 1) << UEPx_TRX_CTRL_STATUS_POS)
#define UEPx_TRX_CTRL_STATUS_UNMASK   (~(((1U << UEPx_TRX_CTRL_STATUS_LEN) - 1) << UEPx_TRX_CTRL_STATUS_POS))
#define UEPx_TRX_CTRL_SETUP_POS       (30U)
#define UEPx_TRX_CTRL_SETUP_LEN       (1U)
#define UEPx_TRX_CTRL_SETUP_MASK      (((1U << UEPx_TRX_CTRL_SETUP_LEN) - 1) << UEPx_TRX_CTRL_SETUP_POS)
#define UEPx_TRX_CTRL_SETUP_UNMASK    (~(((1U << UEPx_TRX_CTRL_SETUP_LEN) - 1) << UEPx_TRX_CTRL_SETUP_POS))

#define EP_TXLEN_MASK           (0x7ff<<0)
#define EP_NUMP_MASK            (0x1f<<16)
#define EP_NUMP_1                           (0x1<<16)
#define EP_NUMP_2                           (0x2<<16)
#define EP_NUMP_3                           (0x3<<16)
#define EP_NUMP_4                           (0x4<<16)
#define EP_NUMP_5                           (0x5<<16)
#define EP_NUMP_6                           (0x6<<16)
#define EP_SEQ_MASK             (0x1f<<21)
#define EP_RES_MASK             (0x3<<26)
#define EP_RES_NRDY                         (0x0<<26)
#define EP_RES_ACK                          (0x1<<26)
#define EP_RES_STALL                        (0x2<<26)
#define EP_LPF                  (0x1<<28)





#define USB_ERDY_ENDP_MASK  0xf<<4
#define USB_ERDY_NUMP_MASK  0x1f<<8
// #define USB_ITP_PREAGE       0x1<<31

#define EP_INT_FLAG         1<<31

#define ERDY_NUM_MASK           (0x1f<<24)


// USB CONTROL

#define USB_INT_EP_MASK         (0x7<<8)
#define USB_INT_RES_MASK        (0x3<<14)
#define USB_RES_ACK             (0x0<<14)
#define USB_RES_ERDY            (0x1<<14)
#define USB_RES_NRDY            (0x2<<14)
#define USB_RES_STALL           (0x3<<14)

#define USB_ACT_FLAG            (0x01)
#define USB_LMP_RX_FLAG         (0x02)
#define USB_LMP_TX_FLAG         (0x04)
#define USB_ITP_FLAG            (0x08)
#define USB_OV_FLAG             (0x10)
#define USB_ERDY_FLAG           (0x20)

#define USB_STATUS_IS       0x1<<29
#define USB_SETUP_IS        0x1<<30
#define USB_TX_DIR          0x1<<12

// LMP
#define LMP_HP                  0
#define LMP_SUBTYPE_MASK        (0xf<<5)
#define SET_LINK_FUNC           (0x1<<5)
#define U2_INACT_TOUT           (0x2<<5)
#define VENDOR_TEST             (0x3<<5)
#define PORT_CAP                (0x4<<5)
#define PORT_CFG                (0x5<<5)
#define PORT_CFG_RES            (0x6<<5)

#define LINK_SPEED              (1<<9)

#define NUM_HP_BUF              (4<<0)
#define DOWN_STREAM             (1<<16)
#define UP_STREAM               (2<<16)
#define TIE_BRK                 (1<<20)

/**********device status***********/
typedef enum _DEVICE_STATE
{
  UNCONNECTED,
  ATTACHED,
  POWERED,
  SUSPENDED,
  ADDRESSED,
  CONFIGURED
} DEVICE_STATE;
/*********************/
typedef union
{
  UINT16 w;
  struct BW
  {
    UINT8 bb1; //低字节
    UINT8 bb0;
  }
  bw;
} UINT16_UINT8;
/**********standard request command***********/
typedef struct __PACKED
{
    UINT8       bRequestType;
    UINT8       bRequest;
    UINT16_UINT8 wValue;
    UINT16_UINT8 wIndex;
    UINT16       wLength;
} *PUSB_SETUP;

#define UsbSetupBuf     ((PUSB_SETUP)endp0RTbuff)//端点0
#define ENDP0_MAXPACK       512

// status response
#define NRDY                0x00
#define ACK                 0x01
#define STALL               0x02
#define INVALID             0x03

// number of NUMP
#define NUMP_0              0x00
#define NUMP_1              0x01
#define NUMP_2              0x02
#define NUMP_3              0x03
#define NUMP_4              0x04
#define NUMP_5              0x05
#define NUMP_6              0x06


/* USB endpoint direction */
#define OUT                 0x00
#define IN                  0x80
/* USB endpoint serial number */
#define ENDP_0              0x00
#define ENDP_1              0x01
#define ENDP_2              0x02
#define ENDP_3              0x03
#define ENDP_4              0x04
#define ENDP_5              0x05
#define ENDP_6              0x06
#define ENDP_7              0x07

#define USB_DESCR_TYP_BOS       0x0f
#define USB_DESCR_UNSUPPORTED   0xffff
#define INVALID_REQ_CODE 0xFF

/* string descriptor type */
#ifndef USB_DESCR_STRING
    #define USB_DESCR_LANGID_STRING    0x00
    #define USB_DESCR_VENDOR_STRING    0x01
    #define USB_DESCR_PRODUCT_STRING   0x02
    #define USB_DESCR_SERIAL_STRING    0x03
    #define USB_DESCR_OS_STRING        0xee
#endif

#define SS_RX_CONTRL(ep) (&USBSS->UEP0_RX_CTRL)[ep*4]
#define SS_TX_CONTRL(ep) (&USBSS->UEP0_TX_CTRL)[ep*4]
/*******************************************************************************
 * @fn      USB30_Device_Init
 *
 * @brief   USB3.0 Device初始化
 *
 * @return   None
 */
static inline UINT8 USB30_Device_Init(void)
{
	USBSS->LINK_CFG = 0x140;
	USBSS->LINK_CTRL = 0x12;
	uint32_t t = 0x4c4b41;
	while(USBSS->LINK_STATUS&4)
	{
		t--;
		if(t == 0)
			return -1;
	}
	for(int i = 0; i < 8; i++)
	{
		SS_TX_CONTRL(i) = 0;
		SS_RX_CONTRL(i) = 0;
	}
	USBSS->USB_STATUS = 0x13;

	USBSS->USB_CONTROL = 0x30021;
	USBSS->UEP_CFG = 0;

	USBSS->LINK_CFG |= 2;

	USBSS->LINK_INT_CTRL = 0x10bc7d;

	USBSS->LINK_CTRL = 2;
	return 0;
}

#if 0
/*******************************************************************************
 * @fn      USB30_Lib_Getversion
 *
 * @brief   USB3.0 Device子程序库初始化
 *
 * @return   None
 */
extern UINT8 USB30_Lib_Getversion(void);

/*******************************************************************************
 * @fn      USB30_ISO_Setendp
 *
 * @brief   配置同步端点
 *
 * @return   None
 */
extern void USB30_ISO_Setendp(UINT8 num,FunctionalState Status );

/*******************************************************************************
 * @fn       USB30_ISO_Setdelay( UINT32 dly )
 *
 * @brief   设置同步延迟时间
 *
 * @param dly - 延迟时间
 *
 * @return   None
 */
extern void USB30_ISO_Setdelay( UINT32 dly );

/*******************************************************************************
 * @fn       USB30_ITP_Enable
 *
 * @brief   USB ITP使能
 *
 * @param Status - enable/disable
 *
 * @return   None
 */
extern void USB30_ITP_Enable(FunctionalState Status);

/*******************************************************************************
 * @fn     USB30_OUT_ClearPendingIT
 *
 * @brief  清除OUT事务完成中断，保留端点其他配置
 *
 * @param  endp - 将要设置的端点号
 *
 * @return   None
 */
extern void USB30_OUT_ClearPendingIT(UINT8 endp);

/*******************************************************************************
 * @fn     USB30_OUT_ITflag
 *
 * @brief  获取OUT事务完成中断标志
 *
 * @param  endp - 将要设置的端点号
 *
 * @return   1 - 有中断 0 - 无中断
 */
extern UINT8 USB30_OUT_ITflag(UINT8 endp);

/*******************************************************************************
 * @fn     USB30_IN_ClearPendingIT
 *
 * @brief  清除IN事务完成中断，保留端点其他配置
 *
 * @param  endp - 端点号
 *
 * @return   None
 */
extern void USB30_IN_ClearPendingIT(UINT8 endp);

/*******************************************************************************
 * @fn       USB30_IN_ITflagT
 *
 * @brief  获取IN事务完成中断标志
 *
 * @param  endp - 将要设置的端点号
 *
 * @return   None
 */
extern UINT8 USB30_IN_ITflag(UINT8 endp);

/*******************************************************************************
 * @fn      USB30_IN_Nump
 *
 * @brief  获取端点剩余待发送的包数量
 *
 * @return   控制传输数据阶段为OUT时，主机下发的数据长度
 */
extern UINT16 USB30_Setup_OutData(void);

/*******************************************************************************
 * @fn      USB30_IRQHandler
 *
 * @brief  USB3.0中断处理
 *
 * @return   None
 */
extern void USB30_IRQHandler();
#endif

/*******************************************************************************
 * @fn     USB30_OUT_Status
 *
 * @brief  获取端点接收数据长度
 *
 * @param  endp - 端点号
 *         nump - 端点剩余可接收的包数量
 *         len -  端点接收的数据长度，对于突发传输表示端点接收到的最后一包的包长度
 *         status -  表示主机是否还有数据包待下发， 1-此次突发结束 收到非满包 0-主机还有数据包下发
 *
 * @return   None
 */
static inline void USB30_OUT_Status(UINT8 endp,UINT8 *nump,UINT16 *len,UINT8 *status)
{
	UINT32 t = SS_RX_CONTRL(endp);
	*len = t;
	*nump = (t >>16) & 31;
	*status = (t>>28) & 7;
}

/*******************************************************************************
 * @fn     USB30_OUT_Set
 *
 * @brief  端点接收设置
 *
 * @param  endp - 将要设置的端点号
 *         nump - 端点剩余可接收的包数量
 *         status -  端点状态    0-NRDY,1-ACK,2-STALL
 *
 * @return   None
 */
static inline void USB30_OUT_Set(UINT8 endp,UINT8 status,UINT8 nump)
{
	SS_RX_CONTRL(endp) |= ((nump)<<16) | (status << 26);
}

/*******************************************************************************
 * @fn     USB30_OUT_ClearIT
 *
 * @brief  清除OUT事务完成中断,仅保留包序列号
 *
 * @param  endp - 将要设置的端点号
 *
 * @return   None
 */
static inline void USB30_OUT_ClearIT(UINT8 endp)
{
	SS_RX_CONTRL(endp) &= 0x03e00000;
}

/*******************************************************************************
 * @fn      USB30_IN_Set
 *
 * @brief  端点发送设置
 *
 * @param  endp - 端点号
 *         lpf -  end of burst标志   1-enable 0-disable
 *         nump -  端点能发送的数据包的个数
 *         status -  端点状态   0-NRDY,1-ACK,2-STALL
 *         TxLen - 端点发送最后一包的数据长度
 *
 * @return   None
 */
static inline void USB30_IN_Set(UINT8 endp,FunctionalState lpf,UINT8 status,UINT8 nump,UINT16 TxLen)
{
	SS_TX_CONTRL(endp) |= (nump<<16) | (status<<26) | (TxLen & 0x7ff) | (lpf << 28);
}

/*******************************************************************************
 * @fn      USB30_IN_ClearIT
 *
 * @brief  清除IN事务中断与端点其余状态，仅保留包序列号
 *
 * @param  endp - 端点号
 *
 * @return   None
 */
static inline void USB30_IN_ClearIT(UINT8 endp)
{
	SS_TX_CONTRL(endp) &= 0x03e00000;
}

/*******************************************************************************
 * @fn       USB30_IN_Nump
 *
 * @brief  获取端点剩余待发送的包数量
 *
 * @param  endp - 端点号
 *
 * @return   剩余待发送包数量
 */
static inline UINT8 USB30_IN_Nump(UINT8 endp)
{
	return ((SS_TX_CONTRL(endp)>>16) & 0x1f);
}

/*******************************************************************************
 * @fn      USB30_Send_ERDY
 *
 * @brief  端点流控设置  发送ERDY包
 *
 * @param  endp - 端点号   最高位表方向，低四位为端点号
 *         nump -  端点接收或发送的数据包数量
 *
 * @return   None
 */
static inline void USB30_Send_ERDY(UINT8 endp,UINT8 nump)
{
	UINT32 t = ((UINT32)(endp & 0xf) << 2) | ((UINT32)nump << 6);
	if ((endp&IN) == 0)
		USBSS->USB_FC_CTRL = t | 1;
	else
		USBSS->USB_FC_CTRL = t | 3;
}

/*******************************************************************************
 * @fn       USB30_Device_Setaddress
 *
 * @brief  设置设备地址
 *
 * @param  address - 将要设置的地址
 *
 * @return   None
 */
static inline void USB30_Device_Setaddress( UINT32 address )
{
	USBSS->USB_CONTROL &= 0x00ffffff;
	USBSS->USB_CONTROL |= address<<24;
}

/*******************************************************************************
 * @fn      USB30_switch_pwr_mode
 *
 * @brief   切换USB3.0 电源模式
 *
 * @return   None
 */
static inline  void USB30_Switch_Powermode( UINT8 pwr_mode )
{
	while((USBSS->LINK_STATUS & 4) != 0);
	USBSS->LINK_CTRL &= 0xfffffffc;
	USBSS->LINK_CTRL |= pwr_mode;
}

/*******************************************************************************
 * @fn      USB30_StandardReq
 *
 * @brief  USB设备模式标准请求命令处理
 *
 * @return   主机请求设备发送的数据长度
 */
extern UINT16 USB30_StandardReq();

/*******************************************************************************
 * @fn      USB30_NonStandardReq
 *
 * @brief  USB设备模式非标准请求命令处理
 *
 * @return   主机请求设备发送的数据长度
 */
extern UINT16 USB30_NonStandardReq();

/*******************************************************************************
 * @fn      EP0_IN_Callback
 *
 * @brief  端点0 IN传输完成回调函数
 *
 * @return   一次IN传输响应发送的数据长度
 */
extern UINT16 EP0_IN_Callback();

/*******************************************************************************
 * @fn      EP0_OUT_Callback
 *
 * @brief  端点0 OUT传输完成回调函数
 *
 * @return   None
 */
extern UINT16 EP0_OUT_Callback();

/*******************************************************************************
 * @fn      USB30_Setup_Status
 *
 * @brief   控制传输状态阶段
 *
 * @return   None
 */
extern void USB30_Setup_Status();

/*******************************************************************************
 * @fn      USB30_ITP_Callback
 *
 * @brief   ITP回调函数
 *
 * @return   None
 */
extern void USB30_ITP_Callback(UINT32 ITPCounter);

/*******************************************************************************
 * @fn      EPn_IN_Callback()
 *
 * @brief   端点n IN事务处理回调函数
 *
 * @return   None
 */
extern void  EP1_IN_Callback(void);
extern void  EP2_IN_Callback(void);
extern void  EP3_IN_Callback(void);
extern void  EP4_IN_Callback(void);
extern void  EP5_IN_Callback(void);
extern void  EP6_IN_Callback(void);
extern void  EP7_IN_Callback(void);

/*******************************************************************************
 * @fn      EPn_IN_Callback()
 *
 * @brief   端点n OUT事务处理回调函数
 *
 * @return   None
 */
extern void  EP1_OUT_Callback(void);
extern void  EP2_OUT_Callback(void);
extern void  EP3_OUT_Callback(void);
extern void  EP4_OUT_Callback(void);
extern void  EP5_OUT_Callback(void);
extern void  EP6_OUT_Callback(void);
extern void  EP7_OUT_Callback(void);

#ifdef __cplusplus
}
#endif

#endif /* USB30_CH56X_USB30_LIB_H_ */
