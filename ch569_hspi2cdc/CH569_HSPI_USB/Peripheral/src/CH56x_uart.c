/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_uart.c
* Author             : WCH
* Version            : V1.0
* Date               : 2020/07/31
* Description 
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/

#include "CH56x_common.h"


/******************************************************************************
 * @fn     UART0_DefInit
 *
 * @brief  Serial port default initialization configuration: FIFO enabled, trigger point byte count, serial port data length setting, baud rate and frequency division coefficient
 * 
 * @return   None
 */
void UART0_DefInit( void )
{	
    UART0_BaudRateCfg( 115200 );
    R8_UART0_FCR = (2<<6) | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;		// FIFO open, trigger point 4 bytes
    R8_UART0_LCR = RB_LCR_WORD_SZ;
    R8_UART0_IER = RB_IER_TXD_EN;
    R8_UART0_DIV = 1;
}

/*******************************************************************************
 * @fn     UART1_DefInit
 *
 * @brief  Serial port default initialization configuration: FIFO enabled, trigger point byte count, serial port data length setting, baud rate and frequency division coefficient
 * 
 * @return   None
 **/
void UART1_DefInit( void )
{
    UART1_BaudRateCfg( 115200 );
    R8_UART1_FCR = (2<<6) | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;		// FIFO open, trigger point 4 bytes
    R8_UART1_LCR = RB_LCR_WORD_SZ;
    R8_UART1_IER = RB_IER_TXD_EN;
    R8_UART1_DIV = 1;
}

/*******************************************************************************
 * @fn     UART2_DefInit
 *
 * @brief  Serial port default initialization configuration: FIFO enabled, trigger point byte count, serial port data length setting, baud rate and frequency division coefficient
 * 
 * @return   None
 */
void UART2_DefInit( void )
{
    UART2_BaudRateCfg( 115200 );
    R8_UART2_FCR = (2<<6) | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;		// FIFO open, trigger point 4 bytes
    R8_UART2_LCR = RB_LCR_WORD_SZ;
    R8_UART2_IER = RB_IER_TXD_EN;
    R8_UART2_DIV = 1;
}

/*******************************************************************************
 * @fn     UART3_DefInit
 *
 * @brief  Serial port default initialization configuration: FIFO enabled, trigger point byte count, serial port data length setting, baud rate and frequency division coefficient
 * 
 * @return   None
 */
void UART3_DefInit( void )
{
    UART3_BaudRateCfg( 115200 );
    R8_UART3_FCR = (2<<6) | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;		// FIFO open, trigger point 4 bytes
    R8_UART3_LCR = RB_LCR_WORD_SZ;
    R8_UART3_IER = RB_IER_TXD_EN;
    R8_UART3_DIV = 1;
}

/*******************************************************************************
 * @fn     UART0_BaudRateCfg
 *
 * @brief  Serial port baud rate configuration
 * 
 * @return   None
 */
void UART0_BaudRateCfg( UINT32 baudrate )
{
    UINT32	x;

    x = 10 * FREQ_SYS / 8 / baudrate;
    x = ( x + 5 ) / 10;
    R16_UART0_DL = (UINT16)x;
}

/*******************************************************************************
 * @fn     UART1_BaudRateCfg
 *
 * @brief  Serial port baud rate configuration
 * 
 * @return   None
 */
void UART1_BaudRateCfg( UINT32 baudrate )
{
    UINT32	x;

    x = 10 * FREQ_SYS / 8 / baudrate;
    x = ( x + 5 ) / 10;
    R16_UART1_DL = (UINT16)x;
}

/*******************************************************************************
 * @fn     UART2_BaudRateCfg
 *
 * @brief  Serial port baud rate configuration
 * 
 * @return   None
 */
void UART2_BaudRateCfg( UINT32 baudrate )
{
    UINT32	x;

    x = 10 * FREQ_SYS / 8 / baudrate;
    x = ( x + 5 ) / 10;
    R16_UART2_DL = (UINT16)x;
}

/*******************************************************************************
 * @fn     UART3_BaudRateCfg
 *
 * @brief  Serial port baud rate configuration
 * 
 * @return   None
 */
void UART3_BaudRateCfg( UINT32 baudrate )
{
    UINT32	x;

    x = 10 * FREQ_SYS / 8 / baudrate;
    x = ( x + 5 ) / 10;
    R16_UART3_DL = (UINT16)x;
}

/*******************************************************************************
 * @fn     UART0_ByteTrigCfg
 *
 * @brief  Serial byte trigger interrupt configuration
 *
 * @param  b - trigger bytes
 *           refer to UARTByteTRIGTypeDef
 * @return   None
 */
void UART0_ByteTrigCfg( UARTByteTRIGTypeDef b )
{
    R8_UART0_FCR = (R8_UART0_FCR&~RB_FCR_FIFO_TRIG)|(b<<6);
}

