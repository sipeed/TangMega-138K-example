#ifndef __GLOBAL_VARIABLES_H__
#define __GLOBAL_VARIABLES_H__

#include "CH56x_common.h"

#define PACKET_SIZE 4096
#define PACKET_MAX_NUM  16
#define PACKET_PAUSE_WATERMARK 10
#define PACKET_RESUME_WATERMARK 4
#define USB_STREAM_START_DELAY_TICKS 2400000UL /* 20 ms at 120 MHz */

#define	UART_SendCMD(cmd)		(R8_UART1_THR = cmd)

extern volatile uint32_t g_hspi_rx_addr0_offset;
extern volatile uint32_t g_hspi_rx_addr1_offset;
extern volatile uint32_t g_hspi_rx_cnt;

extern volatile uint8_t g_h2u_packet_ov_flag;
extern volatile uint8_t g_h2u_packet_num;

extern volatile uint32_t g_usb_ep2in_cnt;
extern volatile uint32_t g_usb_ep2in_ready;
extern volatile uint32_t g_usb_send_addr_offset;
extern volatile uint8_t g_usb_stream_state;
extern volatile uint64_t g_usb_stream_start_tick;
extern volatile uint8_t g_hspi_paused;
extern volatile uint32_t g_h2u_produced;
extern volatile uint32_t g_h2u_consumed;
extern volatile uint8_t g_h2u_first_slot;
extern volatile uint8_t g_usb_ep2_active;
extern volatile uint8_t g_h2u_slot_queue[PACKET_MAX_NUM];
extern volatile uint8_t g_h2u_next_slot;

extern uint32_t g_hspi_rx_addr_base;

static inline void reset_hspi_usb30(void)
{
    /* packet number reset */
    g_h2u_packet_num = 0;

    /* USB EP2 TX ADDR reset */
    g_usb_send_addr_offset = 0;

    /* HSPI RX ADDR reset */
    g_hspi_rx_addr0_offset = 0;
    R32_HSPI_RX_ADDR0 = g_hspi_rx_addr_base;
    g_hspi_rx_addr1_offset = 0;
    R32_HSPI_RX_ADDR1 = g_hspi_rx_addr_base + PACKET_SIZE;

    /* clear ov flag */
    g_h2u_packet_ov_flag = 0;
    g_hspi_paused = 0;
    R8_HSPI_CTRL |= RB_HSPI_ENABLE;

    g_h2u_produced = 0;
    g_h2u_consumed = 0;
    g_h2u_first_slot = 0;
    g_usb_ep2_active = 0;
    g_h2u_next_slot = 2;
}

static inline uint8_t h2u_depth(void)
{
    return (uint8_t)(g_h2u_produced - g_h2u_consumed);
}

static inline uint32_t h2u_slot_offset(uint32_t sequence)
{
    return (uint32_t)g_h2u_slot_queue[sequence % PACKET_MAX_NUM] * PACKET_SIZE;
}

#endif
