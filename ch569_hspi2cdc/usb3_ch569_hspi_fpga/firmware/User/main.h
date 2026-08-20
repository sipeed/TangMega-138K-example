#pragma once
#include "CH56xSFR.h"

#if 1
#define SLOGIC_LOG PRINT
#else
#define SLOGIC_LOG
#endif
#define SLOGIC_LOG_TICK(Tick) do {uint64_t _tick = (Tick); SLOGIC_LOG("systick=%08x%08x\r\n", (uint32_t)(_tick>>32), (uint32_t)(_tick));} while(0)

void HSPI_Benchmark_ResetStats(void);

static inline void hexdump(void* p, size_t s, int width) {

    switch(width) {
    case 1:
        break;
    case 2:
        break;
    case 4:{
        uint32_t *ptr = p;
        uint32_t *end = p + s;
        SLOGIC_LOG("          00       04       08       0C\r\n");
        for(;ptr<end;ptr+=4) {
            SLOGIC_LOG("%08X  %08x %08x %08x %08x\r\n", ptr, ptr[0], ptr[1], ptr[2], ptr[3]);
        }
    }break;
    }
    SLOGIC_LOG("\r\n");
}


/*******************************************************************************
 * @fn     SystemInit
 *
 * @brief   System clock initialization
 *
 * @param  systemclck: system clock MHz eg: 160, 120, 96, 80, 60, 48, 40, 32, 30(480), 15, 10, 6, 5, 3, 2(30)
 *
 * @return  None
 */
static inline void SystemInit(uint32_t systemclck)
{
    // 160, 120, 96, 80, 60, 48, 40, 32, 30(480), 15, 10(30)
    uint8_t sc = systemclck / 1000000;
    uint8_t div = 0x40;
    uint8_t src = 0x80;

    switch(sc){
        case 15:case 10:case 6:case 5:case 3:case 2:
            div |= 0xf & (30 / sc);
            break;
        case 160:case 120:case 96:case 80:case 60:case 40:case 32:case 30:
            div |= 0xf & (480 / sc);
            src |= RB_CLK_SEL_PLL;
            break;
        default:
            return;
            break;
    }
    R8_SAFE_ACCESS_SIG = 0x57;
    R8_SAFE_ACCESS_SIG = 0xa8;// enable safe access mode
    R8_CLK_PLL_DIV  = div;
    R8_CLK_CFG_CTRL = src;
    R8_SAFE_ACCESS_SIG = 0;// exit safe access mode
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
static inline UINT32 GetSysClock( void )
{
    UINT8  rev;

    rev = R8_CLK_PLL_DIV & 0x0F;

    uint8_t div = (R8_CLK_PLL_DIV & 0x0F) ?: 0x10; // 0 => 16
    uint32_t clk = (R8_CLK_CFG_CTRL & RB_CLK_SEL_PLL) ? 480000000   //The system clock source comes from the 480M provided by the USB PHY
                                                      :  30000000;  //The system clock source comes from an external crystal oscillator 30M

    return clk / div;
}

static inline void DebugInit(UINT32 baudrate)
{
    UINT32 x;
    UINT32 t = GetSysClock();

    R8_UART1_DIV = 1;
    x = 10 * t * 2 / R8_UART1_DIV / 16 / baudrate;
    x = ( x + 5 ) / 10;
    R16_UART1_DL = x;
    R8_UART1_FCR = RB_FCR_FIFO_TRIG | RB_FCR_TX_FIFO_CLR | RB_FCR_RX_FIFO_CLR | RB_FCR_FIFO_EN;
    R8_UART1_LCR = RB_LCR_WORD_SZ;
    R8_UART1_IER = RB_IER_TXD_EN;

    // PA7/PA8= Rx/Tx
    R32_PA_SMT |= (1<<8)|(1<<7);
    R32_PA_DIR |= (1<<8);
}
