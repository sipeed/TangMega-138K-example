/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_sys.c
* Author             : WCH
* Version            : V1.0
* Date               : 2020/07/31
* Description        : This file contains all the functions prototypes for
*                      SystemCoreClock, UART Printf , Delay functions .
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/

#include "CH56x_common.h"


static uint64_t p_us=0;
static uint64_t p_ms=0;

/*******************************************************************************
 * @fn     Delay_Init
 *
 * @brief  Initializes Delay Funcation.
 *
 * @param  systemclck - system clock Hz
 *
 * @return   None
 **/
void Delay_Init(uint32_t systemclck)
{
	p_us=systemclck/1000000;
	p_ms=systemclck/1000;
	SysTick->CTLR = 0;
    SysTick->CNTFG &= ~(SysTick_CNTFG_CNTIF_Msk | SysTick_CNTFG_SWIE_Msk);
    SysTick->CMP = SysTick_LOAD_RELOAD_Msk;
    SysTick->CTLR |= SysTick_CTRL_RELOAD_Msk | SysTick_CTRL_CLKSOURCE_Msk | SysTick_CTRL_ENABLE_Msk;
}

uint64_t GetSysTick(void) {
    while (1)
	{
		uint32_t hi = SysTick->CNT >> 32;
		uint32_t lo = SysTick->CNT;
		if (hi == SysTick->CNT >> 32)
			return ~(((uint64_t)(hi) << 32) | (uint64_t)(lo));
	}
	/*
	RISC-V ASM output:
	00000f44 b7 f7 00 e0     lui      a5,0xe000f
		LAB_00000f48
	00000f48 98 47           lw       a4,0x8(a5) // 0xe000f008
	00000f4a c8 43           lw       a0,0x4(a5) // 0xe000f004
	00000f4c 8c 47           lw       a1,0x8(a5) // 0xe000f008
	00000f4e e3 9d e5 fe     bne      a1,a4,LAB_00000f48
	00000f52 82 80           ret
	*/
}

/*******************************************************************************
 * @fn     mDelayuS
 *
 * @brief  Microsecond Delay Time.
 *
 * @param  n - Microsecond number.
 *
 * @return   None
 **/
void mDelayuS(uint32_t n)
{
	uint64_t start = GetSysTick();
	uint64_t nb_cycles = p_us * (uint64_t)n;
	uint64_t curr;
	uint64_t delta;

	if(nb_cycles > 34)
		nb_cycles -= 34; // Remove function overhead with -O3 optim
	else
		nb_cycles = 0;

	while(1)
	{
		curr = GetSysTick();
		delta = curr - start; // SysTickCNT is decremented so comparison is inverted
		if( delta > nb_cycles )
			break;
	}
}

/*******************************************************************************
 * @fn     mDelaymS
 *
 * @brief  Millisecond Delay Time.
 *
 * @param  n - Millisecond number.
 *
 * @return   None
 **/
void mDelaymS(uint32_t n)
{
	uint64_t start = GetSysTick();
	uint64_t nb_cycles = p_ms * (uint64_t)n;
	uint64_t curr;
	uint64_t delta;

	if(nb_cycles > 34)
		nb_cycles -= 34; // Remove function overhead with -O3 optim
	else
		nb_cycles = 0;

	while(1)
	{
		curr = GetSysTick();
		delta = curr - start; // SysTickCNT is decremented so comparison is inverted
		if( delta > nb_cycles )
			break;
	}
}

/*******************************************************************************
 * @fn     SYS_GetInfoSta
 *
 * @brief  Get the current system information status
 *
 * @param  i -
 * @return  stat
 **/
UINT8 SYS_GetInfoSta( SYS_InfoStaTypeDef i )
{
	return (R8_RST_BOOT_STAT&(1<<i));
}

/*******************************************************************************
 * @fn     SYS_ResetExecute
 *
 * @brief  Perform a system software reset
 *
 * @return   None
 **/
void SYS_ResetExecute( void )
{
	R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
	R8_SAFE_ACCESS_SIG = 0xa8;
    R8_RST_WDOG_CTRL |= RB_SOFTWARE_RESET | 0x40;
    R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     WWDG_ITCfg
 *
 * @brief  Watchdog timer overflow interrupt enable
 *
 * @param  s -
 *           DISABLE - Overflow without interruption
 *           ENABLE  - Overflow interrupt
 *
 * @return   None
 **/
void  WWDG_ITCfg( UINT8 s )
{
	R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
	R8_SAFE_ACCESS_SIG = 0xa8;
	if(s == DISABLE)		R8_RST_WDOG_CTRL=(R8_RST_WDOG_CTRL & (~RB_WDOG_INT_EN)) | 0x40;
	else 					R8_RST_WDOG_CTRL|=RB_WDOG_INT_EN | 0x40;
	R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     WWDG_ResetCfg
 *
 * @brief  Watchdog timer reset function
 *
 * @param  s -
 *           DISABLE - Overflow does not reset
 *           ENABLE  - Overflow system reset
 *
 * @return   None
 **/
void WWDG_ResetCfg( UINT8 s )
{
	R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
	R8_SAFE_ACCESS_SIG = 0xa8;
	if(s == DISABLE)		R8_RST_WDOG_CTRL=(R8_RST_WDOG_CTRL & (~RB_WDOG_RST_EN)) | 0x40;
	else 					R8_RST_WDOG_CTRL|=RB_WDOG_RST_EN | 0x40;
	R8_SAFE_ACCESS_SIG = 0;
}

/*******************************************************************************
 * @fn     WWDG_ClearFlag
 * @brief  Clear watchdog interrupt flag, reload count value can also be cleared
 * @param  None
 * @return   None
 **/
void WWDG_ClearFlag( void )
{
	R8_SAFE_ACCESS_SIG = 0x57; // enable safe access mode
	R8_SAFE_ACCESS_SIG = 0xa8;
	R8_RST_WDOG_CTRL |= RB_WDOG_INT_FLAG | 0x40;
	R8_SAFE_ACCESS_SIG = 0;
}


#if( defined  DEBUG)
/*******************************************************************************
 * @fn     _write
 *
 * @brief  Support Printf Function
 *
 * @param  *buf: UART send Data.
 *           size - Data length
 *
 * @return   size - Data length
 **/
 __attribute__((used))
int _write(int fd, char *buf, int size)
{
	int i;

	for(i=0; i<size; i++){
#if  DEBUG == Debug_UART0
		while( R8_UART0_TFC == UART_FIFO_SIZE );
		R8_UART0_THR = *buf++;
#elif DEBUG == Debug_UART1
		while( R8_UART1_TFC == UART_FIFO_SIZE );
		R8_UART1_THR = *buf++;
#elif DEBUG == Debug_UART2
		while( R8_UART2_TFC == UART_FIFO_SIZE );
		R8_UART2_THR = *buf++;
#elif DEBUG == Debug_UART3
		while( R8_UART3_TFC == UART_FIFO_SIZE );
		R8_UART3_THR = *buf++;
#endif

	}

	return size;
}
#endif
