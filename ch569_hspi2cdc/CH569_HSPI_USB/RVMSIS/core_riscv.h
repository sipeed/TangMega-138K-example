/********************************** (C) COPYRIGHT  *******************************
* File Name          : core_riscv.h
* Author             : WCH
* Version            : V1.0.1
* Date               : 2023/11/11
* Description        : RISC-V V3 Core Peripheral Access Layer Header File for CH56x
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#ifndef __CORE_RISCV_H__
#define __CORE_RISCV_H__

#ifdef __cplusplus
 extern "C" {
#endif

#include <stdint.h>
#include "CH56xSFR.h"

/* IO definitions */
#ifdef __cplusplus
  #define     __I     volatile                /*!< defines 'read only' permissions      */
#else
  #define     __I     volatile const          /*!< defines 'read only' permissions     */
#endif
#define     __O     volatile                  /*!< defines 'write only' permissions     */
#define     __IO    volatile                  /*!< defines 'read / write' permissions   */
#define   RV_STATIC_INLINE  static  inline

typedef enum {DISABLE = 0, ENABLE = !DISABLE} FunctionalState;
typedef enum {RESET = 0, SET = !RESET} FlagStatus, ITStatus;

/* memory mapped structure for Program Fast Interrupt Controller (PFIC) */
typedef struct __attribute__((packed)) {
    __I  UINT32 ISR[8];
    __I  UINT32 IPR[8];
    __IO UINT32 ITHRESDR;
    __IO UINT32 VTFBADDRR;
    __IO UINT32 CFGR;
    __I  UINT32 GISR;
    UINT8 RESERVED0[0x10];
    __IO UINT32 VTFADDRR[4];
    UINT8 RESERVED1[0x90];
    __O  UINT32 IENR[8];
    UINT8 RESERVED2[0x60];
    __O  UINT32 IRER[8];
    UINT8 RESERVED3[0x60];
    __O  UINT32 IPSR[8];
    UINT8 RESERVED4[0x60];
    __O  UINT32 IPRR[8];
    UINT8 RESERVED5[0x60];
    __IO UINT32 IACTR[8];
    UINT8 RESERVED6[0xE0];
    __IO UINT8 IPRIOR[256];
    UINT8 RESERVED7[0x810];
    __IO UINT32 SCTLR;
}PFIC_Type;

#define    FIBADDRR   VTFBADDRR 
#define   FIOFADDRR   VTFADDRR


/* memory mapped structure for SysTick */
typedef struct __attribute__((packed))
{
    __IO UINT32 CTLR;
    __IO UINT64 CNT;
    __IO UINT64 CMP;
    __IO UINT32 CNTFG;
}SysTick_Type;


#define PFIC            ((PFIC_Type *) 0xE000E000 )
#define SysTick         ((SysTick_Type *) 0xE000F000)

#define PFIC_KEY1       ((UINT32)0xFA050000)
#define	PFIC_KEY2		((UINT32)0xBCAF0000)
#define	PFIC_KEY3		((UINT32)0xBEEF0000)

/*********************************************************************
 * @fn      __enable_irq
 *          This function is only used for Machine mode.
 *
 * @brief   Enable Global Interrupt
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void __enable_irq()
{
  __asm volatile ("csrs mstatus, %0" : : "r" (0x88) );
}

/*********************************************************************
 * @fn      __disable_irq
 *          This function is only used for Machine mode.
 *
 * @brief   Disable Global Interrupt
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void __disable_irq()
{
  __asm volatile ("csrc mstatus, %0" : : "r" (0x88) );
}

/*********************************************************************
 * @fn      __NOP
 *
 * @brief   nop
 *
 * @return  none
 */
RV_STATIC_INLINE void __NOP()
{
  __asm volatile ("nop");
}

