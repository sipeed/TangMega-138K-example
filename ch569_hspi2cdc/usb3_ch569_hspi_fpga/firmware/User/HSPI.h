#include "CH56xSFR.h"

static inline void HSPI_Init(uint32_t hspi_rx_addr)
{
    { //HSPI_GPIO_Init
        //TX GPIO PA9 11 21 push-pull output
        //R32_PA_DIR |= (1<<9) | (1<<11) | (1<<21);

        //clk 16mA
        //R32_PA_DRV |= (1<<11);

        //Rx GPIO PA10(HTACK) push-pull output
        R32_PA_DIR |= (1<<10);
    }

    //reset HSPI reg, fifo and flag
    R8_HSPI_CTRL |= (RB_HSPI_TRX_RST | RB_HSPI_ALL_CLR);

    R8_HSPI_CFG &= ~(RB_HSPI_MODE | RB_HSPI_MSK_SIZE);  //Clear
    //16-bit receive mode for the Tang Mega Neo HD[15:0] board routing.
    R8_HSPI_CFG &= ~(RB_HSPI_MODE);     //Down port
    R8_HSPI_CFG |= RB_HSPI_DAT16_MOD;

    //Rx ToG En  1
    R8_HSPI_CFG |= RB_HSPI_RX_TOG_EN;

    /* RX_ADDR0/RX_ADDR1 form a hardware ping-pong pair.  RX_TOG_EN selects
     * the alternating address, while DUALDMA enables the double-DMA datapath
     * itself.  Both bits are required; setting only RX_TOG_EN can leave the
     * firmware's slot ownership model out of sync with the peripheral. */
    R8_HSPI_CFG |= RB_HSPI_DUALDMA;

    //Tx ToG En  0
    R8_HSPI_CFG &= ~RB_HSPI_TX_TOG_EN;

    //HW_ACK mode  0   (Hardware auto-answer mode for burst mode, not for normal mode)
    R8_HSPI_CFG &= ~RB_HSPI_HW_ACK;

    //Enable fast DMA request
    R8_HSPI_AUX |= RB_HSPI_REQ_FT;

    //TX edge sampling
    R8_HSPI_AUX |= RB_HSPI_TCK_MOD;  //Falling edge sampling

    // not used for HW_ACK disabled
    //Hardware Auto ack time
    R8_HSPI_AUX &= ~RB_HSPI_ACK_TX_MOD;
    //delay time
    R8_HSPI_AUX &= ~RB_HSPI_ACK_CNT_SEL;   //Delay 2T

    //release ALL_CLR  TRX_RST  (reset)
    R8_HSPI_CTRL &= ~(RB_HSPI_TRX_RST | RB_HSPI_ALL_CLR);

    //Enable Interupt
    R8_HSPI_INT_EN |= RB_HSPI_IE_R_DONE;  //Single packet received completed
    R8_HSPI_INT_EN |= RB_HSPI_IE_FIFO_OV;

    //config TX custom Header
    R32_HSPI_UDF0 = 0x00F0F0F;      //UDF0
    R32_HSPI_UDF1 = 0x00F0F0F;      //UDF1

    R32_HSPI_RX_ADDR0 = hspi_rx_addr;
    R32_HSPI_RX_ADDR1 = R32_HSPI_RX_ADDR0+PACKET_SIZE;
    g_hspi_rx_addr_base = hspi_rx_addr;

    //Enable HSPI  DMA
    R8_HSPI_CTRL |= RB_HSPI_ENABLE | RB_HSPI_DMA_EN;
}
