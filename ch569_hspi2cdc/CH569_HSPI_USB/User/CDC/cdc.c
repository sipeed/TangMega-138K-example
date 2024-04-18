/********************************** (C) COPYRIGHT *******************************
* File Name          : cdc.c
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
#include "CH56x_usb30.h"
#include "CH56x_usb20.h"
#include "cdc.h"

/* Global define */
#define UART_REV_LEN  1024                  //uart receive buffer size
#define UART_TIMEOUT  1000

/* Global Variable */
__attribute__ ((aligned(16))) UINT8 Receive_Uart_Buf[UART_REV_LEN] __attribute__((section(".DMADATA")));//uart receive buffer

volatile UINT16 Uart_Input_Point = 0;       //Circular buffer write pointer
volatile UINT16 Uart_Output_Point = 0;      //Loop buffer fetch pointer
volatile UINT16 UartByteCount = 0;          //The number of bytes remaining to be fetched in the current buffer
volatile UINT16 USBByteCount = 0;           //Data received by USB endpoint
volatile UINT16 USBBufOutPoint = 0;         //Get data pointer
volatile UINT8  UploadPoint2_Busy  = 0;     //Upload whether the endpoint is busy
volatile UINT8  DownloadPoint2_Busy  = 0;   //Download whether the endpoint is busy
volatile UINT16 Uart_Timecount = 0;         //Timeout processing calculation time
volatile UINT16 Uart_Sendlenth = 0;         //USB upload data length
/* Function declaration */
void TMR2_IRQHandler (void) __attribute__((interrupt()));
void UART2_IRQHandler (void) __attribute__((interrupt("WCH-Interrupt-fast")));

/*******************************************************************************
 * @fn        CDC_Uart_Init
 *
 * @brief     CDC UART initialization
 *
 * @param     baudrate: UART2 communication baud rate.
 *
 * @return    None
 */
void CDC_Uart_Init( UINT32 baudrate )
{
    // UINT32 x;
    // UINT32 t = FREQ_SYS;
    // x = 10 * t * 2 / 16 / baudrate;
    // x = ( x + 5 ) / 10;
    // R8_UART2_DIV = 1;
    // R16_UART2_DL = x;
    // R8_UART2_FCR = RB_FCR_FIFO_TRIG | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;
    // R8_UART2_LCR = RB_LCR_WORD_SZ;
    // R8_UART2_IER = RB_IER_TXD_EN;

    // GPIOA_SetBits(GPIO_Pin_3);
    // GPIOA_ModeCfg(GPIO_Pin_2, GPIO_ModeIN_PU_NSMT);
    // GPIOA_ModeCfg(GPIO_Pin_3, GPIO_Slowascent_PP_8mA);
    // UART2_ByteTrigCfg( UART_7BYTE_TRIG );
    // UART2_INTCfg( ENABLE, RB_IER_RECV_RDY|RB_IER_LINE_STAT );
    // PFIC_EnableIRQ( UART2_IRQn );
}


/*******************************************************************************
 * @fn        TMR2_TimerInit1
 *
 * @brief     CDC timeout timer initialization
 *
 * @return    None
 */
void TMR2_TimerInit1( void )
{
     R32_TMR2_CNT_END = FREQ_SYS/100000;                      //10us
     R8_TMR2_CTRL_MOD = RB_TMR_ALL_CLEAR;
     R8_TMR2_CTRL_MOD = RB_TMR_COUNT_EN;
     R8_TMR2_INTER_EN |= 0x01;
     PFIC_EnableIRQ( TMR2_IRQn );
}

/*******************************************************************************
 * @fn        TMR2_IRQHandler
 *
 * @brief     CDC timer interrupt function
 *
 * @return    None
 */
void TMR2_IRQHandler( void )
{
     if( R8_TMR2_INT_FLAG &0x01 )
     {
         R8_TMR2_INT_FLAG = 0x01;
         Uart_Timecount++;
     }
}

