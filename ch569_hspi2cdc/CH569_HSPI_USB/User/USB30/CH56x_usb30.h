/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_usb30.h
* Author             : WCH
* Version            : V1.0
* Date               : 2023/02/16
*
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#ifndef USB30_CH56X_USB30_H_
#define USB30_CH56X_USB30_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "CH56x_common.h"


/* Global define */
#define endpoint_1_OUT_burst_level       1
#define endpoint_1_IN_burst_level        1
#define endpoint_2_OUT_burst_level       1
#define endpoint_2_IN_burst_level        1


#define SIZE_DEVICE_DESC      		 18
#define SIZE_CONFIG_DESC       		 85
#define SIZE_STRING_LANGID     		 4
#define SIZE_STRING_VENDOR     	     8
#define SIZE_STRING_PRODUCT    	     38
#define SIZE_STRING_SERIAL      	 22
#define SIZE_BOS_DESC      			 22
#define SIZE_STRING_OS      		 18



/* Global Variable */
extern __attribute__ ((aligned(16))) UINT8  endp0RTbuff[512] __attribute__((section(".DMADATA")));
extern __attribute__ ((aligned(16))) UINT8  endp1RTbuff[4096] __attribute__((section(".DMADATA")));
extern __attribute__ ((aligned(16))) UINT8  endp2Rxbuff[4096] __attribute__((section(".DMADATA")));
extern __attribute__ ((aligned(16))) UINT8  endp2Txbuff[4096] __attribute__((section(".DMADATA")));


extern UINT8V link_sta;

/* Function declaration */
void USB30D_init(FunctionalState sta);
void TMR0_IRQHandler() __attribute__((interrupt("WCH-Interrupt-fast")));
void LINK_IRQHandler() __attribute__((interrupt("WCH-Interrupt-fast")));
void USBSS_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));           //USB3.0 interrupt service

#ifdef __cplusplus
}
#endif

#endif /* USER_USB30_DESC_H_ */