/*********************************************************************
 * @fn      PFIC_EnableIRQ
 *
 * @brief   Enable Interrupt
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_EnableIRQ(IRQn_Type IRQn)
{
    PFIC->IENR[((UINT32)(IRQn) >> 5)] = (1 << ((UINT32)(IRQn) & 0x1F));
}

/*********************************************************************
 * @fn      PFIC_DisableIRQ
 *
 * @brief   Disable Interrupt
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_DisableIRQ(IRQn_Type IRQn)
{
    UINT32 t;

    t = PFIC->ITHRESDR;
    PFIC->ITHRESDR = 0x10;
    PFIC->IRER[((UINT32)(IRQn) >> 5)] = (1 << ((UINT32)(IRQn) & 0x1F));
    PFIC->ITHRESDR = t;
}

/*********************************************************************
 * @fn      PFIC_GetStatusIRQ
 *
 * @brief   Get Interrupt Enable State
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  1 - Interrupt Enable
 *          0 - Interrupt Disable
 */
RV_STATIC_INLINE UINT32 PFIC_GetStatusIRQ(IRQn_Type IRQn)
{
    return((UINT32) ((PFIC->ISR[(UINT32)(IRQn) >> 5] & (1 << ((UINT32)(IRQn) & 0x1F)))?1:0));
}

/*********************************************************************
 * @fn      PFIC_GetPendingIRQ
 *
 * @brief   Get Interrupt Pending State
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  1 - Interrupt Pending Enable
 *          0 - Interrupt Pending Disable
 */
RV_STATIC_INLINE UINT32 PFIC_GetPendingIRQ(IRQn_Type IRQn)
{
    return((UINT32) ((PFIC->IPR[(UINT32)(IRQn) >> 5] & (1 << ((UINT32)(IRQn) & 0x1F)))?1:0));
}

/*********************************************************************
 * @fn      PFIC_SetPendingIRQ
 *
 * @brief   Set Interrupt Pending
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_SetPendingIRQ(IRQn_Type IRQn){
    PFIC->IPSR[((UINT32)(IRQn) >> 5)] = (1 << ((UINT32)(IRQn) & 0x1F));
}

/*********************************************************************
 * @fn      PFIC_ClearPendingIRQ
 *
 * @brief   Clear Interrupt Pending
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_ClearPendingIRQ(IRQn_Type IRQn)
{
    PFIC->IPRR[((UINT32)(IRQn) >> 5)] = (1 << ((UINT32)(IRQn) & 0x1F));
}

/*********************************************************************
 * @fn      PFIC_GetActive
 *
 * @brief   Get Interrupt Active State
 *
 * @param   IRQn - Interrupt Numbers
 *
 * @return  1 - Interrupt Active
 *          0 - Interrupt No Active
 */
RV_STATIC_INLINE UINT32 PFIC_GetActive(IRQn_Type IRQn)
{
    return((UINT32)((PFIC->IACTR[(UINT32)(IRQn) >> 5] & (1 << ((UINT32)(IRQn) & 0x1F)))?1:0));
}

/*********************************************************************
 * @fn      PFIC_SetPriority
 *
 * @brief   Set Interrupt Priority
 *
 * @param   IRQn - Interrupt Numbers
 *          interrupt nesting enable(PFIC->CFGR bit1 = 0)
 *            priority - bit[7] - Preemption Priority
 *                       bit[6:4] - Sub priority
 *                       bit[3:0] - Reserve
 *          interrupt nesting disable(PFIC->CFGR bit1 = 1)
 *            priority - bit[7:4] - Sub priority
 *                       bit[3:0] - Reserve
 * @return  none
 */
RV_STATIC_INLINE void PFIC_SetPriority(IRQn_Type IRQn, UINT8 priority)
{
    PFIC->IPRIOR[(UINT32)(IRQn)] = priority;
}

