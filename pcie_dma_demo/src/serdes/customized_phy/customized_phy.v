//
//Written by GowinSynthesis
//Tool Version "V1.9.9.03 (64-bit)"
//Fri May 10 00:53:26 2024

//Source file index table:
//file0 "\C:/Gowin/Gowin_V1.9.9.03_x64/IDE/ipcore/SERDES_IP/IPlib/CUSTOMIZED/data/customized_phy_wrapper.v"
//file1 "\C:/Gowin/Gowin_V1.9.9.03_x64/IDE/ipcore/SERDES_IP/IPlib/CUSTOMIZED/data/customized_phy.v"
`timescale 100 ps/100 ps
module Customized_PHY_Top (
  Q0_LANE0_PCS_RX_O_FABRIC_CLK,
  Q0_LANE0_FABRIC_RX_CLK,
  Q0_FABRIC_LN0_RXDATA_O,
  Q0_LANE0_RX_IF_FIFO_RDEN,
  Q0_LANE0_RX_IF_FIFO_RDUSEWD,
  Q0_LANE0_RX_IF_FIFO_AEMPTY,
  Q0_LANE0_RX_IF_FIFO_EMPTY,
  Q0_FABRIC_LN0_RX_VLD_OUT,
  Q0_LANE0_PCS_TX_O_FABRIC_CLK,
  Q0_LANE0_FABRIC_TX_CLK,
  Q0_FABRIC_LN0_TXDATA_I,
  Q0_FABRIC_LN0_TX_VLD_IN,
  Q0_LANE0_TX_IF_FIFO_WRUSEWD,
  Q0_LANE0_TX_IF_FIFO_AFULL,
  Q0_LANE0_TX_IF_FIFO_FULL,
  Q0_FABRIC_LN0_STAT_O,
  Q0_LANE0_FABRIC_C2I_CLK,
  Q0_LANE0_CHBOND_START,
  Q0_FABRIC_LN0_RSTN_I,
  Q0_LANE0_PCS_RX_RST,
  Q0_LANE0_PCS_TX_RST,
  Q0_FABRIC_LANE0_CMU_CK_REF_O,
  Q0_FABRIC_LN0_ASTAT_O,
  Q0_FABRIC_LN0_PMA_RX_LOCK_O,
  Q0_LANE0_ALIGN_LINK,
  Q0_LANE0_K_LOCK,
  Q0_FABRIC_LANE0_CMU_OK_O,
  q0_ln0_rx_pcs_clkout_o,
  q0_ln0_rx_clk_i,
  q0_ln0_rx_data_o,
  q0_ln0_rx_fifo_rden_i,
  q0_ln0_rx_fifo_rdusewd_o,
  q0_ln0_rx_fifo_aempty_o,
  q0_ln0_rx_fifo_empty_o,
  q0_ln0_rx_valid_o,
  q0_ln0_tx_pcs_clkout_o,
  q0_ln0_tx_clk_i,
  q0_ln0_tx_data_i,
  q0_ln0_tx_fifo_wren_i,
  q0_ln0_tx_fifo_wrusewd_o,
  q0_ln0_tx_fifo_afull_o,
  q0_ln0_tx_fifo_full_o,
  q0_ln0_ready_o,
  q0_ln0_pma_rstn_i,
  q0_ln0_pcs_rx_rst_i,
  q0_ln0_pcs_tx_rst_i,
  q0_ln0_refclk_o,
  q0_ln0_signal_detect_o,
  q0_ln0_rx_cdr_lock_o,
  q0_ln0_pll_lock_o,
  Q0_LANE1_PCS_RX_O_FABRIC_CLK,
  Q0_LANE1_FABRIC_RX_CLK,
  Q0_FABRIC_LN1_RXDATA_O,
  Q0_LANE1_RX_IF_FIFO_RDEN,
  Q0_LANE1_RX_IF_FIFO_RDUSEWD,
  Q0_LANE1_RX_IF_FIFO_AEMPTY,
  Q0_LANE1_RX_IF_FIFO_EMPTY,
  Q0_FABRIC_LN1_RX_VLD_OUT,
  Q0_LANE1_PCS_TX_O_FABRIC_CLK,
  Q0_LANE1_FABRIC_TX_CLK,
  Q0_FABRIC_LN1_TXDATA_I,
  Q0_FABRIC_LN1_TX_VLD_IN,
  Q0_LANE1_TX_IF_FIFO_WRUSEWD,
  Q0_LANE1_TX_IF_FIFO_AFULL,
  Q0_LANE1_TX_IF_FIFO_FULL,
  Q0_FABRIC_LN1_STAT_O,
  Q0_LANE1_FABRIC_C2I_CLK,
  Q0_LANE1_CHBOND_START,
  Q0_FABRIC_LN1_RSTN_I,
  Q0_LANE1_PCS_RX_RST,
  Q0_LANE1_PCS_TX_RST,
  Q0_FABRIC_LANE1_CMU_CK_REF_O,
  Q0_FABRIC_LN1_ASTAT_O,
  Q0_FABRIC_LN1_PMA_RX_LOCK_O,
  Q0_LANE1_ALIGN_LINK,
  Q0_LANE1_K_LOCK,
  Q0_FABRIC_LANE1_CMU_OK_O,
  q0_ln1_rx_pcs_clkout_o,
  q0_ln1_rx_clk_i,
  q0_ln1_rx_data_o,
  q0_ln1_rx_fifo_rden_i,
  q0_ln1_rx_fifo_rdusewd_o,
  q0_ln1_rx_fifo_aempty_o,
  q0_ln1_rx_fifo_empty_o,
  q0_ln1_rx_valid_o,
  q0_ln1_tx_pcs_clkout_o,
  q0_ln1_tx_clk_i,
  q0_ln1_tx_data_i,
  q0_ln1_tx_fifo_wren_i,
  q0_ln1_tx_fifo_wrusewd_o,
  q0_ln1_tx_fifo_afull_o,
  q0_ln1_tx_fifo_full_o,
  q0_ln1_ready_o,
  q0_ln1_pma_rstn_i,
  q0_ln1_pcs_rx_rst_i,
  q0_ln1_pcs_tx_rst_i,
  q0_ln1_refclk_o,
  q0_ln1_signal_detect_o,
  q0_ln1_rx_cdr_lock_o,
  q0_ln1_pll_lock_o,
  Q0_LANE2_PCS_RX_O_FABRIC_CLK,
  Q0_LANE2_FABRIC_RX_CLK,
  Q0_FABRIC_LN2_RXDATA_O,
  Q0_LANE2_RX_IF_FIFO_RDEN,
  Q0_LANE2_RX_IF_FIFO_RDUSEWD,
  Q0_LANE2_RX_IF_FIFO_AEMPTY,
  Q0_LANE2_RX_IF_FIFO_EMPTY,
  Q0_FABRIC_LN2_RX_VLD_OUT,
  Q0_LANE2_PCS_TX_O_FABRIC_CLK,
  Q0_LANE2_FABRIC_TX_CLK,
  Q0_FABRIC_LN2_TXDATA_I,
  Q0_FABRIC_LN2_TX_VLD_IN,
  Q0_LANE2_TX_IF_FIFO_WRUSEWD,
  Q0_LANE2_TX_IF_FIFO_AFULL,
  Q0_LANE2_TX_IF_FIFO_FULL,
  Q0_FABRIC_LN2_STAT_O,
  Q0_LANE2_FABRIC_C2I_CLK,
  Q0_LANE2_CHBOND_START,
  Q0_FABRIC_LN2_RSTN_I,
  Q0_LANE2_PCS_RX_RST,
  Q0_LANE2_PCS_TX_RST,
  Q0_FABRIC_LANE2_CMU_CK_REF_O,
  Q0_FABRIC_LN2_ASTAT_O,
  Q0_FABRIC_LN2_PMA_RX_LOCK_O,
  Q0_LANE2_ALIGN_LINK,
  Q0_LANE2_K_LOCK,
  Q0_FABRIC_LANE2_CMU_OK_O,
  q0_ln2_rx_pcs_clkout_o,
  q0_ln2_rx_clk_i,
  q0_ln2_rx_data_o,
  q0_ln2_rx_fifo_rden_i,
  q0_ln2_rx_fifo_rdusewd_o,
  q0_ln2_rx_fifo_aempty_o,
  q0_ln2_rx_fifo_empty_o,
  q0_ln2_rx_valid_o,
  q0_ln2_tx_pcs_clkout_o,
  q0_ln2_tx_clk_i,
  q0_ln2_tx_data_i,
  q0_ln2_tx_fifo_wren_i,
  q0_ln2_tx_fifo_wrusewd_o,
  q0_ln2_tx_fifo_afull_o,
  q0_ln2_tx_fifo_full_o,
  q0_ln2_ready_o,
  q0_ln2_pma_rstn_i,
  q0_ln2_pcs_rx_rst_i,
  q0_ln2_pcs_tx_rst_i,
  q0_ln2_refclk_o,
  q0_ln2_signal_detect_o,
  q0_ln2_rx_cdr_lock_o,
  q0_ln2_pll_lock_o,
  Q0_LANE3_PCS_RX_O_FABRIC_CLK,
  Q0_LANE3_FABRIC_RX_CLK,
  Q0_FABRIC_LN3_RXDATA_O,
  Q0_LANE3_RX_IF_FIFO_RDEN,
  Q0_LANE3_RX_IF_FIFO_RDUSEWD,
  Q0_LANE3_RX_IF_FIFO_AEMPTY,
  Q0_LANE3_RX_IF_FIFO_EMPTY,
  Q0_FABRIC_LN3_RX_VLD_OUT,
  Q0_LANE3_PCS_TX_O_FABRIC_CLK,
  Q0_LANE3_FABRIC_TX_CLK,
  Q0_FABRIC_LN3_TXDATA_I,
  Q0_FABRIC_LN3_TX_VLD_IN,
  Q0_LANE3_TX_IF_FIFO_WRUSEWD,
  Q0_LANE3_TX_IF_FIFO_AFULL,
  Q0_LANE3_TX_IF_FIFO_FULL,
  Q0_FABRIC_LN3_STAT_O,
  Q0_LANE3_FABRIC_C2I_CLK,
  Q0_LANE3_CHBOND_START,
  Q0_FABRIC_LN3_RSTN_I,
  Q0_LANE3_PCS_RX_RST,
  Q0_LANE3_PCS_TX_RST,
  Q0_FABRIC_LANE3_CMU_CK_REF_O,
  Q0_FABRIC_LN3_ASTAT_O,
  Q0_FABRIC_LN3_PMA_RX_LOCK_O,
  Q0_LANE3_ALIGN_LINK,
  Q0_LANE3_K_LOCK,
  Q0_FABRIC_LANE3_CMU_OK_O,
  q0_ln3_rx_pcs_clkout_o,
  q0_ln3_rx_clk_i,
  q0_ln3_rx_data_o,
  q0_ln3_rx_fifo_rden_i,
  q0_ln3_rx_fifo_rdusewd_o,
  q0_ln3_rx_fifo_aempty_o,
  q0_ln3_rx_fifo_empty_o,
  q0_ln3_rx_valid_o,
  q0_ln3_tx_pcs_clkout_o,
  q0_ln3_tx_clk_i,
  q0_ln3_tx_data_i,
  q0_ln3_tx_fifo_wren_i,
  q0_ln3_tx_fifo_wrusewd_o,
  q0_ln3_tx_fifo_afull_o,
  q0_ln3_tx_fifo_full_o,
  q0_ln3_ready_o,
  q0_ln3_pma_rstn_i,
  q0_ln3_pcs_rx_rst_i,
  q0_ln3_pcs_tx_rst_i,
  q0_ln3_refclk_o,
  q0_ln3_signal_detect_o,
  q0_ln3_rx_cdr_lock_o,
  q0_ln3_pll_lock_o,
  Q0_FABRIC_CMU_CK_REF_O,
  Q0_FABRIC_CMU1_CK_REF_O,
  Q0_FABRIC_CMU1_OK_O,
  Q0_FABRIC_CMU_OK_O,
  Q1_FABRIC_CMU_CK_REF_O,
  Q1_FABRIC_CMU1_CK_REF_O,
  Q1_FABRIC_CMU1_OK_O,
  Q1_FABRIC_CMU_OK_O
)
;
input Q0_LANE0_PCS_RX_O_FABRIC_CLK;
output Q0_LANE0_FABRIC_RX_CLK;
input [87:0] Q0_FABRIC_LN0_RXDATA_O;
output Q0_LANE0_RX_IF_FIFO_RDEN;
input [4:0] Q0_LANE0_RX_IF_FIFO_RDUSEWD;
input Q0_LANE0_RX_IF_FIFO_AEMPTY;
input Q0_LANE0_RX_IF_FIFO_EMPTY;
input Q0_FABRIC_LN0_RX_VLD_OUT;
input Q0_LANE0_PCS_TX_O_FABRIC_CLK;
output Q0_LANE0_FABRIC_TX_CLK;
output [79:0] Q0_FABRIC_LN0_TXDATA_I;
output Q0_FABRIC_LN0_TX_VLD_IN;
input [4:0] Q0_LANE0_TX_IF_FIFO_WRUSEWD;
input Q0_LANE0_TX_IF_FIFO_AFULL;
input Q0_LANE0_TX_IF_FIFO_FULL;
input [12:0] Q0_FABRIC_LN0_STAT_O;
output Q0_LANE0_FABRIC_C2I_CLK;
output Q0_LANE0_CHBOND_START;
output Q0_FABRIC_LN0_RSTN_I;
output Q0_LANE0_PCS_RX_RST;
output Q0_LANE0_PCS_TX_RST;
input Q0_FABRIC_LANE0_CMU_CK_REF_O;
input [5:0] Q0_FABRIC_LN0_ASTAT_O;
input Q0_FABRIC_LN0_PMA_RX_LOCK_O;
input Q0_LANE0_ALIGN_LINK;
input Q0_LANE0_K_LOCK;
input Q0_FABRIC_LANE0_CMU_OK_O;
output q0_ln0_rx_pcs_clkout_o;
input q0_ln0_rx_clk_i;
output [87:0] q0_ln0_rx_data_o;
input q0_ln0_rx_fifo_rden_i;
output [4:0] q0_ln0_rx_fifo_rdusewd_o;
output q0_ln0_rx_fifo_aempty_o;
output q0_ln0_rx_fifo_empty_o;
output q0_ln0_rx_valid_o;
output q0_ln0_tx_pcs_clkout_o;
input q0_ln0_tx_clk_i;
input [79:0] q0_ln0_tx_data_i;
input q0_ln0_tx_fifo_wren_i;
output [4:0] q0_ln0_tx_fifo_wrusewd_o;
output q0_ln0_tx_fifo_afull_o;
output q0_ln0_tx_fifo_full_o;
output q0_ln0_ready_o;
input q0_ln0_pma_rstn_i;
input q0_ln0_pcs_rx_rst_i;
input q0_ln0_pcs_tx_rst_i;
output q0_ln0_refclk_o;
output q0_ln0_signal_detect_o;
output q0_ln0_rx_cdr_lock_o;
output q0_ln0_pll_lock_o;
input Q0_LANE1_PCS_RX_O_FABRIC_CLK;
output Q0_LANE1_FABRIC_RX_CLK;
input [87:0] Q0_FABRIC_LN1_RXDATA_O;
output Q0_LANE1_RX_IF_FIFO_RDEN;
input [4:0] Q0_LANE1_RX_IF_FIFO_RDUSEWD;
input Q0_LANE1_RX_IF_FIFO_AEMPTY;
input Q0_LANE1_RX_IF_FIFO_EMPTY;
input Q0_FABRIC_LN1_RX_VLD_OUT;
input Q0_LANE1_PCS_TX_O_FABRIC_CLK;
output Q0_LANE1_FABRIC_TX_CLK;
output [79:0] Q0_FABRIC_LN1_TXDATA_I;
output Q0_FABRIC_LN1_TX_VLD_IN;
input [4:0] Q0_LANE1_TX_IF_FIFO_WRUSEWD;
input Q0_LANE1_TX_IF_FIFO_AFULL;
input Q0_LANE1_TX_IF_FIFO_FULL;
input [12:0] Q0_FABRIC_LN1_STAT_O;
output Q0_LANE1_FABRIC_C2I_CLK;
output Q0_LANE1_CHBOND_START;
output Q0_FABRIC_LN1_RSTN_I;
output Q0_LANE1_PCS_RX_RST;
output Q0_LANE1_PCS_TX_RST;
input Q0_FABRIC_LANE1_CMU_CK_REF_O;
input [5:0] Q0_FABRIC_LN1_ASTAT_O;
input Q0_FABRIC_LN1_PMA_RX_LOCK_O;
input Q0_LANE1_ALIGN_LINK;
input Q0_LANE1_K_LOCK;
input Q0_FABRIC_LANE1_CMU_OK_O;
output q0_ln1_rx_pcs_clkout_o;
input q0_ln1_rx_clk_i;
output [87:0] q0_ln1_rx_data_o;
input q0_ln1_rx_fifo_rden_i;
output [4:0] q0_ln1_rx_fifo_rdusewd_o;
output q0_ln1_rx_fifo_aempty_o;
output q0_ln1_rx_fifo_empty_o;
output q0_ln1_rx_valid_o;
output q0_ln1_tx_pcs_clkout_o;
input q0_ln1_tx_clk_i;
input [79:0] q0_ln1_tx_data_i;
input q0_ln1_tx_fifo_wren_i;
output [4:0] q0_ln1_tx_fifo_wrusewd_o;
output q0_ln1_tx_fifo_afull_o;
output q0_ln1_tx_fifo_full_o;
output q0_ln1_ready_o;
input q0_ln1_pma_rstn_i;
input q0_ln1_pcs_rx_rst_i;
input q0_ln1_pcs_tx_rst_i;
output q0_ln1_refclk_o;
output q0_ln1_signal_detect_o;
output q0_ln1_rx_cdr_lock_o;
output q0_ln1_pll_lock_o;
input Q0_LANE2_PCS_RX_O_FABRIC_CLK;
output Q0_LANE2_FABRIC_RX_CLK;
input [87:0] Q0_FABRIC_LN2_RXDATA_O;
output Q0_LANE2_RX_IF_FIFO_RDEN;
input [4:0] Q0_LANE2_RX_IF_FIFO_RDUSEWD;
input Q0_LANE2_RX_IF_FIFO_AEMPTY;
input Q0_LANE2_RX_IF_FIFO_EMPTY;
input Q0_FABRIC_LN2_RX_VLD_OUT;
input Q0_LANE2_PCS_TX_O_FABRIC_CLK;
output Q0_LANE2_FABRIC_TX_CLK;
output [79:0] Q0_FABRIC_LN2_TXDATA_I;
output Q0_FABRIC_LN2_TX_VLD_IN;
input [4:0] Q0_LANE2_TX_IF_FIFO_WRUSEWD;
input Q0_LANE2_TX_IF_FIFO_AFULL;
input Q0_LANE2_TX_IF_FIFO_FULL;
input [12:0] Q0_FABRIC_LN2_STAT_O;
output Q0_LANE2_FABRIC_C2I_CLK;
output Q0_LANE2_CHBOND_START;
output Q0_FABRIC_LN2_RSTN_I;
output Q0_LANE2_PCS_RX_RST;
output Q0_LANE2_PCS_TX_RST;
input Q0_FABRIC_LANE2_CMU_CK_REF_O;
input [5:0] Q0_FABRIC_LN2_ASTAT_O;
input Q0_FABRIC_LN2_PMA_RX_LOCK_O;
input Q0_LANE2_ALIGN_LINK;
input Q0_LANE2_K_LOCK;
input Q0_FABRIC_LANE2_CMU_OK_O;
output q0_ln2_rx_pcs_clkout_o;
input q0_ln2_rx_clk_i;
output [87:0] q0_ln2_rx_data_o;
input q0_ln2_rx_fifo_rden_i;
output [4:0] q0_ln2_rx_fifo_rdusewd_o;
output q0_ln2_rx_fifo_aempty_o;
output q0_ln2_rx_fifo_empty_o;
output q0_ln2_rx_valid_o;
output q0_ln2_tx_pcs_clkout_o;
input q0_ln2_tx_clk_i;
input [79:0] q0_ln2_tx_data_i;
input q0_ln2_tx_fifo_wren_i;
output [4:0] q0_ln2_tx_fifo_wrusewd_o;
output q0_ln2_tx_fifo_afull_o;
output q0_ln2_tx_fifo_full_o;
output q0_ln2_ready_o;
input q0_ln2_pma_rstn_i;
input q0_ln2_pcs_rx_rst_i;
input q0_ln2_pcs_tx_rst_i;
output q0_ln2_refclk_o;
output q0_ln2_signal_detect_o;
output q0_ln2_rx_cdr_lock_o;
output q0_ln2_pll_lock_o;
input Q0_LANE3_PCS_RX_O_FABRIC_CLK;
output Q0_LANE3_FABRIC_RX_CLK;
input [87:0] Q0_FABRIC_LN3_RXDATA_O;
output Q0_LANE3_RX_IF_FIFO_RDEN;
input [4:0] Q0_LANE3_RX_IF_FIFO_RDUSEWD;
input Q0_LANE3_RX_IF_FIFO_AEMPTY;
input Q0_LANE3_RX_IF_FIFO_EMPTY;
input Q0_FABRIC_LN3_RX_VLD_OUT;
input Q0_LANE3_PCS_TX_O_FABRIC_CLK;
output Q0_LANE3_FABRIC_TX_CLK;
output [79:0] Q0_FABRIC_LN3_TXDATA_I;
output Q0_FABRIC_LN3_TX_VLD_IN;
input [4:0] Q0_LANE3_TX_IF_FIFO_WRUSEWD;
input Q0_LANE3_TX_IF_FIFO_AFULL;
input Q0_LANE3_TX_IF_FIFO_FULL;
input [12:0] Q0_FABRIC_LN3_STAT_O;
output Q0_LANE3_FABRIC_C2I_CLK;
output Q0_LANE3_CHBOND_START;
output Q0_FABRIC_LN3_RSTN_I;
output Q0_LANE3_PCS_RX_RST;
output Q0_LANE3_PCS_TX_RST;
input Q0_FABRIC_LANE3_CMU_CK_REF_O;
input [5:0] Q0_FABRIC_LN3_ASTAT_O;
input Q0_FABRIC_LN3_PMA_RX_LOCK_O;
input Q0_LANE3_ALIGN_LINK;
input Q0_LANE3_K_LOCK;
input Q0_FABRIC_LANE3_CMU_OK_O;
output q0_ln3_rx_pcs_clkout_o;
input q0_ln3_rx_clk_i;
output [87:0] q0_ln3_rx_data_o;
input q0_ln3_rx_fifo_rden_i;
output [4:0] q0_ln3_rx_fifo_rdusewd_o;
output q0_ln3_rx_fifo_aempty_o;
output q0_ln3_rx_fifo_empty_o;
output q0_ln3_rx_valid_o;
output q0_ln3_tx_pcs_clkout_o;
input q0_ln3_tx_clk_i;
input [79:0] q0_ln3_tx_data_i;
input q0_ln3_tx_fifo_wren_i;
output [4:0] q0_ln3_tx_fifo_wrusewd_o;
output q0_ln3_tx_fifo_afull_o;
output q0_ln3_tx_fifo_full_o;
output q0_ln3_ready_o;
input q0_ln3_pma_rstn_i;
input q0_ln3_pcs_rx_rst_i;
input q0_ln3_pcs_tx_rst_i;
output q0_ln3_refclk_o;
output q0_ln3_signal_detect_o;
output q0_ln3_rx_cdr_lock_o;
output q0_ln3_pll_lock_o;
input Q0_FABRIC_CMU_CK_REF_O;
input Q0_FABRIC_CMU1_CK_REF_O;
input Q0_FABRIC_CMU1_OK_O;
input Q0_FABRIC_CMU_OK_O;
input Q1_FABRIC_CMU_CK_REF_O;
input Q1_FABRIC_CMU1_CK_REF_O;
input Q1_FABRIC_CMU1_OK_O;
input Q1_FABRIC_CMU_OK_O;
wire VCC;
wire GND;
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
  GSR GSR (
    .GSRI(VCC) 
);
assign Q0_LANE0_FABRIC_RX_CLK = q0_ln0_rx_clk_i;
assign Q0_LANE0_RX_IF_FIFO_RDEN = q0_ln0_rx_fifo_rden_i;
assign Q0_LANE0_FABRIC_TX_CLK = q0_ln0_tx_clk_i;
assign Q0_FABRIC_LN0_TXDATA_I[0] = q0_ln0_tx_data_i[0];
assign Q0_FABRIC_LN0_TXDATA_I[1] = q0_ln0_tx_data_i[1];
assign Q0_FABRIC_LN0_TXDATA_I[2] = q0_ln0_tx_data_i[2];
assign Q0_FABRIC_LN0_TXDATA_I[3] = q0_ln0_tx_data_i[3];
assign Q0_FABRIC_LN0_TXDATA_I[4] = q0_ln0_tx_data_i[4];
assign Q0_FABRIC_LN0_TXDATA_I[5] = q0_ln0_tx_data_i[5];
assign Q0_FABRIC_LN0_TXDATA_I[6] = q0_ln0_tx_data_i[6];
assign Q0_FABRIC_LN0_TXDATA_I[7] = q0_ln0_tx_data_i[7];
assign Q0_FABRIC_LN0_TXDATA_I[8] = q0_ln0_tx_data_i[8];
assign Q0_FABRIC_LN0_TXDATA_I[9] = q0_ln0_tx_data_i[9];
assign Q0_FABRIC_LN0_TXDATA_I[10] = q0_ln0_tx_data_i[10];
assign Q0_FABRIC_LN0_TXDATA_I[11] = q0_ln0_tx_data_i[11];
assign Q0_FABRIC_LN0_TXDATA_I[12] = q0_ln0_tx_data_i[12];
assign Q0_FABRIC_LN0_TXDATA_I[13] = q0_ln0_tx_data_i[13];
assign Q0_FABRIC_LN0_TXDATA_I[14] = q0_ln0_tx_data_i[14];
assign Q0_FABRIC_LN0_TXDATA_I[15] = q0_ln0_tx_data_i[15];
assign Q0_FABRIC_LN0_TXDATA_I[16] = q0_ln0_tx_data_i[16];
assign Q0_FABRIC_LN0_TXDATA_I[17] = q0_ln0_tx_data_i[17];
assign Q0_FABRIC_LN0_TXDATA_I[18] = q0_ln0_tx_data_i[18];
assign Q0_FABRIC_LN0_TXDATA_I[19] = q0_ln0_tx_data_i[19];
assign Q0_FABRIC_LN0_TXDATA_I[20] = q0_ln0_tx_data_i[20];
assign Q0_FABRIC_LN0_TXDATA_I[21] = q0_ln0_tx_data_i[21];
assign Q0_FABRIC_LN0_TXDATA_I[22] = q0_ln0_tx_data_i[22];
assign Q0_FABRIC_LN0_TXDATA_I[23] = q0_ln0_tx_data_i[23];
assign Q0_FABRIC_LN0_TXDATA_I[24] = q0_ln0_tx_data_i[24];
assign Q0_FABRIC_LN0_TXDATA_I[25] = q0_ln0_tx_data_i[25];
assign Q0_FABRIC_LN0_TXDATA_I[26] = q0_ln0_tx_data_i[26];
assign Q0_FABRIC_LN0_TXDATA_I[27] = q0_ln0_tx_data_i[27];
assign Q0_FABRIC_LN0_TXDATA_I[28] = q0_ln0_tx_data_i[28];
assign Q0_FABRIC_LN0_TXDATA_I[29] = q0_ln0_tx_data_i[29];
assign Q0_FABRIC_LN0_TXDATA_I[30] = q0_ln0_tx_data_i[30];
assign Q0_FABRIC_LN0_TXDATA_I[31] = q0_ln0_tx_data_i[31];
assign Q0_FABRIC_LN0_TXDATA_I[32] = q0_ln0_tx_data_i[32];
assign Q0_FABRIC_LN0_TXDATA_I[33] = q0_ln0_tx_data_i[33];
assign Q0_FABRIC_LN0_TXDATA_I[34] = q0_ln0_tx_data_i[34];
assign Q0_FABRIC_LN0_TXDATA_I[35] = q0_ln0_tx_data_i[35];
assign Q0_FABRIC_LN0_TXDATA_I[36] = q0_ln0_tx_data_i[36];
assign Q0_FABRIC_LN0_TXDATA_I[37] = q0_ln0_tx_data_i[37];
assign Q0_FABRIC_LN0_TXDATA_I[38] = q0_ln0_tx_data_i[38];
assign Q0_FABRIC_LN0_TXDATA_I[39] = q0_ln0_tx_data_i[39];
assign Q0_FABRIC_LN0_TXDATA_I[40] = q0_ln0_tx_data_i[40];
assign Q0_FABRIC_LN0_TXDATA_I[41] = q0_ln0_tx_data_i[41];
assign Q0_FABRIC_LN0_TXDATA_I[42] = q0_ln0_tx_data_i[42];
assign Q0_FABRIC_LN0_TXDATA_I[43] = q0_ln0_tx_data_i[43];
assign Q0_FABRIC_LN0_TXDATA_I[44] = q0_ln0_tx_data_i[44];
assign Q0_FABRIC_LN0_TXDATA_I[45] = q0_ln0_tx_data_i[45];
assign Q0_FABRIC_LN0_TXDATA_I[46] = q0_ln0_tx_data_i[46];
assign Q0_FABRIC_LN0_TXDATA_I[47] = q0_ln0_tx_data_i[47];
assign Q0_FABRIC_LN0_TXDATA_I[48] = q0_ln0_tx_data_i[48];
assign Q0_FABRIC_LN0_TXDATA_I[49] = q0_ln0_tx_data_i[49];
assign Q0_FABRIC_LN0_TXDATA_I[50] = q0_ln0_tx_data_i[50];
assign Q0_FABRIC_LN0_TXDATA_I[51] = q0_ln0_tx_data_i[51];
assign Q0_FABRIC_LN0_TXDATA_I[52] = q0_ln0_tx_data_i[52];
assign Q0_FABRIC_LN0_TXDATA_I[53] = q0_ln0_tx_data_i[53];
assign Q0_FABRIC_LN0_TXDATA_I[54] = q0_ln0_tx_data_i[54];
assign Q0_FABRIC_LN0_TXDATA_I[55] = q0_ln0_tx_data_i[55];
assign Q0_FABRIC_LN0_TXDATA_I[56] = q0_ln0_tx_data_i[56];
assign Q0_FABRIC_LN0_TXDATA_I[57] = q0_ln0_tx_data_i[57];
assign Q0_FABRIC_LN0_TXDATA_I[58] = q0_ln0_tx_data_i[58];
assign Q0_FABRIC_LN0_TXDATA_I[59] = q0_ln0_tx_data_i[59];
assign Q0_FABRIC_LN0_TXDATA_I[60] = q0_ln0_tx_data_i[60];
assign Q0_FABRIC_LN0_TXDATA_I[61] = q0_ln0_tx_data_i[61];
assign Q0_FABRIC_LN0_TXDATA_I[62] = q0_ln0_tx_data_i[62];
assign Q0_FABRIC_LN0_TXDATA_I[63] = q0_ln0_tx_data_i[63];
assign Q0_FABRIC_LN0_TXDATA_I[64] = q0_ln0_tx_data_i[64];
assign Q0_FABRIC_LN0_TXDATA_I[65] = q0_ln0_tx_data_i[65];
assign Q0_FABRIC_LN0_TXDATA_I[66] = q0_ln0_tx_data_i[66];
assign Q0_FABRIC_LN0_TXDATA_I[67] = q0_ln0_tx_data_i[67];
assign Q0_FABRIC_LN0_TXDATA_I[68] = q0_ln0_tx_data_i[68];
assign Q0_FABRIC_LN0_TXDATA_I[69] = q0_ln0_tx_data_i[69];
assign Q0_FABRIC_LN0_TXDATA_I[70] = q0_ln0_tx_data_i[70];
assign Q0_FABRIC_LN0_TXDATA_I[71] = q0_ln0_tx_data_i[71];
assign Q0_FABRIC_LN0_TXDATA_I[72] = q0_ln0_tx_data_i[72];
assign Q0_FABRIC_LN0_TXDATA_I[73] = q0_ln0_tx_data_i[73];
assign Q0_FABRIC_LN0_TXDATA_I[74] = q0_ln0_tx_data_i[74];
assign Q0_FABRIC_LN0_TXDATA_I[75] = q0_ln0_tx_data_i[75];
assign Q0_FABRIC_LN0_TXDATA_I[76] = q0_ln0_tx_data_i[76];
assign Q0_FABRIC_LN0_TXDATA_I[77] = q0_ln0_tx_data_i[77];
assign Q0_FABRIC_LN0_TXDATA_I[78] = q0_ln0_tx_data_i[78];
assign Q0_FABRIC_LN0_TXDATA_I[79] = q0_ln0_tx_data_i[79];
assign Q0_FABRIC_LN0_TX_VLD_IN = q0_ln0_tx_fifo_wren_i;
assign Q0_LANE0_FABRIC_C2I_CLK = GND;
assign Q0_LANE0_CHBOND_START = GND;
assign Q0_FABRIC_LN0_RSTN_I = q0_ln0_pma_rstn_i;
assign Q0_LANE0_PCS_RX_RST = q0_ln0_pcs_rx_rst_i;
assign Q0_LANE0_PCS_TX_RST = q0_ln0_pcs_tx_rst_i;
assign q0_ln0_rx_pcs_clkout_o = Q0_LANE0_PCS_RX_O_FABRIC_CLK;
assign q0_ln0_rx_data_o[0] = Q0_FABRIC_LN0_RXDATA_O[0];
assign q0_ln0_rx_data_o[1] = Q0_FABRIC_LN0_RXDATA_O[1];
assign q0_ln0_rx_data_o[2] = Q0_FABRIC_LN0_RXDATA_O[2];
assign q0_ln0_rx_data_o[3] = Q0_FABRIC_LN0_RXDATA_O[3];
assign q0_ln0_rx_data_o[4] = Q0_FABRIC_LN0_RXDATA_O[4];
assign q0_ln0_rx_data_o[5] = Q0_FABRIC_LN0_RXDATA_O[5];
assign q0_ln0_rx_data_o[6] = Q0_FABRIC_LN0_RXDATA_O[6];
assign q0_ln0_rx_data_o[7] = Q0_FABRIC_LN0_RXDATA_O[7];
assign q0_ln0_rx_data_o[8] = Q0_FABRIC_LN0_RXDATA_O[8];
assign q0_ln0_rx_data_o[9] = Q0_FABRIC_LN0_RXDATA_O[9];
assign q0_ln0_rx_data_o[10] = Q0_FABRIC_LN0_RXDATA_O[10];
assign q0_ln0_rx_data_o[11] = Q0_FABRIC_LN0_RXDATA_O[11];
assign q0_ln0_rx_data_o[12] = Q0_FABRIC_LN0_RXDATA_O[12];
assign q0_ln0_rx_data_o[13] = Q0_FABRIC_LN0_RXDATA_O[13];
assign q0_ln0_rx_data_o[14] = Q0_FABRIC_LN0_RXDATA_O[14];
assign q0_ln0_rx_data_o[15] = Q0_FABRIC_LN0_RXDATA_O[15];
assign q0_ln0_rx_data_o[16] = Q0_FABRIC_LN0_RXDATA_O[16];
assign q0_ln0_rx_data_o[17] = Q0_FABRIC_LN0_RXDATA_O[17];
assign q0_ln0_rx_data_o[18] = Q0_FABRIC_LN0_RXDATA_O[18];
assign q0_ln0_rx_data_o[19] = Q0_FABRIC_LN0_RXDATA_O[19];
assign q0_ln0_rx_data_o[20] = Q0_FABRIC_LN0_RXDATA_O[20];
assign q0_ln0_rx_data_o[21] = Q0_FABRIC_LN0_RXDATA_O[21];
assign q0_ln0_rx_data_o[22] = Q0_FABRIC_LN0_RXDATA_O[22];
assign q0_ln0_rx_data_o[23] = Q0_FABRIC_LN0_RXDATA_O[23];
assign q0_ln0_rx_data_o[24] = Q0_FABRIC_LN0_RXDATA_O[24];
assign q0_ln0_rx_data_o[25] = Q0_FABRIC_LN0_RXDATA_O[25];
assign q0_ln0_rx_data_o[26] = Q0_FABRIC_LN0_RXDATA_O[26];
assign q0_ln0_rx_data_o[27] = Q0_FABRIC_LN0_RXDATA_O[27];
assign q0_ln0_rx_data_o[28] = Q0_FABRIC_LN0_RXDATA_O[28];
assign q0_ln0_rx_data_o[29] = Q0_FABRIC_LN0_RXDATA_O[29];
assign q0_ln0_rx_data_o[30] = Q0_FABRIC_LN0_RXDATA_O[30];
assign q0_ln0_rx_data_o[31] = Q0_FABRIC_LN0_RXDATA_O[31];
assign q0_ln0_rx_data_o[32] = Q0_FABRIC_LN0_RXDATA_O[32];
assign q0_ln0_rx_data_o[33] = Q0_FABRIC_LN0_RXDATA_O[33];
assign q0_ln0_rx_data_o[34] = Q0_FABRIC_LN0_RXDATA_O[34];
assign q0_ln0_rx_data_o[35] = Q0_FABRIC_LN0_RXDATA_O[35];
assign q0_ln0_rx_data_o[36] = Q0_FABRIC_LN0_RXDATA_O[36];
assign q0_ln0_rx_data_o[37] = Q0_FABRIC_LN0_RXDATA_O[37];
assign q0_ln0_rx_data_o[38] = Q0_FABRIC_LN0_RXDATA_O[38];
assign q0_ln0_rx_data_o[39] = Q0_FABRIC_LN0_RXDATA_O[39];
assign q0_ln0_rx_data_o[40] = Q0_FABRIC_LN0_RXDATA_O[40];
assign q0_ln0_rx_data_o[41] = Q0_FABRIC_LN0_RXDATA_O[41];
assign q0_ln0_rx_data_o[42] = Q0_FABRIC_LN0_RXDATA_O[42];
assign q0_ln0_rx_data_o[43] = Q0_FABRIC_LN0_RXDATA_O[43];
assign q0_ln0_rx_data_o[44] = Q0_FABRIC_LN0_RXDATA_O[44];
assign q0_ln0_rx_data_o[45] = Q0_FABRIC_LN0_RXDATA_O[45];
assign q0_ln0_rx_data_o[46] = Q0_FABRIC_LN0_RXDATA_O[46];
assign q0_ln0_rx_data_o[47] = Q0_FABRIC_LN0_RXDATA_O[47];
assign q0_ln0_rx_data_o[48] = Q0_FABRIC_LN0_RXDATA_O[48];
assign q0_ln0_rx_data_o[49] = Q0_FABRIC_LN0_RXDATA_O[49];
assign q0_ln0_rx_data_o[50] = Q0_FABRIC_LN0_RXDATA_O[50];
assign q0_ln0_rx_data_o[51] = Q0_FABRIC_LN0_RXDATA_O[51];
assign q0_ln0_rx_data_o[52] = Q0_FABRIC_LN0_RXDATA_O[52];
assign q0_ln0_rx_data_o[53] = Q0_FABRIC_LN0_RXDATA_O[53];
assign q0_ln0_rx_data_o[54] = Q0_FABRIC_LN0_RXDATA_O[54];
assign q0_ln0_rx_data_o[55] = Q0_FABRIC_LN0_RXDATA_O[55];
assign q0_ln0_rx_data_o[56] = Q0_FABRIC_LN0_RXDATA_O[56];
assign q0_ln0_rx_data_o[57] = Q0_FABRIC_LN0_RXDATA_O[57];
assign q0_ln0_rx_data_o[58] = Q0_FABRIC_LN0_RXDATA_O[58];
assign q0_ln0_rx_data_o[59] = Q0_FABRIC_LN0_RXDATA_O[59];
assign q0_ln0_rx_data_o[60] = Q0_FABRIC_LN0_RXDATA_O[60];
assign q0_ln0_rx_data_o[61] = Q0_FABRIC_LN0_RXDATA_O[61];
assign q0_ln0_rx_data_o[62] = Q0_FABRIC_LN0_RXDATA_O[62];
assign q0_ln0_rx_data_o[63] = Q0_FABRIC_LN0_RXDATA_O[63];
assign q0_ln0_rx_data_o[64] = Q0_FABRIC_LN0_RXDATA_O[64];
assign q0_ln0_rx_data_o[65] = Q0_FABRIC_LN0_RXDATA_O[65];
assign q0_ln0_rx_data_o[66] = Q0_FABRIC_LN0_RXDATA_O[66];
assign q0_ln0_rx_data_o[67] = Q0_FABRIC_LN0_RXDATA_O[67];
assign q0_ln0_rx_data_o[68] = Q0_FABRIC_LN0_RXDATA_O[68];
assign q0_ln0_rx_data_o[69] = Q0_FABRIC_LN0_RXDATA_O[69];
assign q0_ln0_rx_data_o[70] = Q0_FABRIC_LN0_RXDATA_O[70];
assign q0_ln0_rx_data_o[71] = Q0_FABRIC_LN0_RXDATA_O[71];
assign q0_ln0_rx_data_o[72] = Q0_FABRIC_LN0_RXDATA_O[72];
assign q0_ln0_rx_data_o[73] = Q0_FABRIC_LN0_RXDATA_O[73];
assign q0_ln0_rx_data_o[74] = Q0_FABRIC_LN0_RXDATA_O[74];
assign q0_ln0_rx_data_o[75] = Q0_FABRIC_LN0_RXDATA_O[75];
assign q0_ln0_rx_data_o[76] = Q0_FABRIC_LN0_RXDATA_O[76];
assign q0_ln0_rx_data_o[77] = Q0_FABRIC_LN0_RXDATA_O[77];
assign q0_ln0_rx_data_o[78] = Q0_FABRIC_LN0_RXDATA_O[78];
assign q0_ln0_rx_data_o[79] = Q0_FABRIC_LN0_RXDATA_O[79];
assign q0_ln0_rx_data_o[80] = Q0_FABRIC_LN0_RXDATA_O[80];
assign q0_ln0_rx_data_o[81] = Q0_FABRIC_LN0_RXDATA_O[81];
assign q0_ln0_rx_data_o[82] = Q0_FABRIC_LN0_RXDATA_O[82];
assign q0_ln0_rx_data_o[83] = Q0_FABRIC_LN0_RXDATA_O[83];
assign q0_ln0_rx_data_o[84] = Q0_FABRIC_LN0_RXDATA_O[84];
assign q0_ln0_rx_data_o[85] = Q0_FABRIC_LN0_RXDATA_O[85];
assign q0_ln0_rx_data_o[86] = Q0_FABRIC_LN0_RXDATA_O[86];
assign q0_ln0_rx_data_o[87] = Q0_FABRIC_LN0_RXDATA_O[87];
assign q0_ln0_rx_fifo_rdusewd_o[0] = Q0_LANE0_RX_IF_FIFO_RDUSEWD[0];
assign q0_ln0_rx_fifo_rdusewd_o[1] = Q0_LANE0_RX_IF_FIFO_RDUSEWD[1];
assign q0_ln0_rx_fifo_rdusewd_o[2] = Q0_LANE0_RX_IF_FIFO_RDUSEWD[2];
assign q0_ln0_rx_fifo_rdusewd_o[3] = Q0_LANE0_RX_IF_FIFO_RDUSEWD[3];
assign q0_ln0_rx_fifo_rdusewd_o[4] = Q0_LANE0_RX_IF_FIFO_RDUSEWD[4];
assign q0_ln0_rx_fifo_aempty_o = Q0_LANE0_RX_IF_FIFO_AEMPTY;
assign q0_ln0_rx_fifo_empty_o = Q0_LANE0_RX_IF_FIFO_EMPTY;
assign q0_ln0_rx_valid_o = Q0_FABRIC_LN0_RX_VLD_OUT;
assign q0_ln0_tx_pcs_clkout_o = Q0_LANE0_PCS_TX_O_FABRIC_CLK;
assign q0_ln0_tx_fifo_wrusewd_o[0] = Q0_LANE0_TX_IF_FIFO_WRUSEWD[0];
assign q0_ln0_tx_fifo_wrusewd_o[1] = Q0_LANE0_TX_IF_FIFO_WRUSEWD[1];
assign q0_ln0_tx_fifo_wrusewd_o[2] = Q0_LANE0_TX_IF_FIFO_WRUSEWD[2];
assign q0_ln0_tx_fifo_wrusewd_o[3] = Q0_LANE0_TX_IF_FIFO_WRUSEWD[3];
assign q0_ln0_tx_fifo_wrusewd_o[4] = Q0_LANE0_TX_IF_FIFO_WRUSEWD[4];
assign q0_ln0_tx_fifo_afull_o = Q0_LANE0_TX_IF_FIFO_AFULL;
assign q0_ln0_tx_fifo_full_o = Q0_LANE0_TX_IF_FIFO_FULL;
assign q0_ln0_ready_o = Q0_FABRIC_LN0_STAT_O[12];
assign q0_ln0_refclk_o = Q0_FABRIC_CMU_CK_REF_O;
assign q0_ln0_signal_detect_o = Q0_FABRIC_LN0_ASTAT_O[5];
assign q0_ln0_rx_cdr_lock_o = Q0_FABRIC_LN0_PMA_RX_LOCK_O;
assign q0_ln0_pll_lock_o = Q0_FABRIC_CMU_OK_O;
assign Q0_LANE1_FABRIC_RX_CLK = q0_ln1_rx_clk_i;
assign Q0_LANE1_RX_IF_FIFO_RDEN = q0_ln1_rx_fifo_rden_i;
assign Q0_LANE1_FABRIC_TX_CLK = q0_ln1_tx_clk_i;
assign Q0_FABRIC_LN1_TXDATA_I[0] = q0_ln1_tx_data_i[0];
assign Q0_FABRIC_LN1_TXDATA_I[1] = q0_ln1_tx_data_i[1];
assign Q0_FABRIC_LN1_TXDATA_I[2] = q0_ln1_tx_data_i[2];
assign Q0_FABRIC_LN1_TXDATA_I[3] = q0_ln1_tx_data_i[3];
assign Q0_FABRIC_LN1_TXDATA_I[4] = q0_ln1_tx_data_i[4];
assign Q0_FABRIC_LN1_TXDATA_I[5] = q0_ln1_tx_data_i[5];
assign Q0_FABRIC_LN1_TXDATA_I[6] = q0_ln1_tx_data_i[6];
assign Q0_FABRIC_LN1_TXDATA_I[7] = q0_ln1_tx_data_i[7];
assign Q0_FABRIC_LN1_TXDATA_I[8] = q0_ln1_tx_data_i[8];
assign Q0_FABRIC_LN1_TXDATA_I[9] = q0_ln1_tx_data_i[9];
assign Q0_FABRIC_LN1_TXDATA_I[10] = q0_ln1_tx_data_i[10];
assign Q0_FABRIC_LN1_TXDATA_I[11] = q0_ln1_tx_data_i[11];
assign Q0_FABRIC_LN1_TXDATA_I[12] = q0_ln1_tx_data_i[12];
assign Q0_FABRIC_LN1_TXDATA_I[13] = q0_ln1_tx_data_i[13];
assign Q0_FABRIC_LN1_TXDATA_I[14] = q0_ln1_tx_data_i[14];
assign Q0_FABRIC_LN1_TXDATA_I[15] = q0_ln1_tx_data_i[15];
assign Q0_FABRIC_LN1_TXDATA_I[16] = q0_ln1_tx_data_i[16];
assign Q0_FABRIC_LN1_TXDATA_I[17] = q0_ln1_tx_data_i[17];
assign Q0_FABRIC_LN1_TXDATA_I[18] = q0_ln1_tx_data_i[18];
assign Q0_FABRIC_LN1_TXDATA_I[19] = q0_ln1_tx_data_i[19];
assign Q0_FABRIC_LN1_TXDATA_I[20] = q0_ln1_tx_data_i[20];
assign Q0_FABRIC_LN1_TXDATA_I[21] = q0_ln1_tx_data_i[21];
assign Q0_FABRIC_LN1_TXDATA_I[22] = q0_ln1_tx_data_i[22];
assign Q0_FABRIC_LN1_TXDATA_I[23] = q0_ln1_tx_data_i[23];
assign Q0_FABRIC_LN1_TXDATA_I[24] = q0_ln1_tx_data_i[24];
assign Q0_FABRIC_LN1_TXDATA_I[25] = q0_ln1_tx_data_i[25];
assign Q0_FABRIC_LN1_TXDATA_I[26] = q0_ln1_tx_data_i[26];
assign Q0_FABRIC_LN1_TXDATA_I[27] = q0_ln1_tx_data_i[27];
assign Q0_FABRIC_LN1_TXDATA_I[28] = q0_ln1_tx_data_i[28];
assign Q0_FABRIC_LN1_TXDATA_I[29] = q0_ln1_tx_data_i[29];
assign Q0_FABRIC_LN1_TXDATA_I[30] = q0_ln1_tx_data_i[30];
assign Q0_FABRIC_LN1_TXDATA_I[31] = q0_ln1_tx_data_i[31];
assign Q0_FABRIC_LN1_TXDATA_I[32] = q0_ln1_tx_data_i[32];
assign Q0_FABRIC_LN1_TXDATA_I[33] = q0_ln1_tx_data_i[33];
assign Q0_FABRIC_LN1_TXDATA_I[34] = q0_ln1_tx_data_i[34];
assign Q0_FABRIC_LN1_TXDATA_I[35] = q0_ln1_tx_data_i[35];
assign Q0_FABRIC_LN1_TXDATA_I[36] = q0_ln1_tx_data_i[36];
assign Q0_FABRIC_LN1_TXDATA_I[37] = q0_ln1_tx_data_i[37];
assign Q0_FABRIC_LN1_TXDATA_I[38] = q0_ln1_tx_data_i[38];
assign Q0_FABRIC_LN1_TXDATA_I[39] = q0_ln1_tx_data_i[39];
assign Q0_FABRIC_LN1_TXDATA_I[40] = q0_ln1_tx_data_i[40];
assign Q0_FABRIC_LN1_TXDATA_I[41] = q0_ln1_tx_data_i[41];
assign Q0_FABRIC_LN1_TXDATA_I[42] = q0_ln1_tx_data_i[42];
assign Q0_FABRIC_LN1_TXDATA_I[43] = q0_ln1_tx_data_i[43];
assign Q0_FABRIC_LN1_TXDATA_I[44] = q0_ln1_tx_data_i[44];
assign Q0_FABRIC_LN1_TXDATA_I[45] = q0_ln1_tx_data_i[45];
assign Q0_FABRIC_LN1_TXDATA_I[46] = q0_ln1_tx_data_i[46];
assign Q0_FABRIC_LN1_TXDATA_I[47] = q0_ln1_tx_data_i[47];
assign Q0_FABRIC_LN1_TXDATA_I[48] = q0_ln1_tx_data_i[48];
assign Q0_FABRIC_LN1_TXDATA_I[49] = q0_ln1_tx_data_i[49];
assign Q0_FABRIC_LN1_TXDATA_I[50] = q0_ln1_tx_data_i[50];
assign Q0_FABRIC_LN1_TXDATA_I[51] = q0_ln1_tx_data_i[51];
assign Q0_FABRIC_LN1_TXDATA_I[52] = q0_ln1_tx_data_i[52];
assign Q0_FABRIC_LN1_TXDATA_I[53] = q0_ln1_tx_data_i[53];
assign Q0_FABRIC_LN1_TXDATA_I[54] = q0_ln1_tx_data_i[54];
assign Q0_FABRIC_LN1_TXDATA_I[55] = q0_ln1_tx_data_i[55];
assign Q0_FABRIC_LN1_TXDATA_I[56] = q0_ln1_tx_data_i[56];
assign Q0_FABRIC_LN1_TXDATA_I[57] = q0_ln1_tx_data_i[57];
assign Q0_FABRIC_LN1_TXDATA_I[58] = q0_ln1_tx_data_i[58];
assign Q0_FABRIC_LN1_TXDATA_I[59] = q0_ln1_tx_data_i[59];
assign Q0_FABRIC_LN1_TXDATA_I[60] = q0_ln1_tx_data_i[60];
assign Q0_FABRIC_LN1_TXDATA_I[61] = q0_ln1_tx_data_i[61];
assign Q0_FABRIC_LN1_TXDATA_I[62] = q0_ln1_tx_data_i[62];
assign Q0_FABRIC_LN1_TXDATA_I[63] = q0_ln1_tx_data_i[63];
assign Q0_FABRIC_LN1_TXDATA_I[64] = q0_ln1_tx_data_i[64];
assign Q0_FABRIC_LN1_TXDATA_I[65] = q0_ln1_tx_data_i[65];
assign Q0_FABRIC_LN1_TXDATA_I[66] = q0_ln1_tx_data_i[66];
assign Q0_FABRIC_LN1_TXDATA_I[67] = q0_ln1_tx_data_i[67];
assign Q0_FABRIC_LN1_TXDATA_I[68] = q0_ln1_tx_data_i[68];
assign Q0_FABRIC_LN1_TXDATA_I[69] = q0_ln1_tx_data_i[69];
assign Q0_FABRIC_LN1_TXDATA_I[70] = q0_ln1_tx_data_i[70];
assign Q0_FABRIC_LN1_TXDATA_I[71] = q0_ln1_tx_data_i[71];
assign Q0_FABRIC_LN1_TXDATA_I[72] = q0_ln1_tx_data_i[72];
assign Q0_FABRIC_LN1_TXDATA_I[73] = q0_ln1_tx_data_i[73];
assign Q0_FABRIC_LN1_TXDATA_I[74] = q0_ln1_tx_data_i[74];
assign Q0_FABRIC_LN1_TXDATA_I[75] = q0_ln1_tx_data_i[75];
assign Q0_FABRIC_LN1_TXDATA_I[76] = q0_ln1_tx_data_i[76];
assign Q0_FABRIC_LN1_TXDATA_I[77] = q0_ln1_tx_data_i[77];
assign Q0_FABRIC_LN1_TXDATA_I[78] = q0_ln1_tx_data_i[78];
assign Q0_FABRIC_LN1_TXDATA_I[79] = q0_ln1_tx_data_i[79];
assign Q0_FABRIC_LN1_TX_VLD_IN = q0_ln1_tx_fifo_wren_i;
assign Q0_LANE1_FABRIC_C2I_CLK = GND;
assign Q0_LANE1_CHBOND_START = GND;
assign Q0_FABRIC_LN1_RSTN_I = q0_ln1_pma_rstn_i;
assign Q0_LANE1_PCS_RX_RST = q0_ln1_pcs_rx_rst_i;
assign Q0_LANE1_PCS_TX_RST = q0_ln1_pcs_tx_rst_i;
assign q0_ln1_rx_pcs_clkout_o = Q0_LANE1_PCS_RX_O_FABRIC_CLK;
assign q0_ln1_rx_data_o[0] = Q0_FABRIC_LN1_RXDATA_O[0];
assign q0_ln1_rx_data_o[1] = Q0_FABRIC_LN1_RXDATA_O[1];
assign q0_ln1_rx_data_o[2] = Q0_FABRIC_LN1_RXDATA_O[2];
assign q0_ln1_rx_data_o[3] = Q0_FABRIC_LN1_RXDATA_O[3];
assign q0_ln1_rx_data_o[4] = Q0_FABRIC_LN1_RXDATA_O[4];
assign q0_ln1_rx_data_o[5] = Q0_FABRIC_LN1_RXDATA_O[5];
assign q0_ln1_rx_data_o[6] = Q0_FABRIC_LN1_RXDATA_O[6];
assign q0_ln1_rx_data_o[7] = Q0_FABRIC_LN1_RXDATA_O[7];
assign q0_ln1_rx_data_o[8] = Q0_FABRIC_LN1_RXDATA_O[8];
assign q0_ln1_rx_data_o[9] = Q0_FABRIC_LN1_RXDATA_O[9];
assign q0_ln1_rx_data_o[10] = Q0_FABRIC_LN1_RXDATA_O[10];
assign q0_ln1_rx_data_o[11] = Q0_FABRIC_LN1_RXDATA_O[11];
assign q0_ln1_rx_data_o[12] = Q0_FABRIC_LN1_RXDATA_O[12];
assign q0_ln1_rx_data_o[13] = Q0_FABRIC_LN1_RXDATA_O[13];
assign q0_ln1_rx_data_o[14] = Q0_FABRIC_LN1_RXDATA_O[14];
assign q0_ln1_rx_data_o[15] = Q0_FABRIC_LN1_RXDATA_O[15];
assign q0_ln1_rx_data_o[16] = Q0_FABRIC_LN1_RXDATA_O[16];
assign q0_ln1_rx_data_o[17] = Q0_FABRIC_LN1_RXDATA_O[17];
assign q0_ln1_rx_data_o[18] = Q0_FABRIC_LN1_RXDATA_O[18];
assign q0_ln1_rx_data_o[19] = Q0_FABRIC_LN1_RXDATA_O[19];
assign q0_ln1_rx_data_o[20] = Q0_FABRIC_LN1_RXDATA_O[20];
assign q0_ln1_rx_data_o[21] = Q0_FABRIC_LN1_RXDATA_O[21];
assign q0_ln1_rx_data_o[22] = Q0_FABRIC_LN1_RXDATA_O[22];
assign q0_ln1_rx_data_o[23] = Q0_FABRIC_LN1_RXDATA_O[23];
assign q0_ln1_rx_data_o[24] = Q0_FABRIC_LN1_RXDATA_O[24];
assign q0_ln1_rx_data_o[25] = Q0_FABRIC_LN1_RXDATA_O[25];
assign q0_ln1_rx_data_o[26] = Q0_FABRIC_LN1_RXDATA_O[26];
assign q0_ln1_rx_data_o[27] = Q0_FABRIC_LN1_RXDATA_O[27];
assign q0_ln1_rx_data_o[28] = Q0_FABRIC_LN1_RXDATA_O[28];
assign q0_ln1_rx_data_o[29] = Q0_FABRIC_LN1_RXDATA_O[29];
assign q0_ln1_rx_data_o[30] = Q0_FABRIC_LN1_RXDATA_O[30];
assign q0_ln1_rx_data_o[31] = Q0_FABRIC_LN1_RXDATA_O[31];
assign q0_ln1_rx_data_o[32] = Q0_FABRIC_LN1_RXDATA_O[32];
assign q0_ln1_rx_data_o[33] = Q0_FABRIC_LN1_RXDATA_O[33];
assign q0_ln1_rx_data_o[34] = Q0_FABRIC_LN1_RXDATA_O[34];
assign q0_ln1_rx_data_o[35] = Q0_FABRIC_LN1_RXDATA_O[35];
assign q0_ln1_rx_data_o[36] = Q0_FABRIC_LN1_RXDATA_O[36];
assign q0_ln1_rx_data_o[37] = Q0_FABRIC_LN1_RXDATA_O[37];
assign q0_ln1_rx_data_o[38] = Q0_FABRIC_LN1_RXDATA_O[38];
assign q0_ln1_rx_data_o[39] = Q0_FABRIC_LN1_RXDATA_O[39];
assign q0_ln1_rx_data_o[40] = Q0_FABRIC_LN1_RXDATA_O[40];
assign q0_ln1_rx_data_o[41] = Q0_FABRIC_LN1_RXDATA_O[41];
assign q0_ln1_rx_data_o[42] = Q0_FABRIC_LN1_RXDATA_O[42];
assign q0_ln1_rx_data_o[43] = Q0_FABRIC_LN1_RXDATA_O[43];
assign q0_ln1_rx_data_o[44] = Q0_FABRIC_LN1_RXDATA_O[44];
assign q0_ln1_rx_data_o[45] = Q0_FABRIC_LN1_RXDATA_O[45];
assign q0_ln1_rx_data_o[46] = Q0_FABRIC_LN1_RXDATA_O[46];
assign q0_ln1_rx_data_o[47] = Q0_FABRIC_LN1_RXDATA_O[47];
assign q0_ln1_rx_data_o[48] = Q0_FABRIC_LN1_RXDATA_O[48];
assign q0_ln1_rx_data_o[49] = Q0_FABRIC_LN1_RXDATA_O[49];
assign q0_ln1_rx_data_o[50] = Q0_FABRIC_LN1_RXDATA_O[50];
assign q0_ln1_rx_data_o[51] = Q0_FABRIC_LN1_RXDATA_O[51];
assign q0_ln1_rx_data_o[52] = Q0_FABRIC_LN1_RXDATA_O[52];
assign q0_ln1_rx_data_o[53] = Q0_FABRIC_LN1_RXDATA_O[53];
assign q0_ln1_rx_data_o[54] = Q0_FABRIC_LN1_RXDATA_O[54];
assign q0_ln1_rx_data_o[55] = Q0_FABRIC_LN1_RXDATA_O[55];
assign q0_ln1_rx_data_o[56] = Q0_FABRIC_LN1_RXDATA_O[56];
assign q0_ln1_rx_data_o[57] = Q0_FABRIC_LN1_RXDATA_O[57];
assign q0_ln1_rx_data_o[58] = Q0_FABRIC_LN1_RXDATA_O[58];
assign q0_ln1_rx_data_o[59] = Q0_FABRIC_LN1_RXDATA_O[59];
assign q0_ln1_rx_data_o[60] = Q0_FABRIC_LN1_RXDATA_O[60];
assign q0_ln1_rx_data_o[61] = Q0_FABRIC_LN1_RXDATA_O[61];
assign q0_ln1_rx_data_o[62] = Q0_FABRIC_LN1_RXDATA_O[62];
assign q0_ln1_rx_data_o[63] = Q0_FABRIC_LN1_RXDATA_O[63];
assign q0_ln1_rx_data_o[64] = Q0_FABRIC_LN1_RXDATA_O[64];
assign q0_ln1_rx_data_o[65] = Q0_FABRIC_LN1_RXDATA_O[65];
assign q0_ln1_rx_data_o[66] = Q0_FABRIC_LN1_RXDATA_O[66];
assign q0_ln1_rx_data_o[67] = Q0_FABRIC_LN1_RXDATA_O[67];
assign q0_ln1_rx_data_o[68] = Q0_FABRIC_LN1_RXDATA_O[68];
assign q0_ln1_rx_data_o[69] = Q0_FABRIC_LN1_RXDATA_O[69];
assign q0_ln1_rx_data_o[70] = Q0_FABRIC_LN1_RXDATA_O[70];
assign q0_ln1_rx_data_o[71] = Q0_FABRIC_LN1_RXDATA_O[71];
assign q0_ln1_rx_data_o[72] = Q0_FABRIC_LN1_RXDATA_O[72];
assign q0_ln1_rx_data_o[73] = Q0_FABRIC_LN1_RXDATA_O[73];
assign q0_ln1_rx_data_o[74] = Q0_FABRIC_LN1_RXDATA_O[74];
assign q0_ln1_rx_data_o[75] = Q0_FABRIC_LN1_RXDATA_O[75];
assign q0_ln1_rx_data_o[76] = Q0_FABRIC_LN1_RXDATA_O[76];
assign q0_ln1_rx_data_o[77] = Q0_FABRIC_LN1_RXDATA_O[77];
assign q0_ln1_rx_data_o[78] = Q0_FABRIC_LN1_RXDATA_O[78];
assign q0_ln1_rx_data_o[79] = Q0_FABRIC_LN1_RXDATA_O[79];
assign q0_ln1_rx_data_o[80] = Q0_FABRIC_LN1_RXDATA_O[80];
assign q0_ln1_rx_data_o[81] = Q0_FABRIC_LN1_RXDATA_O[81];
assign q0_ln1_rx_data_o[82] = Q0_FABRIC_LN1_RXDATA_O[82];
assign q0_ln1_rx_data_o[83] = Q0_FABRIC_LN1_RXDATA_O[83];
assign q0_ln1_rx_data_o[84] = Q0_FABRIC_LN1_RXDATA_O[84];
assign q0_ln1_rx_data_o[85] = Q0_FABRIC_LN1_RXDATA_O[85];
assign q0_ln1_rx_data_o[86] = Q0_FABRIC_LN1_RXDATA_O[86];
assign q0_ln1_rx_data_o[87] = Q0_FABRIC_LN1_RXDATA_O[87];
assign q0_ln1_rx_fifo_rdusewd_o[0] = Q0_LANE1_RX_IF_FIFO_RDUSEWD[0];
assign q0_ln1_rx_fifo_rdusewd_o[1] = Q0_LANE1_RX_IF_FIFO_RDUSEWD[1];
assign q0_ln1_rx_fifo_rdusewd_o[2] = Q0_LANE1_RX_IF_FIFO_RDUSEWD[2];
assign q0_ln1_rx_fifo_rdusewd_o[3] = Q0_LANE1_RX_IF_FIFO_RDUSEWD[3];
assign q0_ln1_rx_fifo_rdusewd_o[4] = Q0_LANE1_RX_IF_FIFO_RDUSEWD[4];
assign q0_ln1_rx_fifo_aempty_o = Q0_LANE1_RX_IF_FIFO_AEMPTY;
assign q0_ln1_rx_fifo_empty_o = Q0_LANE1_RX_IF_FIFO_EMPTY;
assign q0_ln1_rx_valid_o = Q0_FABRIC_LN1_RX_VLD_OUT;
assign q0_ln1_tx_pcs_clkout_o = Q0_LANE1_PCS_TX_O_FABRIC_CLK;
assign q0_ln1_tx_fifo_wrusewd_o[0] = Q0_LANE1_TX_IF_FIFO_WRUSEWD[0];
assign q0_ln1_tx_fifo_wrusewd_o[1] = Q0_LANE1_TX_IF_FIFO_WRUSEWD[1];
assign q0_ln1_tx_fifo_wrusewd_o[2] = Q0_LANE1_TX_IF_FIFO_WRUSEWD[2];
assign q0_ln1_tx_fifo_wrusewd_o[3] = Q0_LANE1_TX_IF_FIFO_WRUSEWD[3];
assign q0_ln1_tx_fifo_wrusewd_o[4] = Q0_LANE1_TX_IF_FIFO_WRUSEWD[4];
assign q0_ln1_tx_fifo_afull_o = Q0_LANE1_TX_IF_FIFO_AFULL;
assign q0_ln1_tx_fifo_full_o = Q0_LANE1_TX_IF_FIFO_FULL;
assign q0_ln1_ready_o = Q0_FABRIC_LN1_STAT_O[12];
assign q0_ln1_refclk_o = Q0_FABRIC_CMU_CK_REF_O;
assign q0_ln1_signal_detect_o = Q0_FABRIC_LN1_ASTAT_O[5];
assign q0_ln1_rx_cdr_lock_o = Q0_FABRIC_LN1_PMA_RX_LOCK_O;
assign q0_ln1_pll_lock_o = Q0_FABRIC_CMU_OK_O;
assign Q0_LANE2_FABRIC_RX_CLK = q0_ln2_rx_clk_i;
assign Q0_LANE2_RX_IF_FIFO_RDEN = q0_ln2_rx_fifo_rden_i;
assign Q0_LANE2_FABRIC_TX_CLK = q0_ln2_tx_clk_i;
assign Q0_FABRIC_LN2_TXDATA_I[0] = q0_ln2_tx_data_i[0];
assign Q0_FABRIC_LN2_TXDATA_I[1] = q0_ln2_tx_data_i[1];
assign Q0_FABRIC_LN2_TXDATA_I[2] = q0_ln2_tx_data_i[2];
assign Q0_FABRIC_LN2_TXDATA_I[3] = q0_ln2_tx_data_i[3];
assign Q0_FABRIC_LN2_TXDATA_I[4] = q0_ln2_tx_data_i[4];
assign Q0_FABRIC_LN2_TXDATA_I[5] = q0_ln2_tx_data_i[5];
assign Q0_FABRIC_LN2_TXDATA_I[6] = q0_ln2_tx_data_i[6];
assign Q0_FABRIC_LN2_TXDATA_I[7] = q0_ln2_tx_data_i[7];
assign Q0_FABRIC_LN2_TXDATA_I[8] = q0_ln2_tx_data_i[8];
assign Q0_FABRIC_LN2_TXDATA_I[9] = q0_ln2_tx_data_i[9];
assign Q0_FABRIC_LN2_TXDATA_I[10] = q0_ln2_tx_data_i[10];
assign Q0_FABRIC_LN2_TXDATA_I[11] = q0_ln2_tx_data_i[11];
assign Q0_FABRIC_LN2_TXDATA_I[12] = q0_ln2_tx_data_i[12];
assign Q0_FABRIC_LN2_TXDATA_I[13] = q0_ln2_tx_data_i[13];
assign Q0_FABRIC_LN2_TXDATA_I[14] = q0_ln2_tx_data_i[14];
assign Q0_FABRIC_LN2_TXDATA_I[15] = q0_ln2_tx_data_i[15];
assign Q0_FABRIC_LN2_TXDATA_I[16] = q0_ln2_tx_data_i[16];
assign Q0_FABRIC_LN2_TXDATA_I[17] = q0_ln2_tx_data_i[17];
assign Q0_FABRIC_LN2_TXDATA_I[18] = q0_ln2_tx_data_i[18];
assign Q0_FABRIC_LN2_TXDATA_I[19] = q0_ln2_tx_data_i[19];
assign Q0_FABRIC_LN2_TXDATA_I[20] = q0_ln2_tx_data_i[20];
assign Q0_FABRIC_LN2_TXDATA_I[21] = q0_ln2_tx_data_i[21];
assign Q0_FABRIC_LN2_TXDATA_I[22] = q0_ln2_tx_data_i[22];
assign Q0_FABRIC_LN2_TXDATA_I[23] = q0_ln2_tx_data_i[23];
assign Q0_FABRIC_LN2_TXDATA_I[24] = q0_ln2_tx_data_i[24];
assign Q0_FABRIC_LN2_TXDATA_I[25] = q0_ln2_tx_data_i[25];
assign Q0_FABRIC_LN2_TXDATA_I[26] = q0_ln2_tx_data_i[26];
assign Q0_FABRIC_LN2_TXDATA_I[27] = q0_ln2_tx_data_i[27];
assign Q0_FABRIC_LN2_TXDATA_I[28] = q0_ln2_tx_data_i[28];
assign Q0_FABRIC_LN2_TXDATA_I[29] = q0_ln2_tx_data_i[29];
assign Q0_FABRIC_LN2_TXDATA_I[30] = q0_ln2_tx_data_i[30];
assign Q0_FABRIC_LN2_TXDATA_I[31] = q0_ln2_tx_data_i[31];
assign Q0_FABRIC_LN2_TXDATA_I[32] = q0_ln2_tx_data_i[32];
assign Q0_FABRIC_LN2_TXDATA_I[33] = q0_ln2_tx_data_i[33];
assign Q0_FABRIC_LN2_TXDATA_I[34] = q0_ln2_tx_data_i[34];
assign Q0_FABRIC_LN2_TXDATA_I[35] = q0_ln2_tx_data_i[35];
assign Q0_FABRIC_LN2_TXDATA_I[36] = q0_ln2_tx_data_i[36];
assign Q0_FABRIC_LN2_TXDATA_I[37] = q0_ln2_tx_data_i[37];
assign Q0_FABRIC_LN2_TXDATA_I[38] = q0_ln2_tx_data_i[38];
assign Q0_FABRIC_LN2_TXDATA_I[39] = q0_ln2_tx_data_i[39];
assign Q0_FABRIC_LN2_TXDATA_I[40] = q0_ln2_tx_data_i[40];
assign Q0_FABRIC_LN2_TXDATA_I[41] = q0_ln2_tx_data_i[41];
assign Q0_FABRIC_LN2_TXDATA_I[42] = q0_ln2_tx_data_i[42];
assign Q0_FABRIC_LN2_TXDATA_I[43] = q0_ln2_tx_data_i[43];
assign Q0_FABRIC_LN2_TXDATA_I[44] = q0_ln2_tx_data_i[44];
assign Q0_FABRIC_LN2_TXDATA_I[45] = q0_ln2_tx_data_i[45];
assign Q0_FABRIC_LN2_TXDATA_I[46] = q0_ln2_tx_data_i[46];
assign Q0_FABRIC_LN2_TXDATA_I[47] = q0_ln2_tx_data_i[47];
assign Q0_FABRIC_LN2_TXDATA_I[48] = q0_ln2_tx_data_i[48];
assign Q0_FABRIC_LN2_TXDATA_I[49] = q0_ln2_tx_data_i[49];
assign Q0_FABRIC_LN2_TXDATA_I[50] = q0_ln2_tx_data_i[50];
assign Q0_FABRIC_LN2_TXDATA_I[51] = q0_ln2_tx_data_i[51];
assign Q0_FABRIC_LN2_TXDATA_I[52] = q0_ln2_tx_data_i[52];
assign Q0_FABRIC_LN2_TXDATA_I[53] = q0_ln2_tx_data_i[53];
assign Q0_FABRIC_LN2_TXDATA_I[54] = q0_ln2_tx_data_i[54];
assign Q0_FABRIC_LN2_TXDATA_I[55] = q0_ln2_tx_data_i[55];
assign Q0_FABRIC_LN2_TXDATA_I[56] = q0_ln2_tx_data_i[56];
assign Q0_FABRIC_LN2_TXDATA_I[57] = q0_ln2_tx_data_i[57];
assign Q0_FABRIC_LN2_TXDATA_I[58] = q0_ln2_tx_data_i[58];
assign Q0_FABRIC_LN2_TXDATA_I[59] = q0_ln2_tx_data_i[59];
assign Q0_FABRIC_LN2_TXDATA_I[60] = q0_ln2_tx_data_i[60];
assign Q0_FABRIC_LN2_TXDATA_I[61] = q0_ln2_tx_data_i[61];
assign Q0_FABRIC_LN2_TXDATA_I[62] = q0_ln2_tx_data_i[62];
assign Q0_FABRIC_LN2_TXDATA_I[63] = q0_ln2_tx_data_i[63];
assign Q0_FABRIC_LN2_TXDATA_I[64] = q0_ln2_tx_data_i[64];
assign Q0_FABRIC_LN2_TXDATA_I[65] = q0_ln2_tx_data_i[65];
assign Q0_FABRIC_LN2_TXDATA_I[66] = q0_ln2_tx_data_i[66];
assign Q0_FABRIC_LN2_TXDATA_I[67] = q0_ln2_tx_data_i[67];
assign Q0_FABRIC_LN2_TXDATA_I[68] = q0_ln2_tx_data_i[68];
assign Q0_FABRIC_LN2_TXDATA_I[69] = q0_ln2_tx_data_i[69];
assign Q0_FABRIC_LN2_TXDATA_I[70] = q0_ln2_tx_data_i[70];
assign Q0_FABRIC_LN2_TXDATA_I[71] = q0_ln2_tx_data_i[71];
assign Q0_FABRIC_LN2_TXDATA_I[72] = q0_ln2_tx_data_i[72];
assign Q0_FABRIC_LN2_TXDATA_I[73] = q0_ln2_tx_data_i[73];
assign Q0_FABRIC_LN2_TXDATA_I[74] = q0_ln2_tx_data_i[74];
assign Q0_FABRIC_LN2_TXDATA_I[75] = q0_ln2_tx_data_i[75];
assign Q0_FABRIC_LN2_TXDATA_I[76] = q0_ln2_tx_data_i[76];
assign Q0_FABRIC_LN2_TXDATA_I[77] = q0_ln2_tx_data_i[77];
assign Q0_FABRIC_LN2_TXDATA_I[78] = q0_ln2_tx_data_i[78];
assign Q0_FABRIC_LN2_TXDATA_I[79] = q0_ln2_tx_data_i[79];
assign Q0_FABRIC_LN2_TX_VLD_IN = q0_ln2_tx_fifo_wren_i;
assign Q0_LANE2_FABRIC_C2I_CLK = GND;
assign Q0_LANE2_CHBOND_START = GND;
assign Q0_FABRIC_LN2_RSTN_I = q0_ln2_pma_rstn_i;
assign Q0_LANE2_PCS_RX_RST = q0_ln2_pcs_rx_rst_i;
assign Q0_LANE2_PCS_TX_RST = q0_ln2_pcs_tx_rst_i;
assign q0_ln2_rx_pcs_clkout_o = Q0_LANE2_PCS_RX_O_FABRIC_CLK;
assign q0_ln2_rx_data_o[0] = Q0_FABRIC_LN2_RXDATA_O[0];
assign q0_ln2_rx_data_o[1] = Q0_FABRIC_LN2_RXDATA_O[1];
assign q0_ln2_rx_data_o[2] = Q0_FABRIC_LN2_RXDATA_O[2];
assign q0_ln2_rx_data_o[3] = Q0_FABRIC_LN2_RXDATA_O[3];
assign q0_ln2_rx_data_o[4] = Q0_FABRIC_LN2_RXDATA_O[4];
assign q0_ln2_rx_data_o[5] = Q0_FABRIC_LN2_RXDATA_O[5];
assign q0_ln2_rx_data_o[6] = Q0_FABRIC_LN2_RXDATA_O[6];
assign q0_ln2_rx_data_o[7] = Q0_FABRIC_LN2_RXDATA_O[7];
assign q0_ln2_rx_data_o[8] = Q0_FABRIC_LN2_RXDATA_O[8];
assign q0_ln2_rx_data_o[9] = Q0_FABRIC_LN2_RXDATA_O[9];
assign q0_ln2_rx_data_o[10] = Q0_FABRIC_LN2_RXDATA_O[10];
assign q0_ln2_rx_data_o[11] = Q0_FABRIC_LN2_RXDATA_O[11];
assign q0_ln2_rx_data_o[12] = Q0_FABRIC_LN2_RXDATA_O[12];
assign q0_ln2_rx_data_o[13] = Q0_FABRIC_LN2_RXDATA_O[13];
assign q0_ln2_rx_data_o[14] = Q0_FABRIC_LN2_RXDATA_O[14];
assign q0_ln2_rx_data_o[15] = Q0_FABRIC_LN2_RXDATA_O[15];
assign q0_ln2_rx_data_o[16] = Q0_FABRIC_LN2_RXDATA_O[16];
assign q0_ln2_rx_data_o[17] = Q0_FABRIC_LN2_RXDATA_O[17];
assign q0_ln2_rx_data_o[18] = Q0_FABRIC_LN2_RXDATA_O[18];
assign q0_ln2_rx_data_o[19] = Q0_FABRIC_LN2_RXDATA_O[19];
assign q0_ln2_rx_data_o[20] = Q0_FABRIC_LN2_RXDATA_O[20];
assign q0_ln2_rx_data_o[21] = Q0_FABRIC_LN2_RXDATA_O[21];
assign q0_ln2_rx_data_o[22] = Q0_FABRIC_LN2_RXDATA_O[22];
assign q0_ln2_rx_data_o[23] = Q0_FABRIC_LN2_RXDATA_O[23];
assign q0_ln2_rx_data_o[24] = Q0_FABRIC_LN2_RXDATA_O[24];
assign q0_ln2_rx_data_o[25] = Q0_FABRIC_LN2_RXDATA_O[25];
assign q0_ln2_rx_data_o[26] = Q0_FABRIC_LN2_RXDATA_O[26];
assign q0_ln2_rx_data_o[27] = Q0_FABRIC_LN2_RXDATA_O[27];
assign q0_ln2_rx_data_o[28] = Q0_FABRIC_LN2_RXDATA_O[28];
assign q0_ln2_rx_data_o[29] = Q0_FABRIC_LN2_RXDATA_O[29];
assign q0_ln2_rx_data_o[30] = Q0_FABRIC_LN2_RXDATA_O[30];
assign q0_ln2_rx_data_o[31] = Q0_FABRIC_LN2_RXDATA_O[31];
assign q0_ln2_rx_data_o[32] = Q0_FABRIC_LN2_RXDATA_O[32];
assign q0_ln2_rx_data_o[33] = Q0_FABRIC_LN2_RXDATA_O[33];
assign q0_ln2_rx_data_o[34] = Q0_FABRIC_LN2_RXDATA_O[34];
assign q0_ln2_rx_data_o[35] = Q0_FABRIC_LN2_RXDATA_O[35];
assign q0_ln2_rx_data_o[36] = Q0_FABRIC_LN2_RXDATA_O[36];
assign q0_ln2_rx_data_o[37] = Q0_FABRIC_LN2_RXDATA_O[37];
assign q0_ln2_rx_data_o[38] = Q0_FABRIC_LN2_RXDATA_O[38];
assign q0_ln2_rx_data_o[39] = Q0_FABRIC_LN2_RXDATA_O[39];
assign q0_ln2_rx_data_o[40] = Q0_FABRIC_LN2_RXDATA_O[40];
assign q0_ln2_rx_data_o[41] = Q0_FABRIC_LN2_RXDATA_O[41];
assign q0_ln2_rx_data_o[42] = Q0_FABRIC_LN2_RXDATA_O[42];
assign q0_ln2_rx_data_o[43] = Q0_FABRIC_LN2_RXDATA_O[43];
assign q0_ln2_rx_data_o[44] = Q0_FABRIC_LN2_RXDATA_O[44];
assign q0_ln2_rx_data_o[45] = Q0_FABRIC_LN2_RXDATA_O[45];
assign q0_ln2_rx_data_o[46] = Q0_FABRIC_LN2_RXDATA_O[46];
assign q0_ln2_rx_data_o[47] = Q0_FABRIC_LN2_RXDATA_O[47];
assign q0_ln2_rx_data_o[48] = Q0_FABRIC_LN2_RXDATA_O[48];
assign q0_ln2_rx_data_o[49] = Q0_FABRIC_LN2_RXDATA_O[49];
assign q0_ln2_rx_data_o[50] = Q0_FABRIC_LN2_RXDATA_O[50];
assign q0_ln2_rx_data_o[51] = Q0_FABRIC_LN2_RXDATA_O[51];
assign q0_ln2_rx_data_o[52] = Q0_FABRIC_LN2_RXDATA_O[52];
assign q0_ln2_rx_data_o[53] = Q0_FABRIC_LN2_RXDATA_O[53];
assign q0_ln2_rx_data_o[54] = Q0_FABRIC_LN2_RXDATA_O[54];
assign q0_ln2_rx_data_o[55] = Q0_FABRIC_LN2_RXDATA_O[55];
assign q0_ln2_rx_data_o[56] = Q0_FABRIC_LN2_RXDATA_O[56];
assign q0_ln2_rx_data_o[57] = Q0_FABRIC_LN2_RXDATA_O[57];
assign q0_ln2_rx_data_o[58] = Q0_FABRIC_LN2_RXDATA_O[58];
assign q0_ln2_rx_data_o[59] = Q0_FABRIC_LN2_RXDATA_O[59];
assign q0_ln2_rx_data_o[60] = Q0_FABRIC_LN2_RXDATA_O[60];
assign q0_ln2_rx_data_o[61] = Q0_FABRIC_LN2_RXDATA_O[61];
assign q0_ln2_rx_data_o[62] = Q0_FABRIC_LN2_RXDATA_O[62];
assign q0_ln2_rx_data_o[63] = Q0_FABRIC_LN2_RXDATA_O[63];
assign q0_ln2_rx_data_o[64] = Q0_FABRIC_LN2_RXDATA_O[64];
assign q0_ln2_rx_data_o[65] = Q0_FABRIC_LN2_RXDATA_O[65];
assign q0_ln2_rx_data_o[66] = Q0_FABRIC_LN2_RXDATA_O[66];
assign q0_ln2_rx_data_o[67] = Q0_FABRIC_LN2_RXDATA_O[67];
assign q0_ln2_rx_data_o[68] = Q0_FABRIC_LN2_RXDATA_O[68];
assign q0_ln2_rx_data_o[69] = Q0_FABRIC_LN2_RXDATA_O[69];
assign q0_ln2_rx_data_o[70] = Q0_FABRIC_LN2_RXDATA_O[70];
assign q0_ln2_rx_data_o[71] = Q0_FABRIC_LN2_RXDATA_O[71];
assign q0_ln2_rx_data_o[72] = Q0_FABRIC_LN2_RXDATA_O[72];
assign q0_ln2_rx_data_o[73] = Q0_FABRIC_LN2_RXDATA_O[73];
assign q0_ln2_rx_data_o[74] = Q0_FABRIC_LN2_RXDATA_O[74];
assign q0_ln2_rx_data_o[75] = Q0_FABRIC_LN2_RXDATA_O[75];
assign q0_ln2_rx_data_o[76] = Q0_FABRIC_LN2_RXDATA_O[76];
assign q0_ln2_rx_data_o[77] = Q0_FABRIC_LN2_RXDATA_O[77];
assign q0_ln2_rx_data_o[78] = Q0_FABRIC_LN2_RXDATA_O[78];
assign q0_ln2_rx_data_o[79] = Q0_FABRIC_LN2_RXDATA_O[79];
assign q0_ln2_rx_data_o[80] = Q0_FABRIC_LN2_RXDATA_O[80];
assign q0_ln2_rx_data_o[81] = Q0_FABRIC_LN2_RXDATA_O[81];
assign q0_ln2_rx_data_o[82] = Q0_FABRIC_LN2_RXDATA_O[82];
assign q0_ln2_rx_data_o[83] = Q0_FABRIC_LN2_RXDATA_O[83];
assign q0_ln2_rx_data_o[84] = Q0_FABRIC_LN2_RXDATA_O[84];
assign q0_ln2_rx_data_o[85] = Q0_FABRIC_LN2_RXDATA_O[85];
assign q0_ln2_rx_data_o[86] = Q0_FABRIC_LN2_RXDATA_O[86];
assign q0_ln2_rx_data_o[87] = Q0_FABRIC_LN2_RXDATA_O[87];
assign q0_ln2_rx_fifo_rdusewd_o[0] = Q0_LANE2_RX_IF_FIFO_RDUSEWD[0];
assign q0_ln2_rx_fifo_rdusewd_o[1] = Q0_LANE2_RX_IF_FIFO_RDUSEWD[1];
assign q0_ln2_rx_fifo_rdusewd_o[2] = Q0_LANE2_RX_IF_FIFO_RDUSEWD[2];
assign q0_ln2_rx_fifo_rdusewd_o[3] = Q0_LANE2_RX_IF_FIFO_RDUSEWD[3];
assign q0_ln2_rx_fifo_rdusewd_o[4] = Q0_LANE2_RX_IF_FIFO_RDUSEWD[4];
assign q0_ln2_rx_fifo_aempty_o = Q0_LANE2_RX_IF_FIFO_AEMPTY;
assign q0_ln2_rx_fifo_empty_o = Q0_LANE2_RX_IF_FIFO_EMPTY;
assign q0_ln2_rx_valid_o = Q0_FABRIC_LN2_RX_VLD_OUT;
assign q0_ln2_tx_pcs_clkout_o = Q0_LANE2_PCS_TX_O_FABRIC_CLK;
assign q0_ln2_tx_fifo_wrusewd_o[0] = Q0_LANE2_TX_IF_FIFO_WRUSEWD[0];
assign q0_ln2_tx_fifo_wrusewd_o[1] = Q0_LANE2_TX_IF_FIFO_WRUSEWD[1];
assign q0_ln2_tx_fifo_wrusewd_o[2] = Q0_LANE2_TX_IF_FIFO_WRUSEWD[2];
assign q0_ln2_tx_fifo_wrusewd_o[3] = Q0_LANE2_TX_IF_FIFO_WRUSEWD[3];
assign q0_ln2_tx_fifo_wrusewd_o[4] = Q0_LANE2_TX_IF_FIFO_WRUSEWD[4];
assign q0_ln2_tx_fifo_afull_o = Q0_LANE2_TX_IF_FIFO_AFULL;
assign q0_ln2_tx_fifo_full_o = Q0_LANE2_TX_IF_FIFO_FULL;
assign q0_ln2_ready_o = Q0_FABRIC_LN2_STAT_O[12];
assign q0_ln2_refclk_o = Q0_FABRIC_CMU_CK_REF_O;
assign q0_ln2_signal_detect_o = Q0_FABRIC_LN2_ASTAT_O[5];
assign q0_ln2_rx_cdr_lock_o = Q0_FABRIC_LN2_PMA_RX_LOCK_O;
assign q0_ln2_pll_lock_o = Q0_FABRIC_CMU_OK_O;
assign Q0_LANE3_FABRIC_RX_CLK = q0_ln3_rx_clk_i;
assign Q0_LANE3_RX_IF_FIFO_RDEN = q0_ln3_rx_fifo_rden_i;
assign Q0_LANE3_FABRIC_TX_CLK = q0_ln3_tx_clk_i;
assign Q0_FABRIC_LN3_TXDATA_I[0] = q0_ln3_tx_data_i[0];
assign Q0_FABRIC_LN3_TXDATA_I[1] = q0_ln3_tx_data_i[1];
assign Q0_FABRIC_LN3_TXDATA_I[2] = q0_ln3_tx_data_i[2];
assign Q0_FABRIC_LN3_TXDATA_I[3] = q0_ln3_tx_data_i[3];
assign Q0_FABRIC_LN3_TXDATA_I[4] = q0_ln3_tx_data_i[4];
assign Q0_FABRIC_LN3_TXDATA_I[5] = q0_ln3_tx_data_i[5];
assign Q0_FABRIC_LN3_TXDATA_I[6] = q0_ln3_tx_data_i[6];
assign Q0_FABRIC_LN3_TXDATA_I[7] = q0_ln3_tx_data_i[7];
assign Q0_FABRIC_LN3_TXDATA_I[8] = q0_ln3_tx_data_i[8];
assign Q0_FABRIC_LN3_TXDATA_I[9] = q0_ln3_tx_data_i[9];
assign Q0_FABRIC_LN3_TXDATA_I[10] = q0_ln3_tx_data_i[10];
assign Q0_FABRIC_LN3_TXDATA_I[11] = q0_ln3_tx_data_i[11];
assign Q0_FABRIC_LN3_TXDATA_I[12] = q0_ln3_tx_data_i[12];
assign Q0_FABRIC_LN3_TXDATA_I[13] = q0_ln3_tx_data_i[13];
assign Q0_FABRIC_LN3_TXDATA_I[14] = q0_ln3_tx_data_i[14];
assign Q0_FABRIC_LN3_TXDATA_I[15] = q0_ln3_tx_data_i[15];
assign Q0_FABRIC_LN3_TXDATA_I[16] = q0_ln3_tx_data_i[16];
assign Q0_FABRIC_LN3_TXDATA_I[17] = q0_ln3_tx_data_i[17];
assign Q0_FABRIC_LN3_TXDATA_I[18] = q0_ln3_tx_data_i[18];
assign Q0_FABRIC_LN3_TXDATA_I[19] = q0_ln3_tx_data_i[19];
assign Q0_FABRIC_LN3_TXDATA_I[20] = q0_ln3_tx_data_i[20];
assign Q0_FABRIC_LN3_TXDATA_I[21] = q0_ln3_tx_data_i[21];
assign Q0_FABRIC_LN3_TXDATA_I[22] = q0_ln3_tx_data_i[22];
assign Q0_FABRIC_LN3_TXDATA_I[23] = q0_ln3_tx_data_i[23];
assign Q0_FABRIC_LN3_TXDATA_I[24] = q0_ln3_tx_data_i[24];
assign Q0_FABRIC_LN3_TXDATA_I[25] = q0_ln3_tx_data_i[25];
assign Q0_FABRIC_LN3_TXDATA_I[26] = q0_ln3_tx_data_i[26];
assign Q0_FABRIC_LN3_TXDATA_I[27] = q0_ln3_tx_data_i[27];
assign Q0_FABRIC_LN3_TXDATA_I[28] = q0_ln3_tx_data_i[28];
assign Q0_FABRIC_LN3_TXDATA_I[29] = q0_ln3_tx_data_i[29];
assign Q0_FABRIC_LN3_TXDATA_I[30] = q0_ln3_tx_data_i[30];
assign Q0_FABRIC_LN3_TXDATA_I[31] = q0_ln3_tx_data_i[31];
assign Q0_FABRIC_LN3_TXDATA_I[32] = q0_ln3_tx_data_i[32];
assign Q0_FABRIC_LN3_TXDATA_I[33] = q0_ln3_tx_data_i[33];
assign Q0_FABRIC_LN3_TXDATA_I[34] = q0_ln3_tx_data_i[34];
assign Q0_FABRIC_LN3_TXDATA_I[35] = q0_ln3_tx_data_i[35];
assign Q0_FABRIC_LN3_TXDATA_I[36] = q0_ln3_tx_data_i[36];
assign Q0_FABRIC_LN3_TXDATA_I[37] = q0_ln3_tx_data_i[37];
assign Q0_FABRIC_LN3_TXDATA_I[38] = q0_ln3_tx_data_i[38];
assign Q0_FABRIC_LN3_TXDATA_I[39] = q0_ln3_tx_data_i[39];
assign Q0_FABRIC_LN3_TXDATA_I[40] = q0_ln3_tx_data_i[40];
assign Q0_FABRIC_LN3_TXDATA_I[41] = q0_ln3_tx_data_i[41];
assign Q0_FABRIC_LN3_TXDATA_I[42] = q0_ln3_tx_data_i[42];
assign Q0_FABRIC_LN3_TXDATA_I[43] = q0_ln3_tx_data_i[43];
assign Q0_FABRIC_LN3_TXDATA_I[44] = q0_ln3_tx_data_i[44];
assign Q0_FABRIC_LN3_TXDATA_I[45] = q0_ln3_tx_data_i[45];
assign Q0_FABRIC_LN3_TXDATA_I[46] = q0_ln3_tx_data_i[46];
assign Q0_FABRIC_LN3_TXDATA_I[47] = q0_ln3_tx_data_i[47];
assign Q0_FABRIC_LN3_TXDATA_I[48] = q0_ln3_tx_data_i[48];
assign Q0_FABRIC_LN3_TXDATA_I[49] = q0_ln3_tx_data_i[49];
assign Q0_FABRIC_LN3_TXDATA_I[50] = q0_ln3_tx_data_i[50];
assign Q0_FABRIC_LN3_TXDATA_I[51] = q0_ln3_tx_data_i[51];
assign Q0_FABRIC_LN3_TXDATA_I[52] = q0_ln3_tx_data_i[52];
assign Q0_FABRIC_LN3_TXDATA_I[53] = q0_ln3_tx_data_i[53];
assign Q0_FABRIC_LN3_TXDATA_I[54] = q0_ln3_tx_data_i[54];
assign Q0_FABRIC_LN3_TXDATA_I[55] = q0_ln3_tx_data_i[55];
assign Q0_FABRIC_LN3_TXDATA_I[56] = q0_ln3_tx_data_i[56];
assign Q0_FABRIC_LN3_TXDATA_I[57] = q0_ln3_tx_data_i[57];
assign Q0_FABRIC_LN3_TXDATA_I[58] = q0_ln3_tx_data_i[58];
assign Q0_FABRIC_LN3_TXDATA_I[59] = q0_ln3_tx_data_i[59];
assign Q0_FABRIC_LN3_TXDATA_I[60] = q0_ln3_tx_data_i[60];
assign Q0_FABRIC_LN3_TXDATA_I[61] = q0_ln3_tx_data_i[61];
assign Q0_FABRIC_LN3_TXDATA_I[62] = q0_ln3_tx_data_i[62];
assign Q0_FABRIC_LN3_TXDATA_I[63] = q0_ln3_tx_data_i[63];
assign Q0_FABRIC_LN3_TXDATA_I[64] = q0_ln3_tx_data_i[64];
assign Q0_FABRIC_LN3_TXDATA_I[65] = q0_ln3_tx_data_i[65];
assign Q0_FABRIC_LN3_TXDATA_I[66] = q0_ln3_tx_data_i[66];
assign Q0_FABRIC_LN3_TXDATA_I[67] = q0_ln3_tx_data_i[67];
assign Q0_FABRIC_LN3_TXDATA_I[68] = q0_ln3_tx_data_i[68];
assign Q0_FABRIC_LN3_TXDATA_I[69] = q0_ln3_tx_data_i[69];
assign Q0_FABRIC_LN3_TXDATA_I[70] = q0_ln3_tx_data_i[70];
assign Q0_FABRIC_LN3_TXDATA_I[71] = q0_ln3_tx_data_i[71];
assign Q0_FABRIC_LN3_TXDATA_I[72] = q0_ln3_tx_data_i[72];
assign Q0_FABRIC_LN3_TXDATA_I[73] = q0_ln3_tx_data_i[73];
assign Q0_FABRIC_LN3_TXDATA_I[74] = q0_ln3_tx_data_i[74];
assign Q0_FABRIC_LN3_TXDATA_I[75] = q0_ln3_tx_data_i[75];
assign Q0_FABRIC_LN3_TXDATA_I[76] = q0_ln3_tx_data_i[76];
assign Q0_FABRIC_LN3_TXDATA_I[77] = q0_ln3_tx_data_i[77];
assign Q0_FABRIC_LN3_TXDATA_I[78] = q0_ln3_tx_data_i[78];
assign Q0_FABRIC_LN3_TXDATA_I[79] = q0_ln3_tx_data_i[79];
assign Q0_FABRIC_LN3_TX_VLD_IN = q0_ln3_tx_fifo_wren_i;
assign Q0_LANE3_FABRIC_C2I_CLK = GND;
assign Q0_LANE3_CHBOND_START = GND;
assign Q0_FABRIC_LN3_RSTN_I = q0_ln3_pma_rstn_i;
assign Q0_LANE3_PCS_RX_RST = q0_ln3_pcs_rx_rst_i;
assign Q0_LANE3_PCS_TX_RST = q0_ln3_pcs_tx_rst_i;
assign q0_ln3_rx_pcs_clkout_o = Q0_LANE3_PCS_RX_O_FABRIC_CLK;
assign q0_ln3_rx_data_o[0] = Q0_FABRIC_LN3_RXDATA_O[0];
assign q0_ln3_rx_data_o[1] = Q0_FABRIC_LN3_RXDATA_O[1];
assign q0_ln3_rx_data_o[2] = Q0_FABRIC_LN3_RXDATA_O[2];
assign q0_ln3_rx_data_o[3] = Q0_FABRIC_LN3_RXDATA_O[3];
assign q0_ln3_rx_data_o[4] = Q0_FABRIC_LN3_RXDATA_O[4];
assign q0_ln3_rx_data_o[5] = Q0_FABRIC_LN3_RXDATA_O[5];
assign q0_ln3_rx_data_o[6] = Q0_FABRIC_LN3_RXDATA_O[6];
assign q0_ln3_rx_data_o[7] = Q0_FABRIC_LN3_RXDATA_O[7];
assign q0_ln3_rx_data_o[8] = Q0_FABRIC_LN3_RXDATA_O[8];
assign q0_ln3_rx_data_o[9] = Q0_FABRIC_LN3_RXDATA_O[9];
assign q0_ln3_rx_data_o[10] = Q0_FABRIC_LN3_RXDATA_O[10];
assign q0_ln3_rx_data_o[11] = Q0_FABRIC_LN3_RXDATA_O[11];
assign q0_ln3_rx_data_o[12] = Q0_FABRIC_LN3_RXDATA_O[12];
assign q0_ln3_rx_data_o[13] = Q0_FABRIC_LN3_RXDATA_O[13];
assign q0_ln3_rx_data_o[14] = Q0_FABRIC_LN3_RXDATA_O[14];
assign q0_ln3_rx_data_o[15] = Q0_FABRIC_LN3_RXDATA_O[15];
assign q0_ln3_rx_data_o[16] = Q0_FABRIC_LN3_RXDATA_O[16];
assign q0_ln3_rx_data_o[17] = Q0_FABRIC_LN3_RXDATA_O[17];
assign q0_ln3_rx_data_o[18] = Q0_FABRIC_LN3_RXDATA_O[18];
assign q0_ln3_rx_data_o[19] = Q0_FABRIC_LN3_RXDATA_O[19];
assign q0_ln3_rx_data_o[20] = Q0_FABRIC_LN3_RXDATA_O[20];
assign q0_ln3_rx_data_o[21] = Q0_FABRIC_LN3_RXDATA_O[21];
assign q0_ln3_rx_data_o[22] = Q0_FABRIC_LN3_RXDATA_O[22];
assign q0_ln3_rx_data_o[23] = Q0_FABRIC_LN3_RXDATA_O[23];
assign q0_ln3_rx_data_o[24] = Q0_FABRIC_LN3_RXDATA_O[24];
assign q0_ln3_rx_data_o[25] = Q0_FABRIC_LN3_RXDATA_O[25];
assign q0_ln3_rx_data_o[26] = Q0_FABRIC_LN3_RXDATA_O[26];
assign q0_ln3_rx_data_o[27] = Q0_FABRIC_LN3_RXDATA_O[27];
assign q0_ln3_rx_data_o[28] = Q0_FABRIC_LN3_RXDATA_O[28];
assign q0_ln3_rx_data_o[29] = Q0_FABRIC_LN3_RXDATA_O[29];
assign q0_ln3_rx_data_o[30] = Q0_FABRIC_LN3_RXDATA_O[30];
assign q0_ln3_rx_data_o[31] = Q0_FABRIC_LN3_RXDATA_O[31];
assign q0_ln3_rx_data_o[32] = Q0_FABRIC_LN3_RXDATA_O[32];
assign q0_ln3_rx_data_o[33] = Q0_FABRIC_LN3_RXDATA_O[33];
assign q0_ln3_rx_data_o[34] = Q0_FABRIC_LN3_RXDATA_O[34];
assign q0_ln3_rx_data_o[35] = Q0_FABRIC_LN3_RXDATA_O[35];
assign q0_ln3_rx_data_o[36] = Q0_FABRIC_LN3_RXDATA_O[36];
assign q0_ln3_rx_data_o[37] = Q0_FABRIC_LN3_RXDATA_O[37];
assign q0_ln3_rx_data_o[38] = Q0_FABRIC_LN3_RXDATA_O[38];
assign q0_ln3_rx_data_o[39] = Q0_FABRIC_LN3_RXDATA_O[39];
assign q0_ln3_rx_data_o[40] = Q0_FABRIC_LN3_RXDATA_O[40];
assign q0_ln3_rx_data_o[41] = Q0_FABRIC_LN3_RXDATA_O[41];
assign q0_ln3_rx_data_o[42] = Q0_FABRIC_LN3_RXDATA_O[42];
assign q0_ln3_rx_data_o[43] = Q0_FABRIC_LN3_RXDATA_O[43];
assign q0_ln3_rx_data_o[44] = Q0_FABRIC_LN3_RXDATA_O[44];
assign q0_ln3_rx_data_o[45] = Q0_FABRIC_LN3_RXDATA_O[45];
assign q0_ln3_rx_data_o[46] = Q0_FABRIC_LN3_RXDATA_O[46];
assign q0_ln3_rx_data_o[47] = Q0_FABRIC_LN3_RXDATA_O[47];
assign q0_ln3_rx_data_o[48] = Q0_FABRIC_LN3_RXDATA_O[48];
assign q0_ln3_rx_data_o[49] = Q0_FABRIC_LN3_RXDATA_O[49];
assign q0_ln3_rx_data_o[50] = Q0_FABRIC_LN3_RXDATA_O[50];
assign q0_ln3_rx_data_o[51] = Q0_FABRIC_LN3_RXDATA_O[51];
assign q0_ln3_rx_data_o[52] = Q0_FABRIC_LN3_RXDATA_O[52];
assign q0_ln3_rx_data_o[53] = Q0_FABRIC_LN3_RXDATA_O[53];
assign q0_ln3_rx_data_o[54] = Q0_FABRIC_LN3_RXDATA_O[54];
assign q0_ln3_rx_data_o[55] = Q0_FABRIC_LN3_RXDATA_O[55];
assign q0_ln3_rx_data_o[56] = Q0_FABRIC_LN3_RXDATA_O[56];
assign q0_ln3_rx_data_o[57] = Q0_FABRIC_LN3_RXDATA_O[57];
assign q0_ln3_rx_data_o[58] = Q0_FABRIC_LN3_RXDATA_O[58];
assign q0_ln3_rx_data_o[59] = Q0_FABRIC_LN3_RXDATA_O[59];
assign q0_ln3_rx_data_o[60] = Q0_FABRIC_LN3_RXDATA_O[60];
assign q0_ln3_rx_data_o[61] = Q0_FABRIC_LN3_RXDATA_O[61];
assign q0_ln3_rx_data_o[62] = Q0_FABRIC_LN3_RXDATA_O[62];
assign q0_ln3_rx_data_o[63] = Q0_FABRIC_LN3_RXDATA_O[63];
assign q0_ln3_rx_data_o[64] = Q0_FABRIC_LN3_RXDATA_O[64];
assign q0_ln3_rx_data_o[65] = Q0_FABRIC_LN3_RXDATA_O[65];
assign q0_ln3_rx_data_o[66] = Q0_FABRIC_LN3_RXDATA_O[66];
assign q0_ln3_rx_data_o[67] = Q0_FABRIC_LN3_RXDATA_O[67];
assign q0_ln3_rx_data_o[68] = Q0_FABRIC_LN3_RXDATA_O[68];
assign q0_ln3_rx_data_o[69] = Q0_FABRIC_LN3_RXDATA_O[69];
assign q0_ln3_rx_data_o[70] = Q0_FABRIC_LN3_RXDATA_O[70];
assign q0_ln3_rx_data_o[71] = Q0_FABRIC_LN3_RXDATA_O[71];
assign q0_ln3_rx_data_o[72] = Q0_FABRIC_LN3_RXDATA_O[72];
assign q0_ln3_rx_data_o[73] = Q0_FABRIC_LN3_RXDATA_O[73];
assign q0_ln3_rx_data_o[74] = Q0_FABRIC_LN3_RXDATA_O[74];
assign q0_ln3_rx_data_o[75] = Q0_FABRIC_LN3_RXDATA_O[75];
assign q0_ln3_rx_data_o[76] = Q0_FABRIC_LN3_RXDATA_O[76];
assign q0_ln3_rx_data_o[77] = Q0_FABRIC_LN3_RXDATA_O[77];
assign q0_ln3_rx_data_o[78] = Q0_FABRIC_LN3_RXDATA_O[78];
assign q0_ln3_rx_data_o[79] = Q0_FABRIC_LN3_RXDATA_O[79];
assign q0_ln3_rx_data_o[80] = Q0_FABRIC_LN3_RXDATA_O[80];
assign q0_ln3_rx_data_o[81] = Q0_FABRIC_LN3_RXDATA_O[81];
assign q0_ln3_rx_data_o[82] = Q0_FABRIC_LN3_RXDATA_O[82];
assign q0_ln3_rx_data_o[83] = Q0_FABRIC_LN3_RXDATA_O[83];
assign q0_ln3_rx_data_o[84] = Q0_FABRIC_LN3_RXDATA_O[84];
assign q0_ln3_rx_data_o[85] = Q0_FABRIC_LN3_RXDATA_O[85];
assign q0_ln3_rx_data_o[86] = Q0_FABRIC_LN3_RXDATA_O[86];
assign q0_ln3_rx_data_o[87] = Q0_FABRIC_LN3_RXDATA_O[87];
assign q0_ln3_rx_fifo_rdusewd_o[0] = Q0_LANE3_RX_IF_FIFO_RDUSEWD[0];
assign q0_ln3_rx_fifo_rdusewd_o[1] = Q0_LANE3_RX_IF_FIFO_RDUSEWD[1];
assign q0_ln3_rx_fifo_rdusewd_o[2] = Q0_LANE3_RX_IF_FIFO_RDUSEWD[2];
assign q0_ln3_rx_fifo_rdusewd_o[3] = Q0_LANE3_RX_IF_FIFO_RDUSEWD[3];
assign q0_ln3_rx_fifo_rdusewd_o[4] = Q0_LANE3_RX_IF_FIFO_RDUSEWD[4];
assign q0_ln3_rx_fifo_aempty_o = Q0_LANE3_RX_IF_FIFO_AEMPTY;
assign q0_ln3_rx_fifo_empty_o = Q0_LANE3_RX_IF_FIFO_EMPTY;
assign q0_ln3_rx_valid_o = Q0_FABRIC_LN3_RX_VLD_OUT;
assign q0_ln3_tx_pcs_clkout_o = Q0_LANE3_PCS_TX_O_FABRIC_CLK;
assign q0_ln3_tx_fifo_wrusewd_o[0] = Q0_LANE3_TX_IF_FIFO_WRUSEWD[0];
assign q0_ln3_tx_fifo_wrusewd_o[1] = Q0_LANE3_TX_IF_FIFO_WRUSEWD[1];
assign q0_ln3_tx_fifo_wrusewd_o[2] = Q0_LANE3_TX_IF_FIFO_WRUSEWD[2];
assign q0_ln3_tx_fifo_wrusewd_o[3] = Q0_LANE3_TX_IF_FIFO_WRUSEWD[3];
assign q0_ln3_tx_fifo_wrusewd_o[4] = Q0_LANE3_TX_IF_FIFO_WRUSEWD[4];
assign q0_ln3_tx_fifo_afull_o = Q0_LANE3_TX_IF_FIFO_AFULL;
assign q0_ln3_tx_fifo_full_o = Q0_LANE3_TX_IF_FIFO_FULL;
assign q0_ln3_ready_o = Q0_FABRIC_LN3_STAT_O[12];
assign q0_ln3_refclk_o = Q0_FABRIC_CMU_CK_REF_O;
assign q0_ln3_signal_detect_o = Q0_FABRIC_LN3_ASTAT_O[5];
assign q0_ln3_rx_cdr_lock_o = Q0_FABRIC_LN3_PMA_RX_LOCK_O;
assign q0_ln3_pll_lock_o = Q0_FABRIC_CMU_OK_O;
endmodule /* Customized_PHY_Top */
