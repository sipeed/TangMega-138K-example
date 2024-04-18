/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_pwm.c
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
 * @fn     PWMX_CycleCfg
 *
 * @brief  PWM0-PWM3 reference clock configuration
 *
 * @param  cyc -
 *
 * @return   None
 */
void PWMX_CycleCfg( PWMX_CycleTypeDef cyc )
{
    switch( cyc )
    {
        case PWMX_Cycle_256:
        	R8_PWM_CTRL_CFG &= ~RB_PWM_CYCLE_SEL;    //PWM configuration control register, clock cycle selection
            break;

        case PWMX_Cycle_255:
        	R8_PWM_CTRL_CFG |= RB_PWM_CYCLE_SEL;
            break;

        default :
            break;
    }
}

/*******************************************************************************
 * @fn     PWMX_ACTOUT
 *
 * @brief  PWM0-PWM3 channel output waveform configuration
 *
 * @param  ch -	select channel of pwm
 *					refer to channel of PWM define
 *	       da -	effective pulse width
 *		   pr -  select wave polar
 *					refer to PWMX_PolarTypeDef
 *		   s  -  control pwmx function
 *					ENABLE  - Output PWM
 *					DISABLE - turn off PWM
 * @return   None
 */
void PWMX_ACTOUT( UINT8 ch, UINT8 da, PWMX_PolarTypeDef pr, UINT8 s)
{
    UINT8 i;

    if(s == DISABLE)	R8_PWM_CTRL_MOD &= ~(ch);                        //Determine whether the PWM output is enabled
    else
    {

    	(pr)?(R8_PWM_CTRL_MOD|=(ch<<4)):(R8_PWM_CTRL_MOD&=~(ch<<4));     //PWM output polarity control 1: Default high level, low active; 0: Default low level, high active
        for(i=0; i<4; i++){
            if((ch>>i)&1)		*((PUINT8V)((&R8_PWM0_DATA)+i)) = da;
        }
        R8_PWM_CTRL_MOD |= (ch);
    }
}