/*********************************************************************
 * @fn      __WFI
 *
 * @brief   Wait for Interrupt
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void __WFI(void)
{
    PFIC->SCTLR &= ~(1<<3);	// wfi
    asm volatile ("wfi");
}

/*********************************************************************
 * @fn      _SEV
 *
 * @brief   Set Event
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void _SEV(void)
{
  PFIC->SCTLR |= (1<<3)|(1<<5);
}

/*********************************************************************
 * @fn      _WFE
 *
 * @brief   Wait for Events
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void _WFE(void)
{
  PFIC->SCTLR |= (1<<3);
  asm volatile ("wfi");
}

/*********************************************************************
 * @fn      __WFE
 *
 * @brief   Wait for Events
 *
 * @return  none
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE void __WFE(void)
{
  _SEV();
  _WFE();
  _WFE();
}

/*********************************************************************
 * @fn      PFIC_SetFastIRQ
 *
 * @brief   Set VTF Interrupt
 *
 * @param   add - VTF interrupt service function base address.
 *          IRQn - Interrupt Numbers
 *          num - VTF Interrupt Numbers
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_SetFastIRQ(UINT32 addr, IRQn_Type IRQn, UINT8 num){
    if(num > 3)  return ;
    PFIC->VTFBADDRR = addr;
    PFIC->VTFADDRR[num] = ((UINT32)IRQn<<24)|(addr&0xfffff);
}

/*********************************************************************
 * @fn      PFIC_SystemReset
 *
 * @brief   Initiate a system reset request
 *
 * @return  none
 */
RV_STATIC_INLINE void PFIC_SystemReset(void){
    PFIC->CFGR = PFIC_KEY3|(1<<7);
}

/*********************************************************************
 * @fn      PFIC_HaltPushCfg
 *
 * @brief   Enable Hardware Stack
 *
 * @param   NewState - DISABLE or ENABLE
 
 * @return  none
 */
RV_STATIC_INLINE void PFIC_HaltPushCfg(FunctionalState NewState)
{
    if (NewState != DISABLE)
    {
        PFIC->CFGR = PFIC_KEY1;
    }
    else
    {
        PFIC->CFGR = PFIC_KEY1|(1<<0);
    }
}

/*********************************************************************
 * @fn      PFIC_INTNestCfg
 *
 * @brief   Enable Interrupt Nesting
 *
 * @param   NewState - DISABLE or ENABLE
 
 * @return  none
 */
RV_STATIC_INLINE void PFIC_INTNestCfg(FunctionalState NewState)
{
    if (NewState != DISABLE)
    {
        PFIC->CFGR = PFIC_KEY1;
    }
    else
    {
        PFIC->CFGR = PFIC_KEY1|(1<<1);
    }
}

/*********************************************************************
 * @fn      __AMOADD_W
 *   
 * @brief   Atomic Add with 32bit value
 *          Atomically ADD 32bit value with value in memory using amoadd.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be ADDed
 *
 * @return  return memory value + add value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOADD_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amoadd.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOAND_W
 *
 * @brief   Atomic And with 32bit value
 *          Atomically AND 32bit value with value in memory using amoand.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be ANDed
 *
 * @return  return memory value & and value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOAND_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amoand.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOMAX_W
 *
 * @brief   Atomic signed MAX with 32bit value
 *          Atomically signed max compare 32bit value with value in memory using amomax.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be compared
 *
 * @return  the bigger value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOMAX_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amomax.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOMAXU_W
 *
 * @brief   Atomic unsigned MAX with 32bit value
 *          Atomically unsigned max compare 32bit value with value in memory using amomaxu.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be compared
 *             
 * @return  return the bigger value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE uint32_t __AMOMAXU_W(volatile uint32_t *addr, uint32_t value)
{
    uint32_t result;

    __asm volatile ("amomaxu.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOMIN_W
 *
 * @brief   Atomic signed MIN with 32bit value
 *          Atomically signed min compare 32bit value with value in memory using amomin.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be compared
 *
 * @return  the smaller value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOMIN_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amomin.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOMINU_W
 *
 * @brief   Atomic unsigned MIN with 32bit value
 *          Atomically unsigned min compare 32bit value with value in memory using amominu.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be compared
 *
 * @return  the smaller value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE uint32_t __AMOMINU_W(volatile uint32_t *addr, uint32_t value)
{
    uint32_t result;

    __asm volatile ("amominu.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOOR_W
 *  
 * @brief   Atomic OR with 32bit value
 *          Atomically OR 32bit value with value in memory using amoor.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be ORed
 * 
 * @return  return memory value | and value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOOR_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amoor.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

/*********************************************************************
 * @fn      __AMOSWAP_W
 *
 * @brief   Atomically swap new 32bit value into memory using amoswap.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          newval - New value to be stored into the address
 *
 * @return  return the original value in memory
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE uint32_t __AMOSWAP_W(volatile uint32_t *addr, uint32_t newval)
{
    uint32_t result;

    __asm volatile ("amoswap.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(newval) : "memory");
    return result;
}

/*********************************************************************
 * @fn      __AMOXOR_W     
 *
 * @brief   Atomic XOR with 32bit value
 *          Atomically XOR 32bit value with value in memory using amoxor.d.
 *          addr - Address pointer to data, address need to be 4byte aligned
 *          value - value to be XORed
 *
 * @return  return memory value ^ and value
 */
