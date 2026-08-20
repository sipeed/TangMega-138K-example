/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_usb30.h
* Author             : WCH
* Version            : V1.1
* Date               : 2020/12/23
* Description        :
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* SPDX-License-Identifier: Apache-2.0
*******************************************************************************/
#ifndef USB30_CH56X_USB30_H_
#define USB30_CH56X_USB30_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

#include "global_variables.h"

/* Global define */
#define DEF_ENDP1_OUT_BURST_LEVEL       4
#define DEF_ENDP1_IN_BURST_LEVEL        4
#define DEF_ENDP2_OUT_BURST_LEVEL       4
#define DEF_ENDP2_IN_BURST_LEVEL        4
#define DEF_ENDP3_OUT_BURST_LEVEL       4
#define DEF_ENDP3_IN_BURST_LEVEL        4
#define DEF_ENDP4_OUT_BURST_LEVEL       4
#define DEF_ENDP4_IN_BURST_LEVEL        4
#define DEF_ENDP5_OUT_BURST_LEVEL       4
#define DEF_ENDP5_IN_BURST_LEVEL        4
#define DEF_ENDP6_OUT_BURST_LEVEL       4
#define DEF_ENDP6_IN_BURST_LEVEL        4
#define DEF_ENDP7_OUT_BURST_LEVEL       4
#define DEF_ENDP7_IN_BURST_LEVEL        4

/* Global Variable */
extern __attribute__ ((aligned(16))) volatile uint8_t  endp0RTbuff[512] __attribute__((section(".DMADATA")));    //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp1RTbuff[PACKET_SIZE] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp2RTbuff[PACKET_SIZE*PACKET_MAX_NUM] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp3RTbuff[0] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp4RTbuff[0] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp5RTbuff[0] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp6RTbuff[0] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区
extern __attribute__ ((aligned(16))) volatile uint8_t  endp7RTbuff[0] __attribute__((section(".DMADATA"))); //数据发送/接收缓冲区

/* Function declaration */
void USB30D_init(bool sta);

#ifdef __cplusplus
}
#endif

#endif /* USER_USB30_DESC_H_ */
