/*
 * Open-source-only 16-bit HSPI receive benchmark for CH569.
 *
 * Data path under test: FPGA -> 16-bit HSPI -> CH569 dual DMA.
 * USB is deliberately not initialized and no binary library is linked.
 */
#include <stdint.h>

#include "CH56x_common.h"
#include "main.h"

#define CPU_HZ             120000000UL
#define UART_BAUD          115200UL
#define HSPI_PACKET_BYTES  4096UL
#define REPORT_CYCLES      CPU_HZ

__attribute__((aligned(16), section(".DMADATA")))
static uint8_t hspi_rx_buffer[HSPI_PACKET_BYTES * 2];

static volatile uint32_t rx_packets;
static volatile uint32_t crc_errors;
static volatile uint32_t sequence_errors;
static volatile uint32_t fifo_overflows;

static void hspi_rx16_init(void)
{
    /* PA10 is the receive ACK output. */
    R32_PA_DIR |= (1UL << 10);

    R8_HSPI_CTRL |= RB_HSPI_TRX_RST | RB_HSPI_ALL_CLR;

    R8_HSPI_CFG &= ~(RB_HSPI_MODE | RB_HSPI_MSK_SIZE);
    R8_HSPI_CFG |= RB_HSPI_DAT16_MOD | RB_HSPI_RX_TOG_EN;
    R8_HSPI_CFG &= ~RB_HSPI_TX_TOG_EN;
    R8_HSPI_CFG &= ~RB_HSPI_HW_ACK;

    R8_HSPI_AUX |= RB_HSPI_REQ_FT | RB_HSPI_TCK_MOD;
    R8_HSPI_AUX &= ~(RB_HSPI_ACK_TX_MOD | RB_HSPI_ACK_CNT_SEL);

    R32_HSPI_UDF0 = 0x000ffff;
    R32_HSPI_UDF1 = 0x000ffff;
    R32_HSPI_RX_ADDR0 = (uint32_t)&hspi_rx_buffer[0];
    R32_HSPI_RX_ADDR1 = (uint32_t)&hspi_rx_buffer[HSPI_PACKET_BYTES];

    R8_HSPI_INT_FLAG = RB_HSPI_IF_R_DONE | RB_HSPI_IF_FIFO_OV;
    R8_HSPI_INT_EN = RB_HSPI_IE_R_DONE | RB_HSPI_IE_FIFO_OV;
    R8_HSPI_CTRL &= ~(RB_HSPI_TRX_RST | RB_HSPI_ALL_CLR);
    R8_HSPI_CTRL |= RB_HSPI_ENABLE | RB_HSPI_DMA_EN;
    PFIC_EnableIRQ(HSPI_IRQn);
}

int main(void)
{
    SystemInit(CPU_HZ);
    DebugInit(UART_BAUD);
    Delay_Init(GetSysClock());

    PRINT("\r\nCH569 HSPI RX16 benchmark (open source, no USB)\r\n");
    PRINT("CPU=%u Hz frame=%u bytes DMA=%08x/%08x\r\n",
          GetSysClock(), HSPI_PACKET_BYTES,
          (uint32_t)&hspi_rx_buffer[0],
          (uint32_t)&hspi_rx_buffer[HSPI_PACKET_BYTES]);

    hspi_rx16_init();

    uint64_t last_cycle = GetSysTick();
    uint32_t last_packets = 0;
    for (;;) {
        uint64_t now = GetSysTick();
        uint64_t elapsed = now - last_cycle;
        if (elapsed >= REPORT_CYCLES) {
            uint32_t packets = rx_packets;
            uint32_t delta_packets = packets - last_packets;
            uint64_t delta_bytes = (uint64_t)delta_packets * HSPI_PACKET_BYTES;
            uint32_t mbps_milli = (uint32_t)((delta_bytes * 8ULL * CPU_HZ) /
                                             (elapsed * 1000ULL));

            PRINT("HSPI_RX packets=%u delta=%u rate=%u.%03u Mbit/s "
                  "crc=%u seq=%u fifo=%u status=%02x\r\n",
                  packets, delta_packets,
                  mbps_milli / 1000, mbps_milli % 1000,
                  crc_errors, sequence_errors, fifo_overflows,
                  R8_HSPI_RTX_STATUS);
            last_packets = packets;
            last_cycle = now;
        }
    }
}

__attribute__((interrupt("WCH-Interrupt-fast")))
void HSPI_IRQHandler(void)
{
    uint8_t flags = R8_HSPI_INT_FLAG;

    if (flags & RB_HSPI_IF_R_DONE) {
        uint8_t status = R8_HSPI_RTX_STATUS;
        R8_HSPI_INT_FLAG = RB_HSPI_IF_R_DONE;
        if (status & RB_HSPI_CRC_ERR)
            ++crc_errors;
        if (status & RB_HSPI_NUM_MIS)
            ++sequence_errors;
        if (!(status & (RB_HSPI_CRC_ERR | RB_HSPI_NUM_MIS)))
            ++rx_packets;
    }

    if (flags & RB_HSPI_IF_FIFO_OV) {
        R8_HSPI_INT_FLAG = RB_HSPI_IF_FIFO_OV;
        ++fifo_overflows;
    }
}

__attribute__((interrupt("WCH-Interrupt-fast")))
void HardFault_Handler(void)
{
    PRINT("HardFault mcause=%08x\r\n", __get_MCAUSE());
    for (;;) { }
}
