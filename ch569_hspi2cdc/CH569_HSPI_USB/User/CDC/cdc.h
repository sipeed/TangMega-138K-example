/********************************** (C) COPYRIGHT *******************************
* File Name          : cdc.h
* Author             : WCH
* Version            : V1.0
* Date               : 2023/02/16
*
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#ifndef CDC_CDC_H_
#define CDC_CDC_H_


extern volatile UINT16 USBByteCount;
extern volatile UINT16 USBBufOutPoint;
extern volatile UINT8  UploadPoint2_Busy;
extern volatile UINT8  DownloadPoint2_Busy;
extern volatile UINT16 Uart_Sendlenth;

void CDC_Uart_Init( UINT32 baudrate );
void TMR2_TimerInit1( void );
void CDC_Uart_Deal( void );
void CDC_Variable_Clear(void);

#endif /* CDC_CDC_H_ */