__attribute__( ( always_inline ) ) RV_STATIC_INLINE int32_t __AMOXOR_W(volatile int32_t *addr, int32_t value)
{
    int32_t result;

    __asm volatile ("amoxor.w %0, %2, %1" : \
            "=r"(result), "+A"(*addr) : "r"(value) : "memory");
    return *addr;
}

#define SysTick_LOAD_RELOAD_Msk            (0xFFFFFFFFFFFFFFFF)
#define SysTick_CTRL_RELOAD_Msk            (1 << 8)
#define SysTick_CTRL_CLKSOURCE_Msk         (1 << 2)
#define SysTick_CTRL_TICKINT_Msk           (1 << 1)
#define SysTick_CTRL_ENABLE_Msk            (1 << 0)


RV_STATIC_INLINE uint32_t SysTick_Config( UINT64 ticks )
{
  if ((ticks - 1) > SysTick_LOAD_RELOAD_Msk)  return (1);      /* Reload value impossible */

  SysTick->CMP  = ticks - 1;                                  /* set reload register */
  PFIC_EnableIRQ( SysTick_IRQn );
  SysTick->CTLR  = SysTick_CTRL_RELOAD_Msk    |
                   SysTick_CTRL_CLKSOURCE_Msk |
                   SysTick_CTRL_TICKINT_Msk   |
                   SysTick_CTRL_ENABLE_Msk;                    /* Enable SysTick IRQ and SysTick Timer */
  return (0);                                                  /* Function successful */
}


/* Core_Exported_Functions */  
extern uint32_t __get_MSTATUS(void);
extern void __set_MSTATUS(uint32_t value);
extern uint32_t __get_MISA(void);
extern void __set_MISA(uint32_t value);
extern uint32_t __get_MIE(void);
extern void __set_MIE(uint32_t value);
extern uint32_t __get_MTVEC(void);
extern void __set_MTVEC(uint32_t value);
extern uint32_t __get_MSCRATCH(void);
extern void __set_MSCRATCH(uint32_t value);
extern uint32_t __get_MEPC(void);
extern void __set_MEPC(uint32_t value);
extern uint32_t __get_MCAUSE(void);
extern void __set_MCAUSE(uint32_t value);
extern uint32_t __get_MTVAL(void);
extern void __set_MTVAL(uint32_t value);
extern uint32_t __get_MVENDORID(void);
extern uint32_t __get_MARCHID(void);
extern uint32_t __get_MIMPID(void);
extern uint32_t __get_MHARTID(void);
extern uint32_t __get_SP(void);

#ifdef __cplusplus
}
#endif


#endif