/*******************************************************************************
 * @fn        U30_CDC_UartRx_Deal
 *
 * @brief     usb3.0 CDC serial port receiving data processing
 *
 * @return    None
 */
void U30_CDC_UartRx_Deal( void )
{
    if(!UploadPoint2_Busy)
    {
        Uart_Sendlenth = UartByteCount;
        if(Uart_Sendlenth > 0)
        {
            if( (Uart_Sendlenth >= (UART_REV_LEN/2) && DownloadPoint2_Busy == 0 ) || Uart_Timecount > UART_TIMEOUT )//If the sent data overflows or times out, upload the data
            {
                if(Uart_Output_Point+Uart_Sendlenth>UART_REV_LEN)//Determine if the pointer to the stored data array is out of bounds
                {
                    Uart_Sendlenth = UART_REV_LEN-Uart_Output_Point;
                }

                if(Uart_Sendlenth > (UART_REV_LEN/2))//Limit sending length
                {
                    Uart_Sendlenth = (UART_REV_LEN/2);
                }

                UartByteCount -= Uart_Sendlenth;//Reduce the length of data to be sent
                memcpy(endp2Txbuff,&Receive_Uart_Buf[Uart_Output_Point],Uart_Sendlenth);//Copy the data to be sent to the USB buffer
                Uart_Output_Point+=Uart_Sendlenth;//Move buffer pointer

                if(Uart_Output_Point>=UART_REV_LEN)
                {
                    Uart_Output_Point = 0;
                }

                UploadPoint2_Busy = 1;
                /* Start USB sending */
                USB30_IN_ClearIT( ENDP_2 );
                USB30_IN_Set( ENDP_2 , ENABLE , ACK , 1, Uart_Sendlenth);
                USB30_Send_ERDY( ENDP_2 | IN , 1 );

                Uart_Timecount = 0;
            }
        }
    }
}

/*******************************************************************************
 * @fn        U20_CDC_UartRx_Deal
 *
 * @brief     usb2.0 CDC serial port receiving data processing
 *
 * @return    None
 */
void U20_CDC_UartRx_Deal( void )
{
    UINT16 i= 0;
    if(!UploadPoint2_Busy)
    {
        Uart_Sendlenth = UartByteCount;
        if(Uart_Sendlenth>0)
        {

            if( (Uart_Sendlenth >= (UART_REV_LEN/4)) || Uart_Timecount > UART_TIMEOUT )
            {
                if(Uart_Output_Point+Uart_Sendlenth>UART_REV_LEN)
                {
                    Uart_Sendlenth = UART_REV_LEN - Uart_Output_Point;
                }
                if(Uart_Sendlenth > (UART_REV_LEN/4))
                {
                    Uart_Sendlenth = (UART_REV_LEN/4);
                }

                UartByteCount -= Uart_Sendlenth;
                memcpy(endp2Txbuff,&Receive_Uart_Buf[Uart_Output_Point],Uart_Sendlenth);
                Uart_Output_Point+=Uart_Sendlenth;
                if(Uart_Output_Point>=UART_REV_LEN)
                {
                    Uart_Output_Point = 0;
                }

                UploadPoint2_Busy = 1;

                R16_UEP2_T_LEN = Uart_Sendlenth;
                R8_UEP2_TX_CTRL = (R8_UEP2_TX_CTRL & ~RB_UEP_TRES_MASK) | UEP_T_RES_ACK;

                Uart_Timecount = 0;
            }
        }
    }
}

/*******************************************************************************
 * @fn        U30_CDC_UartTx_Deal
 *
 * @brief     usb3.0 CDC serial port sending data processing
 *
 * @return    None
 */
