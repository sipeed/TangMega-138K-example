/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_hspi.c
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
 * @fn     HSPI_Mode
 *
 * @brief  DVP mode
 *
 * @param  s -  data width
 *					RB_HPIF_DAT8_MOD  - 8-bit mode
 *					RB_HPIF_DAT16_MOD - 16-bit mode
 *					RB_HPIF_DAT32_MOD - 32-bit mode
 *		   i -  Operating mode
 *					UP_Mode - Enable upper mode
 *					DOWN_Mode - Enable downside mode
 *
 * @return   None
 */
void HSPI_Mode( UINT8 s,  HSPI_ModeTypeDef i)
{
	R8_HSPI_CFG &= ~RB_HSPI_MSK_SIZE;   //Restore default mode 8bit mode

    if(s){
    	R8_HSPI_CFG |= s;
    }
    else{
    	R8_HSPI_CFG &= ~RB_HSPI_MSK_SIZE;
    }

    if(i){
    	R8_HSPI_CFG |= RB_HSPI_MODE;
    }
    else{
    	R8_HSPI_CFG &= ~RB_HSPI_MODE;
    }
}

/*******************************************************************************
 * @fn     HSPI_INTCfg
 *
 * @brief  HSPI interrupt configuration
 *
 * @param  s -  interrupt control status
 *					ENABLE  - Enable corresponding interrupt
 *					DISABLE - Disable the corresponding interrupt
 *		   i -  interrupt type
 *					RB_HSPI_IE_T_DONE  - Burst Sequence Transmit Complete Interrupt
 *					RB_HSPI_IE_R_DONE  - Receive FIFO overflow interrupt
 *					RB_HSPI_IE_FIFO_OV - Single packet receive complete interrupt
 *				    RB_HSPI_IE_B_DONE  - Guaranteed Send Complete Interrupt
 *
 * @return   None
 */
void HSPI_INTCfg( UINT8 s,  UINT8 i )
{
    if(s){
    	R8_HSPI_INT_EN |= i;
    }
    else{
    	R8_HSPI_INT_EN &= ~i;
    }
}

