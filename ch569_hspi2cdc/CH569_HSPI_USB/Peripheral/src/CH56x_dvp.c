/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_dvp.c
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
 * @fn     DVP_INTCfg
 *
 * @brief   DVP interrupt configuration
 *
 * @param  s:  interrupt control status
					ENABLE - Enables the corresponding interrupt
					DISABLE - disables the corresponding interrupt
				   i:  interrupt type
					RB_DVP_IE_STP_FRM  - end of frame interrupt
					RB_DVP_IE_FIFO_OV  - Receive FIFO overflow interrupt
					RB_DVP_IE_FRM_DONE - end of frame interrupt
					RB_DVP_IE_ROW_DONE - end of line break
					RB_DVP_IE_STR_FRM  - start of frame interrupt
 *
 * @return  None
 **/
void DVP_INTCfg( UINT8 s,  UINT8 i )
{
    if(s){
    	R8_DVP_INT_EN |= i;
    }
    else{
    	R8_DVP_INT_EN &= ~i;
    }
}

/*******************************************************************************
 * @fn    DVP_Mode
 *
 * @brief  DVP mode
 *
 * @param  s:  data width
					RB_DVP_D8_MOD  - 8-bit mode
					RB_DVP_D10_MOD - 10-bit mode
					RB_DVP_D12_MOD - 12-bit mode
				   i:  Compressed Data Mode
					Video_Mode - enable video mode
					JPEG_Mode  - Enable JPEG mode
 *
 * @return  None
 */
void DVP_Mode( UINT8 s,  DVP_Data_ModeTypeDef i)
{
	R8_DVP_CR0 &= ~RB_DVP_MSK_DAT_MOD;   //Restore default mode 8bit mode

    if(s){
    	R8_DVP_CR0 |= s;
    }
    else{
    	R8_DVP_CR0 &= ~(3<<4);
    }

    if(i){
    	R8_DVP_CR0 |= RB_DVP_JPEG;
    }
    else{
    	R8_DVP_CR0 &= ~RB_DVP_JPEG;
    }
}

/*******************************************************************************
 * @fn      DVP_Cfg
 *
 * @brief   DVP configuration
 *
 * @param   s:  DMA enable control
					DVP_DMA_Enable  - DMA enable
					DVP_DMA_Disable - DMA disable
				   i:  Flag and FIFO Clear Control
					DVP_FLAG_FIFO_RESET_Enable  - Reset flag and FIFO
                    DVP_FLAG_FIFO_RESET_Disable - cancel reset operation
				   j:  Receive Logic Reset Control
					DVP_RX_RESET_Enable - reset receiver logic
					DVP_RX_RESET_Disable - cancel reset operation
 *
 * @return   None
 */
void DVP_Cfg( DVP_DMATypeDef s,  DVP_FLAG_FIFO_RESETTypeDef i, DVP_RX_RESETTypeDef j)
{
    switch( s )
    {
        case DVP_DMA_Enable:
        	R8_DVP_CR1 |= RB_DVP_DMA_EN;
            break;
        case DVP_DMA_Disable:
        	R8_DVP_CR1 &= ~RB_DVP_DMA_EN;
            break;
        default:
            break;
    }

    switch( i )
    {
        case DVP_RX_RESET_Enable:
        	R8_DVP_CR1 |= RB_DVP_ALL_CLR;
            break;
        case DVP_RX_RESET_Disable:
        	R8_DVP_CR1 &= ~RB_DVP_ALL_CLR;
            break;
        default:
            break;
    }

    switch( j )
    {
        case DVP_RX_RESET_Enable:
        	R8_DVP_CR1 |= RB_DVP_RCV_CLR;
            break;
        case DVP_RX_RESET_Disable:
        	R8_DVP_CR1 &= ~RB_DVP_RCV_CLR;
            break;
        default:
            break;
    }

}