/*******************************************************************************
 * @fn     UART1_ByteTrigCfg
 *
 * @brief  Serial byte trigger interrupt configuration
 *
 * @param  b - trigger bytes
 *           refer to UARTByteTRIGTypeDef
 * @return   None
 **/
void UART1_ByteTrigCfg( UARTByteTRIGTypeDef b )
{
    R8_UART1_FCR = (R8_UART1_FCR&~RB_FCR_FIFO_TRIG)|(b<<6);
}

/*******************************************************************************
 * @fn     UART2_ByteTrigCfg
 *
 * @brief  Serial byte trigger interrupt configuration
 *
 * @param  b - trigger bytes
 *           refer to UARTByteTRIGTypeDef
 * @return   None
 */
void UART2_ByteTrigCfg( UARTByteTRIGTypeDef b )
{
    R8_UART2_FCR = (R8_UART2_FCR&~RB_FCR_FIFO_TRIG)|(b<<6);
}

/*******************************************************************************
 * @fn     UART3_ByteTrigCfg
 *
 * @brief  Serial byte trigger interrupt configuration
 *
 * @param  b - trigger bytes
 *           refer to UARTByteTRIGTypeDef
 * @return   None
 ***/
void UART3_ByteTrigCfg( UARTByteTRIGTypeDef b )
{
    R8_UART3_FCR = (R8_UART3_FCR&~RB_FCR_FIFO_TRIG)|(b<<6);
}

/*******************************************************************************
 * @fn     UART0_INTCfg
 *
 * @brief  Serial port interrupt configuration
 *
 * @param  s - interrupt control status
 *					ENABLE  - Enable the corresponding interrupt    
 *					DISABLE - Disable the corresponding interrupt
 *		   i - interrupt type
 *					RB_IER_MODEM_CHG  - Modem input status change interrupt enable bit (supported on UART0 only)
 *					RB_IER_LINE_STAT  - Receive Line Status Interrupt
 *					RB_IER_THR_EMPTY  - Send Holding Register Empty Interrupt
 *					RB_IER_RECV_RDY   - receive data interrupt
 * @return   None
 **/
void UART0_INTCfg( UINT8 s,  UINT8 i )
{
    if( s )
    {
        R8_UART0_IER |= i;
        R8_UART0_MCR |= RB_MCR_INT_OE;
    }
    else
    {
        R8_UART0_IER &= ~i;
    }
}

/*******************************************************************************
 * @fn     UART1_INTCfg
 *
 * @brief  Serial port interrupt configuration
 *
 * @param  s - interrupt control status
 *					ENABLE  - Enable the corresponding interrupt    
 *					DISABLE - Disable the corresponding interrupt
 *		   i - interrupt type
 *					RB_IER_MODEM_CHG  - Modem input status change interrupt enable bit (supported on UART0 only)
 *					RB_IER_LINE_STAT  - Receive Line Status Interrupt
 *					RB_IER_THR_EMPTY  - Send Holding Register Empty Interrupt
 *					RB_IER_RECV_RDY   - receive data interrupt
 * @return   None
 **/
void UART1_INTCfg( UINT8 s,  UINT8 i )
{
    if( s )
    {
        R8_UART1_IER |= i;
        R8_UART1_MCR |= RB_MCR_INT_OE;
    }
    else
    {
        R8_UART1_IER &= ~i;
    }
}

/*******************************************************************************
 * @fn     UART2_INTCfg
 *
 * @brief  Serial port interrupt configuration
 *
 * @param  s - interrupt control status
 *					ENABLE  - Enable the corresponding interrupt    
 *					DISABLE - Disable the corresponding interrupt
 *		   i - interrupt type
 *					RB_IER_MODEM_CHG  - Modem input status change interrupt enable bit (supported on UART0 only)
 *					RB_IER_LINE_STAT  - Receive Line Status Interrupt
 *					RB_IER_THR_EMPTY  - Send Holding Register Empty Interrupt
 *					RB_IER_RECV_RDY   - receive data interrupt
 * @return   None
 **/
void UART2_INTCfg( UINT8 s,  UINT8 i )
{
    if( s )
    {
        R8_UART2_IER |= i;
        R8_UART2_MCR |= RB_MCR_INT_OE;
    }
    else
    {
        R8_UART2_IER &= ~i;
    }
}

/*******************************************************************************
 * @fn     UART3_INTCfg
 *
 * @brief  Serial port interrupt configuration
 *
 * @param  s - interrupt control status
 *					ENABLE  - Enable the corresponding interrupt    
 *					DISABLE - Disable the corresponding interrupt
 *		   i - interrupt type
 *					RB_IER_MODEM_CHG  - Modem input status change interrupt enable bit (supported on UART0 only)
 *					RB_IER_LINE_STAT  - Receive Line Status Interrupt
 *					RB_IER_THR_EMPTY  - Send Holding Register Empty Interrupt
 *					RB_IER_RECV_RDY   - receive data interrupt
 * @return   None
 **/
