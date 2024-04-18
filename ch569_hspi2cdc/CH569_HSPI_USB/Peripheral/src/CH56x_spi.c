/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_spi.c
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

/*******************************************************************************
 * @fn     SPI0_MasterDefInit
 *
 * @brief  Host mode default initialization
 *
 * @return   None
 */
void SPI0_MasterDefInit( void )
{
    R8_SPI0_CLOCK_DIV = 4;                                   //Main frequency clock divided by 4
    R8_SPI0_CTRL_MOD = RB_SPI_ALL_CLEAR;                     //FIFO/counter/interrupt flag register is cleared to 0, write 1 to force clear or clear
    R8_SPI0_CTRL_MOD = RB_SPI_MOSI_OE | RB_SPI_SCK_OE ;      //MOSI pin and SCK pin output enable
    R8_SPI0_CTRL_CFG |= RB_SPI_AUTO_IF;                      //Enable access to BUFFER/FIFO to automatically clear the flag
    R8_SPI0_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;                  //Do not start DMA mode
}

/*******************************************************************************
 * @fn     SPI0_DataMode
 *
 * @brief  Set data flow mode
 *
 * @param  m - data flow mode
 *
 * @return   None
 */
void SPI0_DataMode( ModeBitOrderTypeDef m )
{
    switch( m )
    {
        case Mode0_LowBitINFront:                       //Mode 0, low order first
            R8_SPI0_CTRL_MOD &= ~RB_SPI_MST_SCK_MOD;
            R8_SPI0_CTRL_CFG |= RB_SPI_BIT_ORDER;
            break;
        case Mode0_HighBitINFront:                      //Mode 0, high bit first
            R8_SPI0_CTRL_MOD &= ~RB_SPI_MST_SCK_MOD;
            R8_SPI0_CTRL_CFG &= ~RB_SPI_BIT_ORDER;
            break;
        case Mode3_LowBitINFront:                       //Mode 3, low bit first
            R8_SPI0_CTRL_MOD |= RB_SPI_MST_SCK_MOD;
            R8_SPI0_CTRL_CFG |= RB_SPI_BIT_ORDER;
            break;
        case Mode3_HighBitINFront:                      //Mode 3, high bit first
            R8_SPI0_CTRL_MOD |= RB_SPI_MST_SCK_MOD;
            R8_SPI0_CTRL_CFG &= ~RB_SPI_BIT_ORDER;
            break;
        default:
            break;
    }
}

/*******************************************************************************
 * @fn     SPI0_MasterSendByte
 *
 * @brief  Send a single byte (buffer)
 *
 * @param  d - send bytes
 *
 * @return  None
 */
void SPI0_MasterSendByte( UINT8 d )
{
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R8_SPI0_BUFFER = d;
    while( !(R8_SPI0_INT_FLAG & RB_SPI_FREE) );
}

/*******************************************************************************
 * @fn     SPI0_MasterRecvByte
 *
 * @brief  Receive a single byte (buffer)
 *
 * @return   bytes received
 */
UINT8 SPI0_MasterRecvByte( void )
{
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R8_SPI0_BUFFER = 0xFF;                                //start transfer
    while( !(R8_SPI0_INT_FLAG & RB_SPI_FREE) );
    return ( R8_SPI0_BUFFER );
}

/*******************************************************************************
 * @fn     SPI0_MasterTrans
 *
 * @brief  Continuously send multiple bytes using FIFO
 *
 * @param  pbuf: The first address of the data content to be sent
 *
 * @return   None
 */
void SPI0_MasterTrans( UINT8 *pbuf, UINT16 len )
{
    UINT16 sendlen;

    sendlen = len;
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;        //Set data direction to output
    R16_SPI0_TOTAL_CNT = sendlen;                //Set the length of the data to be sent
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END;
    while( sendlen )
    {
        if( R8_SPI0_FIFO_COUNT < SPI_FIFO_SIZE )
        {
            R8_SPI0_FIFO = *pbuf;
            pbuf++;
            sendlen--;
        }
    }
    while( R8_SPI0_FIFO_COUNT != 0 );             //Wait for all the data in the FIFO to be sent
}

