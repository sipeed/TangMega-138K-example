#include "global_variables.h"


volatile uint32_t g_usb_ep2in_cnt = 0;
volatile uint32_t g_usb_ep2in_ready = 0;
volatile uint32_t g_usb_send_addr_offset = 0;
/* 0: discard HSPI input, 1: armed/delayed, 2: stream to USB EP2. */
volatile uint8_t g_usb_stream_state = 0;
volatile uint64_t g_usb_stream_start_tick = 0;
volatile uint8_t g_hspi_paused = 0;
/* Single-writer counters: HSPI owns produced, USBSS owns consumed.  This
 * avoids lost read/modify/write updates when the two fast ISRs nest. */
volatile uint32_t g_h2u_produced = 0;
volatile uint32_t g_h2u_consumed = 0;
volatile uint8_t g_h2u_first_slot = 0;
volatile uint8_t g_usb_ep2_active = 0;
volatile uint8_t g_h2u_slot_queue[PACKET_MAX_NUM];
volatile uint8_t g_h2u_next_slot = 2;

volatile uint8_t g_h2u_packet_ov_flag = 0;
volatile uint8_t g_h2u_packet_num = 0;

volatile uint32_t g_hspi_rx_cnt = 0;
volatile uint32_t g_hspi_rx_addr0_offset = 0;
volatile uint32_t g_hspi_rx_addr1_offset = 0;

uint32_t g_hspi_rx_addr_base = 0x00;