void UART3_INTCfg( UINT8 s,  UINT8 i )
{
    if( s )
    {
        R8_UART3_IER |= i;
        R8_UART3_MCR |= RB_MCR_INT_OE;
    }
    else
    {
        R8_UART3_IER &= ~i;
    }
}

/*******************************************************************************
 * @fn     UART0_Reset
 *
 * @brief  Serial port software reset
 * 
 * @return  None
 **/
void UART0_Reset( void )
{
    R8_UART0_IER = RB_IER_RESET;
}

/*******************************************************************************
 * @fn     UART1_Reset
 *
 * @brief  Serial port software reset
 * 
 * @return  None
 **/
void UART1_Reset( void )
{
    R8_UART1_IER = RB_IER_RESET;
}

/*******************************************************************************
 * @fn     UART2_Reset
 *
 * @brief  Serial port software reset
 * 
 * @return  None
 **/
void UART2_Reset( void )
{
    R8_UART2_IER = RB_IER_RESET;
}

/*******************************************************************************
 * @fn     UART3_Reset
 *
 * @brief  Serial port software reset
 * 
 * @return  None
 **/
void UART3_Reset( void )
{
    R8_UART3_IER = RB_IER_RESET;
}

/*******************************************************************************
 * @fn     UART0_SendString
 *
 * @brief  Serial multi-byte transmission
 *
 * @param  buf - The first address of the data content to be sent
 *         l - length of data to be sent
 * @return   None
 */
void UART0_SendString( PUINT8 buf, UINT16 l )
{
    UINT16 len = l;

    while(len)
    {
        if(R8_UART0_TFC != UART_FIFO_SIZE)
        {
            R8_UART0_THR = *buf++;
            len--;
        }
    }
}

/*******************************************************************************
 * @fn     UART1_SendString
 *
 * @brief  Serial multi-byte transmission
 *
 * @param  buf - The first address of the data content to be sent
 *         l - length of data to be sent
 * @return   None
 */
void UART1_SendString( PUINT8 buf, UINT16 l )
{
    UINT16 len = l;

    while(len)
    {
        if(R8_UART1_TFC != UART_FIFO_SIZE)
        {
            R8_UART1_THR = *buf++;
            len--;
        }		
    }
}

/*******************************************************************************
 * @fn     UART2_SendString
 *
 * @brief  Serial multi-byte transmission
 *
 * @param  buf - The first address of the data content to be sent
 *         l - length of data to be sent
 * @return   None
 */
void UART2_SendString( PUINT8 buf, UINT16 l )
{
    UINT16 len = l;

    while(len)
    {
        if(R8_UART2_TFC != UART_FIFO_SIZE)
        {
            R8_UART2_THR = *buf++;
            len--;
        }
    }
}

/*******************************************************************************
 * @fn     UART3_SendString
 *
 * @brief  Serial multi-byte transmission
 *
 * @param  buf - The first address of the data content to be sent
 *         l - length of data to be sent
 * @return   None
 */
void UART3_SendString( PUINT8 buf, UINT16 l )
{
    UINT16 len = l;

    while(len)
    {
        if(R8_UART3_TFC != UART_FIFO_SIZE)
        {
            R8_UART3_THR = *buf++;
            len--;
        }
    }
}

/*******************************************************************************
 * @fn     UART0_RecvString
 *
 * @brief  Serial port read multibyte
 *
 * @param  buf - The first address of the read data storage buffer
 *
 * @return read data length
 */
UINT16 UART0_RecvString( PUINT8 buf )
{
    UINT16 len = 0;

    while( R8_UART0_RFC )
    {
        *buf++ = R8_UART0_RBR;
        len ++;
    }

    return (len);
}

/*******************************************************************************
 * @fn     UART1_RecvString
 *
 * @brief  Serial port read multibyte
 *
 * @param  buf - The first address of the read data storage buffer
 *
 * @return read data length
 */

UINT16 UART1_RecvString( PUINT8 buf )
{
    UINT16 len = 0;

    while( R8_UART1_RFC )
    {
        *buf++ = R8_UART1_RBR;
        len ++;
    }

    return (len);
}

/*******************************************************************************
 * @fn     UART2_RecvString
 *
 * @brief  Serial port read multibyte
 *
 * @param  buf - The first address of the read data storage buffer
 *
 * @return read data length
 */

UINT16 UART2_RecvString( PUINT8 buf )
{
    UINT16 len = 0;

    while( R8_UART2_RFC )
    {
        *buf++ = R8_UART2_RBR;
        len ++;
    }

    return (len);
}

/*******************************************************************************
 * @fn     UART3_RecvString
 *
  * @brief  Serial port read multibyte
 *
 * @param  buf - The first address of the read data storage buffer
 *
 * @return read data length
 */

UINT16 UART3_RecvString( PUINT8 buf )
{
    UINT16 len = 0;

    while( R8_UART3_RFC )
    {
        *buf++ = R8_UART3_RBR;
        len ++;
    }

    return (len);
}