/*******************************************************************************
 * @fn     SPI0_MasterRecv
 *
 * @brief  Receive multiple bytes continuously using FIFO
 *
 * @param  pbuf: The first address of the data content to be sent
 *
 * @return   None
 **/
void SPI0_MasterRecv( UINT8 *pbuf, UINT16 len )
{
    UINT16  readlen;

    readlen = len;
    R8_SPI0_CTRL_MOD |= RB_SPI_FIFO_DIR;          //Set data direction to input
    R16_SPI0_TOTAL_CNT = len;                     //Set the length of the data to be received, the FIFO direction will start the transmission if the input length is not 0
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END;
    while( readlen )
    {
        if( R8_SPI0_FIFO_COUNT )
        {
            *pbuf = R8_SPI0_FIFO;
            pbuf++;
            readlen--;
        }
    }
}

/*******************************************************************************
 * @fn     SPI0_MasterDMATrans
 *
 * @brief  Continuously send data in DMA mode
 *
 * @param  pbuf: The starting address of the data to be sent
 *
 * @return   None
 */
void SPI0_MasterDMATrans( PUINT8 pbuf, UINT16 len)
{
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R32_SPI0_DMA_BEG = (UINT32)pbuf;
    R32_SPI0_DMA_END = (UINT32)(pbuf + len);
    R16_SPI0_TOTAL_CNT = len;
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END|RB_SPI_IF_DMA_END;
    R8_SPI0_CTRL_CFG |= RB_SPI_DMA_ENABLE;
    while(!(R8_SPI0_INT_FLAG & RB_SPI_IF_CNT_END));
    R8_SPI0_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;
}

/*******************************************************************************
 * @fn     SPI0_MasterDMARecv
 *
 * @brief  Receive data continuously in DMA mode
 *
 * @param  pbuf: The starting address for storing the data to be received
 *
 * @return   None
 **/
void SPI0_MasterDMARecv( PUINT8 pbuf, UINT16 len)
{
    R8_SPI0_CTRL_MOD |= RB_SPI_FIFO_DIR;
    R32_SPI0_DMA_BEG = (UINT32)pbuf;
    R32_SPI0_DMA_END = (UINT32)(pbuf + len);
    R16_SPI0_TOTAL_CNT = len;
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END|RB_SPI_IF_DMA_END;
    R8_SPI0_CTRL_CFG |= RB_SPI_DMA_ENABLE;
    while(!(R8_SPI0_INT_FLAG & RB_SPI_IF_CNT_END));
    R8_SPI0_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;
}

/*******************************************************************************
 * @fn     SPI0_SlaveInit
 *
 * @brief  Device mode default initialization
 * 
 * @return   None
 */
void SPI0_SlaveInit( void )
{
    R8_SPI0_CTRL_MOD = RB_SPI_ALL_CLEAR;             //FIFO/counter/interrupt flag register is cleared to 0, write 1 to force clear or clear
    R8_SPI0_CTRL_MOD = RB_SPI_MISO_OE | RB_SPI_MODE_SLAVE;
    R8_SPI0_CTRL_CFG |= RB_SPI_AUTO_IF;              //Enable access to BUFFER/FIFO to automatically clear the flag
}

/*******************************************************************************
 * @fn     SPI0_SlaveRecvByte
 *
 * @brief  Slave mode, receive one byte of data
 * 
 * @return   received data
 */
UINT8 SPI0_SlaveRecvByte( void )
{
    R8_SPI0_CTRL_MOD |= RB_SPI_FIFO_DIR;              //Set to input mode, receive data
    while( R8_SPI0_FIFO_COUNT == 0 );
    return R8_SPI0_FIFO;
}

/*******************************************************************************
 * @fn     SPI0_SlaveRecvByte
 *
 * @brief  Slave mode, send one byte of data
 * 
 * @return   received data
 **/
