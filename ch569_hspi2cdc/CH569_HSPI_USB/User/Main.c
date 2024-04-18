/********************************** (C) COPYRIGHT *******************************
* File Name          : Main.c
* Author             : WCH
* Version            : V1.0
* Date               : 2023/02/16
*
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/

/*
 * @Note
 *  Example routine to emulate a simulate USB-CDC Device,Use UART2(PA2/PA3).
*/
#define  FREQ_SYS   120000000

#include "CH56x_common.h"
#include "CH56x_usb30.h"
#include "cdc.h"

/* Global define */
#define UART1_BAUD  115200

__attribute__ ((aligned(16))) UINT8 hspi_rx_buffer[2*4096] __attribute__((section(".DMADATA")));
#define DMA_RX_Addr0   (uint32_t)(&hspi_rx_buffer[0])
#define DMA_RX_Addr1   (uint32_t)(&hspi_rx_buffer[4096])
void HSPI_IRQHandler (void) __attribute__((interrupt("WCH-Interrupt-fast")));

/*******************************************************************************
 * @fn        DebugInit
 *
 * @brief     Initializes the UART1 peripheral.
 *
 * @param     baudrate: UART1 communication baud rate.
 *
 * @return    None
 */
void DebugInit(UINT32 baudrate)
{
    UINT32 x;
    UINT32 t = FREQ_SYS;
    x = 10 * t * 2 / 16 / baudrate;
    x = ( x + 5 ) / 10;
    R8_UART1_DIV = 1;
    R16_UART1_DL = x;
    R8_UART1_FCR = RB_FCR_FIFO_TRIG | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;
    R8_UART1_LCR = RB_LCR_WORD_SZ;
    R8_UART1_IER = RB_IER_TXD_EN;
    R32_PA_SMT |= (1<<8) |(1<<7);
    R32_PA_DIR |= (1<<8);
}

/*******************************************************************************
 * @fn      HSPI_GPIO_Init
 *
 * @brief    Initializes the HSPI GPIO.
 *
 * @return  None
 */
void HSPI_GPIO_Init(void)
{
	//TX GPIO PA9 11 21 push-pull output
	R32_PA_DIR |= (1<<9) | (1<<11) | (1<<21);

	//clk 16mA
	R32_PA_DRV |= (1<<11);

	//Rx GPIO PA10 push-pull output
	R32_PA_DIR |= (1<<10);
}


/*******************************************************************************
 * @fn       HSPI_Init
 *
 * @brief    HSPI initialization
 *
 * @return   None
 */
void HSPI_Init(void)
{
	//GPIO Cfg
	HSPI_GPIO_Init();

	R8_HSPI_CFG &= ~(RB_HSPI_MODE | RB_HSPI_MSK_SIZE);  //Clear

	R8_HSPI_CFG &= ~(RB_HSPI_MODE);   //Slave

	//data size
	R8_HSPI_CFG |= RB_HSPI_DAT16_MOD;

    //ACk mode  0   (Hardware auto-answer mode for burst mode, not for normal mode)
	R8_HSPI_CFG &= ~RB_HSPI_HW_ACK;

    //Rx ToG En  0
	R8_HSPI_CFG |= RB_HSPI_RX_TOG_EN;

    //DUDMA    1  Enable the dual DMA function, enabled by default
	R8_HSPI_CFG |= RB_HSPI_DUALDMA;
	
	//Enable fast DMA request
    R8_HSPI_AUX |= RB_HSPI_REQ_FT;

	//TX edge sampling
	R8_HSPI_AUX |= RB_HSPI_TCK_MOD;  //Falling edge sampling

	//Hardware Auto ack time
	R8_HSPI_AUX &= ~RB_HSPI_ACK_TX_MOD;

	//delay time
	R8_HSPI_AUX &= ~RB_HSPI_ACK_CNT_SEL;   //Delay 2T

	//clear ALL_CLR  TRX_RST  (reset)
	R8_HSPI_CTRL &= ~(RB_HSPI_ALL_CLR|RB_HSPI_TRX_RST);

	//Enable Interupt
	R8_HSPI_INT_EN |= RB_HSPI_IE_R_DONE;  //Single packet received completed
	R8_HSPI_INT_EN |= RB_HSPI_IE_FIFO_OV;

	//config TX custom Header
	R32_HSPI_UDF0 = 0x3ABCDEF;      //UDF0
	R32_HSPI_UDF1 = 0x3456789;      //UDF1

	//addr0 DMA TX RX addr
	// R32_HSPI_TX_ADDR0 = DMA_TX_Addr0;
	R32_HSPI_RX_ADDR0 = DMA_RX_Addr0;

	//addr1 DMA TX RX addr
	// R32_HSPI_TX_ADDR1 = DMA_TX_Addr1;
	R32_HSPI_RX_ADDR1 = DMA_RX_Addr1;

	//addr0 DMA TX addr
	// R16_HSPI_DMA_LEN0 = DMA_Tx_Len0 - 1;
	//addr1 DMA TX addr
	// R16_HSPI_DMA_LEN1 = DMA_Tx_Len1 - 1;

	//Enable HSPI  DMA
	R8_HSPI_CTRL |= RB_HSPI_ENABLE | RB_HSPI_DMA_EN;

	PFIC_EnableIRQ(HSPI_IRQn);
}

