/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_pwr.c
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
 * @fn     PWR_PeriphClkCfg
 *
 * @brief  Peripheral Clock Control Bits
 * @param  s -
 *                  ENABLE  - Turn on the peripheral clock
 *                  DISABLE - Turn off peripheral clock
 *                  perph -
 *                     please refer to Peripher CLK control bit define
 
 * @return   None
 */
void PWR_PeriphClkCfg( UINT8 s, UINT16 perph )
{
    if( s == DISABLE )
    {
        R8_SAFE_ACCESS_SIG = 0x57;
        R8_SAFE_ACCESS_SIG = 0xA8;
        R32_SLEEP_CONTROL |= perph;
    }
    else
    {
        R8_SAFE_ACCESS_SIG = 0x57;
        R8_SAFE_ACCESS_SIG = 0xA8;
        R32_SLEEP_CONTROL &= ~perph;
    }
    R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     PWR_PeriphWakeUpCfg
 *
 * @brief  Sleep wakeup source configuration
 *
 * @param  s -
 *                  ENABLE  - Turn on this peripheral's wake-from-sleep feature
 *                  DISABLE - Turn off this peripheral sleep wake function
 *         perph -
 *                 RB_SLP_USBHS_WAKE -  USB2.0 is the wake-up source
 *                 RB_SLP_USBSS_WAKE -  USB3.0 is the wake-up source
 *                 RB_SLP_GPIO_WAKE  -  GPIO is the wake-up source
 *                 RB_SLP_ETH_WAKE   -  ETH is the wakeup source
 *                 ALL              -  all of above
 * @return   None
 */
void PWR_PeriphWakeUpCfg( UINT8 s, UINT16 perph )
{
    if( s == DISABLE )
    {
        R8_SAFE_ACCESS_SIG = 0x57;
        R8_SAFE_ACCESS_SIG = 0xA8;
        R8_SLP_WAKE_CTRL &= ~perph;
    }
    else
    {
        R8_SAFE_ACCESS_SIG = 0x57;
        R8_SAFE_ACCESS_SIG = 0xA8;
        R8_SLP_WAKE_CTRL |= perph;
    }
    R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     LowPower_Idle
 *
 * @brief  Low power consumption - Idle mode
 *
 * @return   None
 */
void LowPower_Idle( void )
{

	PFIC->SCTLR &= ~1<<2;				// Set the SleepDeep field of the core PFIC SCTLR register to 0
    __WFI();                            // Execute __WFI() after setting the wake-up condition

}

/*******************************************************************************
 * @fn     LowPower_Halt
 *
 * @brief  Low power consumption - Halt mode
 * 
 * @return   None
 */
void LowPower_Halt( void )
{

	PFIC->SCTLR |= 1<<2;                      // Set the SleepDeep field of the core PFIC SCTLR register to 1
	R8_SLP_POWER_CTRL |= RB_SLP_USBHS_PWRDN;  // Set RB_SLP_USBHS_PWRDN to 1
	__WFI();                                  // Execute __WFI() after setting the wake-up condition
}

/*******************************************************************************
 * @fn     LowPower_Sleep
 *
 * @brief  Low power consumption - Sleep mode
 *
 * @return   None
 */
void LowPower_Sleep( void )
{

	PFIC->SCTLR |= 1<<2;                      // Set the SleepDeep field of the core PFIC SCTLR register to 1
	R8_SLP_POWER_CTRL |= RB_SLP_USBHS_PWRDN;  // Set RB_SLP_USBHS_PWRDN to 1
	R8_SLP_WAKE_CTRL &= ~RB_SLP_USBSS_WAKE;   // RB_SLP_USBSS_WAKE to 0
	__WFI();                                  // Execute __WFI() after setting the wake-up condition

}