void SPI0_SlaveSendByte( UINT8 d )
{
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;              //Set data direction to output
    R8_SPI0_FIFO = d;
    while( R8_SPI0_FIFO_COUNT != 0 );                  //Wait for the send to complete
}

/*******************************************************************************
 * @fn     SPI0_SlaveRecv
 *
 * @brief  Slave mode, receive multi-byte data
 *
 * @param  pbuf: Receive data storage starting address
 *
 * @return   None
 **/
void SPI0_SlaveRecv( PUINT8 pbuf, UINT16 len )
{
    UINT16 revlen;

    revlen = len;
    R8_SPI0_CTRL_MOD |= RB_SPI_FIFO_DIR;                //Set to input mode, receive data
    R16_SPI0_TOTAL_CNT = revlen;                        //Assign a value to the SPI send and receive data total length register
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END;               //SPI interrupt flag register All bytes transfer complete flag, write 1 to clear 0
    while( revlen )
    {
        if( R8_SPI0_FIFO_COUNT )                        //Byte count in the current FIFO
        {
            *pbuf = R8_SPI0_FIFO;
            pbuf++;
            revlen--;
        }
    }
}

/*******************************************************************************
 * @fn     SPI0_SlaveTrans
 *
 * @brief  Slave mode, send multi-byte data
 *
 * @param  pbuf: The first address of the data content to be sent
 *
 * @return   None
 */
void SPI0_SlaveTrans( UINT8 *pbuf, UINT16 len )
{
    UINT16 sendlen;

    sendlen = len;
    R8_SPI0_CTRL_MOD &= ~RB_SPI_FIFO_DIR;              //Set data direction to output
    R16_SPI0_TOTAL_CNT = sendlen;                      //Set the length of the data to be sent
    R8_SPI0_INT_FLAG = RB_SPI_IF_CNT_END;              //SPI interrupt flag register All bytes transfer complete flag, write 1 to clear 0
    while( sendlen )
    {
        if( R8_SPI0_FIFO_COUNT < SPI_FIFO_SIZE )       //Compare the byte count size in the current FIFO
        {
            R8_SPI0_FIFO = *pbuf;
            pbuf++;
            sendlen--;
        }
    }
    while( R8_SPI0_FIFO_COUNT != 0 );                  //Wait for all the data in the FIFO to be sent
}


/*******************************************************************************
 * @fn     SPI1_MasterDefInit
 *
 * @brief  Host mode default initialization
 *
 * @return   None
 */
void SPI1_MasterDefInit( void )
{
    R8_SPI1_CLOCK_DIV = 4;                                   //Main frequency clock divided by 4
    R8_SPI1_CTRL_MOD = RB_SPI_ALL_CLEAR;
    R8_SPI1_CTRL_MOD = RB_SPI_MOSI_OE | RB_SPI_SCK_OE ;
    R8_SPI1_CTRL_CFG |= RB_SPI_AUTO_IF;
    R8_SPI1_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;                  //Do not start DMA mode
    //R8_SPI1_CTRL_CFG |= RB_SPI_DMA_ENABLE;                   //Start DMA mode
}

/*******************************************************************************
 * @fn     SPI1_DataMode
 *
 * @brief  Set data flow mode
 *
 * @param  m: data flow mode
 *
 * @return   None
 ***/
void SPI1_DataMode( ModeBitOrderTypeDef m )
{
    switch( m )
    {
        case Mode0_LowBitINFront:
            R8_SPI1_CTRL_MOD &= ~RB_SPI_MST_SCK_MOD;
            R8_SPI1_CTRL_CFG |= RB_SPI_BIT_ORDER;
            break;
        case Mode0_HighBitINFront:
            R8_SPI1_CTRL_MOD &= ~RB_SPI_MST_SCK_MOD;
            R8_SPI1_CTRL_CFG &= ~RB_SPI_BIT_ORDER;
            break;
        case Mode3_LowBitINFront:
            R8_SPI1_CTRL_MOD |= RB_SPI_MST_SCK_MOD;
            R8_SPI1_CTRL_CFG |= RB_SPI_BIT_ORDER;
            break;
        case Mode3_HighBitINFront:
            R8_SPI1_CTRL_MOD |= RB_SPI_MST_SCK_MOD;
            R8_SPI1_CTRL_CFG &= ~RB_SPI_BIT_ORDER;
            break;
        default:
            break;
    }
}