void U30_CDC_UartTx_Deal( void )
{
    static UINT16 i = 0;

    if(USBByteCount)//If there is any remaining data to be downloaded, it will be sent through the uart
    {
        // UART2_SendString(&endp2Rxbuff[USBBufOutPoint++],1);
        USBByteCount --;
    }

    if( DownloadPoint2_Busy == 0 )
    {
        if(USBByteCount == 0 && UploadPoint2_Busy == 0)//Allow Next Send
        {
            USBBufOutPoint = 0;
            DownloadPoint2_Busy = 1;
            USBSS->UEP2_RX_DMA  = (UINT32)(UINT8 *)endp2Rxbuff;
            USB30_OUT_ClearIT(ENDP_2);
            USB30_OUT_Set( ENDP_2 , ACK , 1 );
            USB30_Send_ERDY( ENDP_2 | OUT , 1 );
        }
    }
}

/*******************************************************************************
 * @fn        U20_CDC_UartTx_Deal
 *
 * @brief     usb2.0 CDC serial port sending data processing
 *
 * @return    None
 */
void U20_CDC_UartTx_Deal( void )
{
    static UINT16 i = 0;
    if(USBByteCount)
    {
        // UART2_SendString(&endp2Rxbuff[USBBufOutPoint++],1);

        USBByteCount--;
        if(USBByteCount==0){
            USBBufOutPoint = 0;
            R32_UEP2_RX_DMA = (UINT32)(UINT8 *)endp2Rxbuff;
            R8_UEP2_RX_CTRL = (R8_UEP2_RX_CTRL &~RB_UEP_RRES_MASK)|UEP_R_RES_ACK;
        }
    }
}

/*******************************************************************************
 * @fn        CDC_Uart_Deal
 *
 * @brief     CDC processing function
 *
 * @return    None
 */
void CDC_Uart_Deal( void )
{
    if( link_sta == 1)//2.0
    {
        U20_CDC_UartTx_Deal();
        U20_CDC_UartRx_Deal();
    }
    else
    {
        U30_CDC_UartTx_Deal();
        U30_CDC_UartRx_Deal();
    }
}

/*******************************************************************************
 * @fn        CDC_Variable_Clear
 *
 * @brief     CDC variable initialization
 *
 * @return    None
 */
void CDC_Variable_Clear(void){
    Uart_Input_Point = 0;
    Uart_Output_Point = 0;
    UartByteCount = 0;
    USBByteCount = 0;
    USBBufOutPoint = 0;
    UploadPoint2_Busy  = 0;
    Uart_Timecount = 0;
    Uart_Sendlenth = 0;
}

/*******************************************************************************
 * @fn        UART2_IRQHandler
 *
 * @brief     CDC serial port interrupt function
 *
 * @return    None
 */
// void UART2_IRQHandler(void)
// {
//     UINT8 i,rec_length;
//     UINT8 rec[7] = {0};

//     switch( UART2_GetITFlag() )
//     {
//         case UART_II_LINE_STAT:         //Line status error
//             printf("error:%x\n",R8_UART2_LSR);
//             break;

//         case UART_II_RECV_RDY:          //Data reaches the trigger point
//             for(rec_length = 0; rec_length < 7; rec_length++)
//             {
//                 Receive_Uart_Buf[Uart_Input_Point++] = UART2_RecvByte();
//                 if(Uart_Input_Point>=UART_REV_LEN )
//                 {
//                     Uart_Input_Point = 0;
//                 }
//             }
//             UartByteCount += rec_length;
//             Uart_Timecount = 0;

//             break;
//         case UART_II_RECV_TOUT:         //Receive timeout
//             rec_length = UART2_RecvString(rec);
//             for(i = 0; i < rec_length ; i++)
//             {
//                 Receive_Uart_Buf[Uart_Input_Point++] = rec[i];
//                 if(Uart_Input_Point>=UART_REV_LEN )
//                 {
//                     Uart_Input_Point = 0;
//                 }
//             }
//             UartByteCount += i;
//             Uart_Timecount = 0;
//             break;

//         case UART_II_THR_EMPTY:         //Send buffer empty
//             break;

//         default:
//             break;
//     }
// }