/*******************************************************************************
 * @fn        main
 *
 * @brief     main program
 *
 * @return    None
 */
int main()
{
    SystemInit(FREQ_SYS);
    Delay_Init(FREQ_SYS);

    /* Configure serial port debugging */
    DebugInit(UART1_BAUD);
    PRINT("CH56x USB3.0 & USB2.0 device test(80MHz) !\n");

    /* USB initialization */
    TMR2_TimerInit1();
    R32_USB_CONTROL = 0;
    PFIC_EnableIRQ(USBSS_IRQn);
    PFIC_EnableIRQ(LINK_IRQn);
    PFIC_EnableIRQ(TMR0_IRQn);
    R8_TMR0_INTER_EN = 1;
    TMR0_TimerInit( 67000000 );
    USB30D_init(ENABLE);

    PRINT("HSPI Slave MODE\r\n");

	mDelaymS(100);
	HSPI_Init();

    while(1)
    {
        CDC_Uart_Deal();
    }
}

#define UART_REV_LEN  1024                  //uart receive buffer size
extern __attribute__ ((aligned(16))) UINT8 Receive_Uart_Buf[UART_REV_LEN] __attribute__((section(".DMADATA")));
extern volatile UINT16 Uart_Input_Point;
extern volatile UINT16 UartByteCount;
/*********************************************************************
 * @fn      HSPI_IRQHandler
 *
 * @brief   This function handles HSPI exception.
 *
 * @return  none
 */
void HSPI_IRQHandler(void)
{
	static UINT32 Rx_Cnt = 0;

	if(R8_HSPI_INT_FLAG & RB_HSPI_IF_R_DONE){  //Single packet received completed
		R8_HSPI_INT_FLAG = RB_HSPI_IF_R_DONE;  //Clear Interrupt

        uint8_t current_rx_using_addrx = !!(R8_HSPI_RX_SC & RB_HSPI_RX_TOG);
        uint32_t *p=(uint32_t*)(0x20020000 + (current_rx_using_addrx?R32_HSPI_RX_ADDR0:R32_HSPI_RX_ADDR1));

        // PRINT("p=0x%08x\r\n", p);
        // for(int i=0;i<8;i++) {
        //     PRINT(" %08x", p[i]);
        // }
        // PRINT("\r\n");

        //Determine whether the CRC is correct
        if(R8_HSPI_RTX_STATUS & RB_HSPI_CRC_ERR){  //CRC check err
        	//R8_HSPI_CTRL &= ~RB_HSPI_ENABLE;
        	PRINT("CRC err\r\n");
        }

        //Whether the serial number received matches, (do not match, modify the package serial number)
        if(R8_HSPI_RTX_STATUS & RB_HSPI_NUM_MIS){  //do not match
        	PRINT("NUM_MIS err\r\n");
        }

        //CRC is correct, received serial number matches (data received correctly)
        if((R8_HSPI_RTX_STATUS & (RB_HSPI_CRC_ERR|RB_HSPI_NUM_MIS))==0){
#if (HSPI_MODE==Slave_MODE)
        	Rx_Cnt++;
			
			uint16_t rx_len = current_rx_using_addrx?R16_HSPI_RX_LEN0:R16_HSPI_RX_LEN1;
			
			uint16_t remain = UART_REV_LEN - Uart_Input_Point;
			if (rx_len <= remain) remain = 0;
			else {
				uint16_t left = rx_len - remain;
				rx_len = remain;
				remain = left;
			}
			
			memcpy(&Receive_Uart_Buf[Uart_Input_Point], p, rx_len);
			Uart_Input_Point += rx_len;
			UartByteCount += rx_len;
			if (remain) {
				Uart_Input_Point = 0;
				memcpy(&Receive_Uart_Buf[Uart_Input_Point], p + rx_len, remain);
				Uart_Input_Point += remain;
				UartByteCount += remain;
			}

    		PRINT("[%u]R %u\r\n", Rx_Cnt, rx_len);

#endif

        }
	}

	if(R8_HSPI_INT_FLAG & RB_HSPI_IF_FIFO_OV){   //FIFO OV
		R8_HSPI_INT_FLAG = RB_HSPI_IF_FIFO_OV;  //Clear Interrupt

		PRINT("FIFO OV\r\n");

	}

}