/*******************************************************************************
 * @fn     SPI1_MasterSendByte
 *
 * @brief  Send a single byte (buffer)
 *
 * @param  d - send bytes
 *
 * @return   None
 */
void SPI1_MasterSendByte( UINT8 d )
{
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R8_SPI1_BUFFER = d;
    while( !(R8_SPI1_INT_FLAG & RB_SPI_FREE) );
}

/*******************************************************************************
 * @fn     SPI1_MasterRecvByte
 *
 * @brief  Receive a single byte (buffer)
 *
 * @return   bytes received
 */
UINT8 SPI1_MasterRecvByte( void )
{
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R8_SPI1_BUFFER = 0xFF;                     //start transfer
    while( !(R8_SPI1_INT_FLAG & RB_SPI_FREE) );
    return ( R8_SPI1_BUFFER );
}

/*******************************************************************************
 * @fn     SPI1_MasterTrans
 *
 * @brief  Continuously send multiple bytes using FIFO
 *
 * @param  pbuf - The first address of the data content to be sent
 *         len - The length of the data sent by the request, the maximum is 4095
 * @return   None
 */
void SPI1_MasterTrans( UINT8 *pbuf, UINT16 len )
{
    UINT16 sendlen;

    sendlen = len;
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;        //Set data direction to output
    R16_SPI1_TOTAL_CNT = sendlen;                //Set the length of the data to be sent
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END;
    while( sendlen )
    {
        if( R8_SPI1_FIFO_COUNT < SPI_FIFO_SIZE )
        {
            R8_SPI1_FIFO = *pbuf;
            pbuf++;
            sendlen--;
        }
    }
    while( R8_SPI1_FIFO_COUNT != 0 );             //Wait for all the data in the FIFO to be sent
}

/*******************************************************************************
 * @fn     SPI1_MasterRecv
 *
 * @brief  Receive multiple bytes continuously using FIFO
 *
 * @param  pbuf - The first address of the data content to be sent
 *         len - The length of the data sent by the request, the maximum is 4095
 * @return   None
 **/
void SPI1_MasterRecv( UINT8 *pbuf, UINT16 len )
{
    UINT16  readlen;

    readlen = len;
    R8_SPI1_CTRL_MOD |= RB_SPI_FIFO_DIR;         //Set data direction to input
    R16_SPI1_TOTAL_CNT = len;                    //Set the length of the data to be received, the FIFO direction will start the transmission if the input length is not 0
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END;
    while( readlen )
    {
        if( R8_SPI1_FIFO_COUNT )
        {
            *pbuf = R8_SPI1_FIFO;
            pbuf++;
            readlen--;
        }
    }
}

/*******************************************************************************
 * @fn     SPI1_MasterDMATrans
 *
 * @brief  Continuously send data in DMA mode
 *
 * @param  pbuf - The starting address of the data to be sent
 *         len - With send data length
 * @return   None
 */
void SPI1_MasterDMATrans( PUINT8 pbuf, UINT16 len)
{
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R32_SPI1_DMA_BEG = (UINT32)pbuf;
    R32_SPI1_DMA_END = (UINT32)(pbuf + len);
    R16_SPI1_TOTAL_CNT = len;
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END|RB_SPI_IF_DMA_END;
    R8_SPI1_CTRL_CFG |= RB_SPI_DMA_ENABLE;
    while(!(R8_SPI1_INT_FLAG & RB_SPI_IF_CNT_END));
    R8_SPI1_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;
}

/*******************************************************************************
 * @fn     SPI1_MasterDMARecv
 *
 * @brief  Receive data continuously in DMA mode
 *
 * @param  pbuf - The starting address for storing the data to be received
 *         len - Data length to be received
 *
 * @return   None
 */
