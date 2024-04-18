/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_uart.h
* Author             : WCH
* Version            : V1.0
* Date               : 2020/07/31
* Description
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/


#ifndef __CH56x_UART_H__
#define __CH56x_UART_H__

#ifdef __cplusplus
 extern "C" {
#endif


/** 
  * @brief	Line Error Status Definition
  */     
#define  STA_ERR_BREAK      RB_LSR_BREAK_ERR       // Data Interval Error     
#define  STA_ERR_FRAME      RB_LSR_FRAME_ERR       // DataFrame error     
#define  STA_ERR_PAR        RB_LSR_PAR_ERR         // Parity bit error
#define  STA_ERR_FIFOOV     RB_LSR_OVER_ERR        // Receive Data Overflow  
     
#define  STA_TXFIFO_EMP     RB_LSR_TX_FIFO_EMP     // The current send FIFO is empty, you can continue to fill the send data
#define  STA_TXALL_EMP      RB_LSR_TX_ALL_EMP      // All currently sent data has been sent     
#define  STA_RECV_DATA      RB_LSR_DATA_RDY        // Data is currently received


/**
  * @brief  Serial port byte trigger configuration
  */     
typedef enum
{
	UART_1BYTE_TRIG = 0,              // 1 byte trigger
	UART_2BYTE_TRIG = 1,              // 2 byte trigger
	UART_4BYTE_TRIG = 2,              // 4 byte trigger
	UART_7BYTE_TRIG = 3 ,             // 7 byte trigger
	
}UARTByteTRIGTypeDef;     
 
 
/****************** UART0 */ 
void UART0_DefInit( void );	 							/* Serial port default initialization configuration */
void UART0_BaudRateCfg( UINT32 baudrate );	 			/* Serial port baud rate configuration */
void UART0_ByteTrigCfg( UARTByteTRIGTypeDef b );        /* Serial byte trigger interrupt configuration */
void UART0_INTCfg( UINT8 s,  UINT8 i );		            /* Serial port interrupt configuration */
void UART0_Reset( void );								/* Serial port software reset */

#define UART0_CLR_RXFIFO()       (R8_UART0_FCR |= RB_FCR_RX_FIFO_CLR)          /* Clear the current receive FIFO */
#define UART0_CLR_TXFIFO()       (R8_UART0_FCR |= RB_FCR_TX_FIFO_CLR)          /* Clear the current transmit FIFO */

#define UART0_GetITFlag()       (R8_UART0_IIR & RB_IIR_INT_MASK)          /* Get the current interrupt flag */
// please refer to LINE error and status define
#define UART0_GetLinSTA()       (R8_UART0_LSR)          /* Get the current communication status */
#define UART0_GetMSRSTA()       (R8_UART0_MSR)          /* Get the current flow control status, only applicable to UART0 */

#define	UART0_SendByte(b)		(R8_UART0_THR = b)		/* Serial port single byte transmission */
void UART0_SendString( PUINT8 buf, UINT16 l );			/* Serial multi-byte transmission */
#define	UART0_RecvByte()		( R8_UART0_RBR )        /* Serial port read single byte */
UINT16 UART0_RecvString( PUINT8 buf );					/* Serial port read multibyte */

      
/****************** UART1 */ 	 
void UART1_DefInit( void );	 							/* Serial port default initialization configuration */
void UART1_BaudRateCfg( UINT32 baudrate );	 			/* Serial port baud rate configuration */
void UART1_ByteTrigCfg( UARTByteTRIGTypeDef b );        /* Serial byte trigger interrupt configuration */
void UART1_INTCfg( UINT8 s,  UINT8 i );		            /* Serial port interrupt configuration */
void UART1_Reset( void );								/* Serial port software reset */

#define UART1_CLR_RXFIFO()       (R8_UART1_FCR |= RB_FCR_RX_FIFO_CLR)          /* Clear the current receive FIFO */
#define UART1_CLR_TXFIFO()       (R8_UART1_FCR |= RB_FCR_TX_FIFO_CLR)          /* Clear the current transmit FIFO */

#define UART1_GetITFlag()       (R8_UART1_IIR&RB_IIR_INT_MASK)          /* Get the current interrupt flag */
// please refer to LINE error and status define
#define UART1_GetLinSTA()       (R8_UART1_LSR)          /* Get the current communication status */

#define	UART1_SendByte(b)		(R8_UART1_THR = b)		/* Serial port single byte transmission */
void UART1_SendString( PUINT8 buf, UINT16 l );			/* Serial multi-byte transmission */
#define	UART1_RecvByte()		( R8_UART1_RBR )        /* Serial port read single byte */
UINT16 UART1_RecvString( PUINT8 buf );					/* Serial port read multibyte */



/****************** UART2 */ 
void UART2_DefInit( void );	 							/* Serial port default initialization configuration */
void UART2_BaudRateCfg( UINT32 baudrate );	 			/* Serial port baud rate configuration */
void UART2_ByteTrigCfg( UARTByteTRIGTypeDef b );        /* Serial byte trigger interrupt configuration */
void UART2_INTCfg( UINT8 s,  UINT8 i );		            /* Serial port interrupt configuration */
void UART2_Reset( void );								/* Serial port software reset */

#define UART2_CLR_RXFIFO()       (R8_UART2_FCR |= RB_FCR_RX_FIFO_CLR)          /* Clear the current receive FIFO */
#define UART2_CLR_TXFIFO()       (R8_UART2_FCR |= RB_FCR_TX_FIFO_CLR)          /* Clear the current transmit FIFO */

#define UART2_GetITFlag()       (R8_UART2_IIR&RB_IIR_INT_MASK)          /* Get the current interrupt flag */
// please refer to LINE error and status define
#define UART2_GetLinSTA()       (R8_UART2_LSR)          /* Get the current communication status */

#define	UART2_SendByte(b)		(R8_UART2_THR = b)		/* Serial port single byte transmission */
void UART2_SendString( PUINT8 buf, UINT16 l );			/* Serial multi-byte transmission */
#define	UART2_RecvByte()		( R8_UART2_RBR )        /* Serial port read single byte */
UINT16 UART2_RecvString( PUINT8 buf );					/* Serial port read multibyte */


/****************** UART3 */ 
void UART3_DefInit( void );	 							/* Serial port default initialization configuration */
void UART3_BaudRateCfg( UINT32 baudrate );	 			/* Serial port baud rate configuration */
void UART3_ByteTrigCfg( UARTByteTRIGTypeDef b );        /* Serial byte trigger interrupt configuration */
void UART3_INTCfg( UINT8 s,  UINT8 i );		            /* Serial port interrupt configuration */
void UART3_Reset( void );								/* Serial port software reset */

#define UART3_CLR_RXFIFO()       (R8_UART3_FCR |= RB_FCR_RX_FIFO_CLR)          /* Clear the current receive FIFO */
#define UART3_CLR_TXFIFO()       (R8_UART3_FCR |= RB_FCR_TX_FIFO_CLR)          /* Clear the current transmit FIFO */

#define UART3_GetITFlag()       (R8_UART3_IIR&RB_IIR_INT_MASK)          /* Get the current interrupt flag */
// please refer to LINE error and status define
#define UART3_GetLinSTA()       (R8_UART3_LSR)          /* Get the current communication status */

#define	UART3_SendByte(b)		(R8_UART3_THR = b)		/* Serial port single byte transmission */
void UART3_SendString( PUINT8 buf, UINT16 l );			/* Serial multi-byte transmission */
#define	UART3_RecvByte()		( R8_UART3_RBR )        /* Serial port read single byte */
UINT16 UART3_RecvString( PUINT8 buf );					/* Serial port read multibyte */

	 
	 
#ifdef __cplusplus
}
#endif

#endif  // __CH56x_UART_H__	

