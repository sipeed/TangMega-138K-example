/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_clk.c
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
 * @fn     SystemInit
 *
 * @brief   System clock initialization
 *
 * @param  systemclck: system clock Hz
 *
 * @return  None
 */
void SystemInit(uint32_t systemclck)
{	
	uint8_t sc;
	
	sc = systemclck/1000000;

    switch( sc )
    {
        case CLK_SOURCE_PLL_15MHz:
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40 | 0x02;			
			R8_CLK_CFG_CTRL = 0x80 ;
			
            break;
        case CLK_SOURCE_PLL_30MHz:		
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40;		
			R8_CLK_CFG_CTRL = 0x80 | RB_CLK_SEL_PLL;			
			
            break;
        case CLK_SOURCE_PLL_60MHz:
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40 | 0x08;			
			R8_CLK_CFG_CTRL = 0x80 | RB_CLK_SEL_PLL;	
			
            break;
        case CLK_SOURCE_PLL_80MHz:
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40 | 0x06;			
			R8_CLK_CFG_CTRL = 0x80 | RB_CLK_SEL_PLL;	
			
            break;
        case CLK_SOURCE_PLL_96MHz:
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40 | 0x05;			
			R8_CLK_CFG_CTRL = 0x80 | RB_CLK_SEL_PLL;
			
            break;
        case CLK_SOURCE_PLL_120MHz:
			R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
			R8_SAFE_ACCESS_SIG = 0xa8;
			R8_CLK_PLL_DIV = 0x40 | 0x04;			
			R8_CLK_CFG_CTRL = 0x80 | RB_CLK_SEL_PLL;
			
            break;
        default :
            break;		
    }	
    R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     GetSysClock
 *
 * @brief  Get the current system clock
 *
 * @param  None
 *
 * @return   Hz
 */
UINT32 GetSysClock( void )
{
	UINT8  rev;

	rev = R8_CLK_PLL_DIV & 0x0F;

	if(R8_CLK_CFG_CTRL & RB_CLK_SEL_PLL){             //The system clock source comes from the 480M provided by the USB PHY
		if(rev == 0){
			return (30000000);
		}
		else{
			return (480000000/R8_CLK_PLL_DIV);
		}
	}
	else{                                             //The system clock source comes from an external crystal oscillator 30M
		if(rev == 0){
			return (2000000);
		}
		else{
			return (30000000/R8_CLK_PLL_DIV);
		}
	}
}