void SPI1_MasterDMARecv( PUINT8 pbuf, UINT16 len)
{
    R8_SPI1_CTRL_MOD |= RB_SPI_FIFO_DIR;
    R32_SPI1_DMA_BEG = (UINT32)pbuf;
    R32_SPI1_DMA_END = (UINT32)(pbuf + len);
    R16_SPI1_TOTAL_CNT = len;
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END|RB_SPI_IF_DMA_END;
    R8_SPI1_CTRL_CFG |= RB_SPI_DMA_ENABLE;
    while(!(R8_SPI0_INT_FLAG & RB_SPI_IF_CNT_END));
    R8_SPI1_CTRL_CFG &= ~RB_SPI_DMA_ENABLE;
}

/*******************************************************************************
 * @fn     SPI1_SlaveInit
 *
 * @brief  Device mode default initialization
 *
 * @return   None
 */
void SPI1_SlaveInit( void )
{
    R8_SPI1_CTRL_MOD = RB_SPI_ALL_CLEAR;
    R8_SPI1_CTRL_MOD = RB_SPI_MISO_OE | RB_SPI_MODE_SLAVE;
    R8_SPI1_CTRL_CFG |= RB_SPI_AUTO_IF;
}

/*******************************************************************************
 * @fn     SPI1_SlaveRecvByte
 *
 * @brief  Slave mode, receive one byte of data
 * 
 * @return   received data
 */
UINT8 SPI1_SlaveRecvByte( void )
{
    R8_SPI1_CTRL_MOD |= RB_SPI_FIFO_DIR;
    while( R8_SPI1_FIFO_COUNT == 0 );
    return R8_SPI1_FIFO;
}

/*******************************************************************************
 * @fn     SPI1_SlaveRecvByte
 *
 * @brief  Slave mode, receive one byte of data
 * 
 * @return   received data
 */
void SPI1_SlaveSendByte( UINT8 d )
{
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;
    R8_SPI1_FIFO = d;
    while( R8_SPI1_FIFO_COUNT != 0 );        //Wait for the send to complete
}

/*******************************************************************************
 * @fn     SPI1_SlaveRecv
 * @brief  Slave mode, receive multi-byte data
 * @param  pbuf - Receive data storage starting address
 *         len - Request to receive data length
 * @return   None
 */
void SPI1_SlaveRecv( PUINT8 pbuf, UINT16 len )
{
    UINT16 revlen;

    revlen = len;
    R8_SPI1_CTRL_MOD |= RB_SPI_FIFO_DIR;
    R16_SPI1_TOTAL_CNT = revlen;
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END;
    while( revlen )
    {
        if( R8_SPI1_FIFO_COUNT )
        {
            *pbuf = R8_SPI1_FIFO;
            pbuf++;
            revlen--;
        }
    }
}

/*******************************************************************************
 * @fn     SPI1_SlaveTrans
 *
 * @brief  Slave mode, send multi-byte data
 *
 * @param  pbuf - The first address of the data content to be sent
 *         len - The length of the data sent by the request, the maximum is 4095
 * @return   None
 */
void SPI1_SlaveTrans( UINT8 *pbuf, UINT16 len )
{
    UINT16 sendlen;

    sendlen = len;
    R8_SPI1_CTRL_MOD &= ~RB_SPI_FIFO_DIR;              //Set data direction to output
    R16_SPI1_TOTAL_CNT = sendlen;                      //Set the length of the data to be sent
    R8_SPI1_INT_FLAG = RB_SPI_IF_CNT_END;
    while( sendlen )
    {
        if( R8_SPI1_FIFO_COUNT < SPI_FIFO_SIZE )
        {
            R8_SPI1_FIFO = *pbuf;
            pbuf++;
            sendlen--;
        }
    }
    while( R8_SPI1_FIFO_COUNT != 0 );                   //Wait for all the data in the FIFO to be sent
}







