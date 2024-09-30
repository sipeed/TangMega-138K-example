//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.03 (64-bit)
//Part Number: GW5AST-LV138PG484AES
//Device: GW5AST-138B
//Device Version: B
//Created Time: Fri May 10 00:53:26 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    SerDes_Test your_instance_name(
        .Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o(Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln0_rx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln0_rx_data_o(Customized_PHY_Top_q0_ln0_rx_data_o), //output [87:0] Customized_PHY_Top_q0_ln0_rx_data_o
        .Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o(Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o), //output [4:0] Customized_PHY_Top_q0_ln0_rx_fifo_rdusewd_o
        .Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o(Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o), //output Customized_PHY_Top_q0_ln0_rx_fifo_aempty_o
        .Customized_PHY_Top_q0_ln0_rx_fifo_empty_o(Customized_PHY_Top_q0_ln0_rx_fifo_empty_o), //output Customized_PHY_Top_q0_ln0_rx_fifo_empty_o
        .Customized_PHY_Top_q0_ln0_rx_valid_o(Customized_PHY_Top_q0_ln0_rx_valid_o), //output Customized_PHY_Top_q0_ln0_rx_valid_o
        .Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o(Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln0_tx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o(Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o), //output [4:0] Customized_PHY_Top_q0_ln0_tx_fifo_wrusewd_o
        .Customized_PHY_Top_q0_ln0_tx_fifo_afull_o(Customized_PHY_Top_q0_ln0_tx_fifo_afull_o), //output Customized_PHY_Top_q0_ln0_tx_fifo_afull_o
        .Customized_PHY_Top_q0_ln0_tx_fifo_full_o(Customized_PHY_Top_q0_ln0_tx_fifo_full_o), //output Customized_PHY_Top_q0_ln0_tx_fifo_full_o
        .Customized_PHY_Top_q0_ln0_refclk_o(Customized_PHY_Top_q0_ln0_refclk_o), //output Customized_PHY_Top_q0_ln0_refclk_o
        .Customized_PHY_Top_q0_ln0_signal_detect_o(Customized_PHY_Top_q0_ln0_signal_detect_o), //output Customized_PHY_Top_q0_ln0_signal_detect_o
        .Customized_PHY_Top_q0_ln0_rx_cdr_lock_o(Customized_PHY_Top_q0_ln0_rx_cdr_lock_o), //output Customized_PHY_Top_q0_ln0_rx_cdr_lock_o
        .Customized_PHY_Top_q0_ln0_pll_lock_o(Customized_PHY_Top_q0_ln0_pll_lock_o), //output Customized_PHY_Top_q0_ln0_pll_lock_o
        .Customized_PHY_Top_q0_ln0_ready_o(Customized_PHY_Top_q0_ln0_ready_o), //output Customized_PHY_Top_q0_ln0_ready_o
        .Customized_PHY_Top_q0_ln1_rx_pcs_clkout_o(Customized_PHY_Top_q0_ln1_rx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln1_rx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln1_rx_data_o(Customized_PHY_Top_q0_ln1_rx_data_o), //output [87:0] Customized_PHY_Top_q0_ln1_rx_data_o
        .Customized_PHY_Top_q0_ln1_rx_fifo_rdusewd_o(Customized_PHY_Top_q0_ln1_rx_fifo_rdusewd_o), //output [4:0] Customized_PHY_Top_q0_ln1_rx_fifo_rdusewd_o
        .Customized_PHY_Top_q0_ln1_rx_fifo_aempty_o(Customized_PHY_Top_q0_ln1_rx_fifo_aempty_o), //output Customized_PHY_Top_q0_ln1_rx_fifo_aempty_o
        .Customized_PHY_Top_q0_ln1_rx_fifo_empty_o(Customized_PHY_Top_q0_ln1_rx_fifo_empty_o), //output Customized_PHY_Top_q0_ln1_rx_fifo_empty_o
        .Customized_PHY_Top_q0_ln1_rx_valid_o(Customized_PHY_Top_q0_ln1_rx_valid_o), //output Customized_PHY_Top_q0_ln1_rx_valid_o
        .Customized_PHY_Top_q0_ln1_tx_pcs_clkout_o(Customized_PHY_Top_q0_ln1_tx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln1_tx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln1_tx_fifo_wrusewd_o(Customized_PHY_Top_q0_ln1_tx_fifo_wrusewd_o), //output [4:0] Customized_PHY_Top_q0_ln1_tx_fifo_wrusewd_o
        .Customized_PHY_Top_q0_ln1_tx_fifo_afull_o(Customized_PHY_Top_q0_ln1_tx_fifo_afull_o), //output Customized_PHY_Top_q0_ln1_tx_fifo_afull_o
        .Customized_PHY_Top_q0_ln1_tx_fifo_full_o(Customized_PHY_Top_q0_ln1_tx_fifo_full_o), //output Customized_PHY_Top_q0_ln1_tx_fifo_full_o
        .Customized_PHY_Top_q0_ln1_refclk_o(Customized_PHY_Top_q0_ln1_refclk_o), //output Customized_PHY_Top_q0_ln1_refclk_o
        .Customized_PHY_Top_q0_ln1_signal_detect_o(Customized_PHY_Top_q0_ln1_signal_detect_o), //output Customized_PHY_Top_q0_ln1_signal_detect_o
        .Customized_PHY_Top_q0_ln1_rx_cdr_lock_o(Customized_PHY_Top_q0_ln1_rx_cdr_lock_o), //output Customized_PHY_Top_q0_ln1_rx_cdr_lock_o
        .Customized_PHY_Top_q0_ln1_pll_lock_o(Customized_PHY_Top_q0_ln1_pll_lock_o), //output Customized_PHY_Top_q0_ln1_pll_lock_o
        .Customized_PHY_Top_q0_ln1_ready_o(Customized_PHY_Top_q0_ln1_ready_o), //output Customized_PHY_Top_q0_ln1_ready_o
        .Customized_PHY_Top_q0_ln2_rx_pcs_clkout_o(Customized_PHY_Top_q0_ln2_rx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln2_rx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln2_rx_data_o(Customized_PHY_Top_q0_ln2_rx_data_o), //output [87:0] Customized_PHY_Top_q0_ln2_rx_data_o
        .Customized_PHY_Top_q0_ln2_rx_fifo_rdusewd_o(Customized_PHY_Top_q0_ln2_rx_fifo_rdusewd_o), //output [4:0] Customized_PHY_Top_q0_ln2_rx_fifo_rdusewd_o
        .Customized_PHY_Top_q0_ln2_rx_fifo_aempty_o(Customized_PHY_Top_q0_ln2_rx_fifo_aempty_o), //output Customized_PHY_Top_q0_ln2_rx_fifo_aempty_o
        .Customized_PHY_Top_q0_ln2_rx_fifo_empty_o(Customized_PHY_Top_q0_ln2_rx_fifo_empty_o), //output Customized_PHY_Top_q0_ln2_rx_fifo_empty_o
        .Customized_PHY_Top_q0_ln2_rx_valid_o(Customized_PHY_Top_q0_ln2_rx_valid_o), //output Customized_PHY_Top_q0_ln2_rx_valid_o
        .Customized_PHY_Top_q0_ln2_tx_pcs_clkout_o(Customized_PHY_Top_q0_ln2_tx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln2_tx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln2_tx_fifo_wrusewd_o(Customized_PHY_Top_q0_ln2_tx_fifo_wrusewd_o), //output [4:0] Customized_PHY_Top_q0_ln2_tx_fifo_wrusewd_o
        .Customized_PHY_Top_q0_ln2_tx_fifo_afull_o(Customized_PHY_Top_q0_ln2_tx_fifo_afull_o), //output Customized_PHY_Top_q0_ln2_tx_fifo_afull_o
        .Customized_PHY_Top_q0_ln2_tx_fifo_full_o(Customized_PHY_Top_q0_ln2_tx_fifo_full_o), //output Customized_PHY_Top_q0_ln2_tx_fifo_full_o
        .Customized_PHY_Top_q0_ln2_refclk_o(Customized_PHY_Top_q0_ln2_refclk_o), //output Customized_PHY_Top_q0_ln2_refclk_o
        .Customized_PHY_Top_q0_ln2_signal_detect_o(Customized_PHY_Top_q0_ln2_signal_detect_o), //output Customized_PHY_Top_q0_ln2_signal_detect_o
        .Customized_PHY_Top_q0_ln2_rx_cdr_lock_o(Customized_PHY_Top_q0_ln2_rx_cdr_lock_o), //output Customized_PHY_Top_q0_ln2_rx_cdr_lock_o
        .Customized_PHY_Top_q0_ln2_pll_lock_o(Customized_PHY_Top_q0_ln2_pll_lock_o), //output Customized_PHY_Top_q0_ln2_pll_lock_o
        .Customized_PHY_Top_q0_ln2_ready_o(Customized_PHY_Top_q0_ln2_ready_o), //output Customized_PHY_Top_q0_ln2_ready_o
        .Customized_PHY_Top_q0_ln3_rx_pcs_clkout_o(Customized_PHY_Top_q0_ln3_rx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln3_rx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln3_rx_data_o(Customized_PHY_Top_q0_ln3_rx_data_o), //output [87:0] Customized_PHY_Top_q0_ln3_rx_data_o
        .Customized_PHY_Top_q0_ln3_rx_fifo_rdusewd_o(Customized_PHY_Top_q0_ln3_rx_fifo_rdusewd_o), //output [4:0] Customized_PHY_Top_q0_ln3_rx_fifo_rdusewd_o
        .Customized_PHY_Top_q0_ln3_rx_fifo_aempty_o(Customized_PHY_Top_q0_ln3_rx_fifo_aempty_o), //output Customized_PHY_Top_q0_ln3_rx_fifo_aempty_o
        .Customized_PHY_Top_q0_ln3_rx_fifo_empty_o(Customized_PHY_Top_q0_ln3_rx_fifo_empty_o), //output Customized_PHY_Top_q0_ln3_rx_fifo_empty_o
        .Customized_PHY_Top_q0_ln3_rx_valid_o(Customized_PHY_Top_q0_ln3_rx_valid_o), //output Customized_PHY_Top_q0_ln3_rx_valid_o
        .Customized_PHY_Top_q0_ln3_tx_pcs_clkout_o(Customized_PHY_Top_q0_ln3_tx_pcs_clkout_o), //output Customized_PHY_Top_q0_ln3_tx_pcs_clkout_o
        .Customized_PHY_Top_q0_ln3_tx_fifo_wrusewd_o(Customized_PHY_Top_q0_ln3_tx_fifo_wrusewd_o), //output [4:0] Customized_PHY_Top_q0_ln3_tx_fifo_wrusewd_o
        .Customized_PHY_Top_q0_ln3_tx_fifo_afull_o(Customized_PHY_Top_q0_ln3_tx_fifo_afull_o), //output Customized_PHY_Top_q0_ln3_tx_fifo_afull_o
        .Customized_PHY_Top_q0_ln3_tx_fifo_full_o(Customized_PHY_Top_q0_ln3_tx_fifo_full_o), //output Customized_PHY_Top_q0_ln3_tx_fifo_full_o
        .Customized_PHY_Top_q0_ln3_refclk_o(Customized_PHY_Top_q0_ln3_refclk_o), //output Customized_PHY_Top_q0_ln3_refclk_o
        .Customized_PHY_Top_q0_ln3_signal_detect_o(Customized_PHY_Top_q0_ln3_signal_detect_o), //output Customized_PHY_Top_q0_ln3_signal_detect_o
        .Customized_PHY_Top_q0_ln3_rx_cdr_lock_o(Customized_PHY_Top_q0_ln3_rx_cdr_lock_o), //output Customized_PHY_Top_q0_ln3_rx_cdr_lock_o
        .Customized_PHY_Top_q0_ln3_pll_lock_o(Customized_PHY_Top_q0_ln3_pll_lock_o), //output Customized_PHY_Top_q0_ln3_pll_lock_o
        .Customized_PHY_Top_q0_ln3_ready_o(Customized_PHY_Top_q0_ln3_ready_o), //output Customized_PHY_Top_q0_ln3_ready_o
        .Customized_PHY_Top_q0_ln0_rx_clk_i(Customized_PHY_Top_q0_ln0_rx_clk_i), //input Customized_PHY_Top_q0_ln0_rx_clk_i
        .Customized_PHY_Top_q0_ln0_rx_fifo_rden_i(Customized_PHY_Top_q0_ln0_rx_fifo_rden_i), //input Customized_PHY_Top_q0_ln0_rx_fifo_rden_i
        .Customized_PHY_Top_q0_ln0_tx_clk_i(Customized_PHY_Top_q0_ln0_tx_clk_i), //input Customized_PHY_Top_q0_ln0_tx_clk_i
        .Customized_PHY_Top_q0_ln0_tx_data_i(Customized_PHY_Top_q0_ln0_tx_data_i), //input [79:0] Customized_PHY_Top_q0_ln0_tx_data_i
        .Customized_PHY_Top_q0_ln0_tx_fifo_wren_i(Customized_PHY_Top_q0_ln0_tx_fifo_wren_i), //input Customized_PHY_Top_q0_ln0_tx_fifo_wren_i
        .Customized_PHY_Top_q0_ln0_pma_rstn_i(Customized_PHY_Top_q0_ln0_pma_rstn_i), //input Customized_PHY_Top_q0_ln0_pma_rstn_i
        .Customized_PHY_Top_q0_ln0_pcs_rx_rst_i(Customized_PHY_Top_q0_ln0_pcs_rx_rst_i), //input Customized_PHY_Top_q0_ln0_pcs_rx_rst_i
        .Customized_PHY_Top_q0_ln0_pcs_tx_rst_i(Customized_PHY_Top_q0_ln0_pcs_tx_rst_i), //input Customized_PHY_Top_q0_ln0_pcs_tx_rst_i
        .Customized_PHY_Top_q0_ln1_rx_clk_i(Customized_PHY_Top_q0_ln1_rx_clk_i), //input Customized_PHY_Top_q0_ln1_rx_clk_i
        .Customized_PHY_Top_q0_ln1_rx_fifo_rden_i(Customized_PHY_Top_q0_ln1_rx_fifo_rden_i), //input Customized_PHY_Top_q0_ln1_rx_fifo_rden_i
        .Customized_PHY_Top_q0_ln1_tx_clk_i(Customized_PHY_Top_q0_ln1_tx_clk_i), //input Customized_PHY_Top_q0_ln1_tx_clk_i
        .Customized_PHY_Top_q0_ln1_tx_data_i(Customized_PHY_Top_q0_ln1_tx_data_i), //input [79:0] Customized_PHY_Top_q0_ln1_tx_data_i
        .Customized_PHY_Top_q0_ln1_tx_fifo_wren_i(Customized_PHY_Top_q0_ln1_tx_fifo_wren_i), //input Customized_PHY_Top_q0_ln1_tx_fifo_wren_i
        .Customized_PHY_Top_q0_ln1_pma_rstn_i(Customized_PHY_Top_q0_ln1_pma_rstn_i), //input Customized_PHY_Top_q0_ln1_pma_rstn_i
        .Customized_PHY_Top_q0_ln1_pcs_rx_rst_i(Customized_PHY_Top_q0_ln1_pcs_rx_rst_i), //input Customized_PHY_Top_q0_ln1_pcs_rx_rst_i
        .Customized_PHY_Top_q0_ln1_pcs_tx_rst_i(Customized_PHY_Top_q0_ln1_pcs_tx_rst_i), //input Customized_PHY_Top_q0_ln1_pcs_tx_rst_i
        .Customized_PHY_Top_q0_ln2_rx_clk_i(Customized_PHY_Top_q0_ln2_rx_clk_i), //input Customized_PHY_Top_q0_ln2_rx_clk_i
        .Customized_PHY_Top_q0_ln2_rx_fifo_rden_i(Customized_PHY_Top_q0_ln2_rx_fifo_rden_i), //input Customized_PHY_Top_q0_ln2_rx_fifo_rden_i
        .Customized_PHY_Top_q0_ln2_tx_clk_i(Customized_PHY_Top_q0_ln2_tx_clk_i), //input Customized_PHY_Top_q0_ln2_tx_clk_i
        .Customized_PHY_Top_q0_ln2_tx_data_i(Customized_PHY_Top_q0_ln2_tx_data_i), //input [79:0] Customized_PHY_Top_q0_ln2_tx_data_i
        .Customized_PHY_Top_q0_ln2_tx_fifo_wren_i(Customized_PHY_Top_q0_ln2_tx_fifo_wren_i), //input Customized_PHY_Top_q0_ln2_tx_fifo_wren_i
        .Customized_PHY_Top_q0_ln2_pma_rstn_i(Customized_PHY_Top_q0_ln2_pma_rstn_i), //input Customized_PHY_Top_q0_ln2_pma_rstn_i
        .Customized_PHY_Top_q0_ln2_pcs_rx_rst_i(Customized_PHY_Top_q0_ln2_pcs_rx_rst_i), //input Customized_PHY_Top_q0_ln2_pcs_rx_rst_i
        .Customized_PHY_Top_q0_ln2_pcs_tx_rst_i(Customized_PHY_Top_q0_ln2_pcs_tx_rst_i), //input Customized_PHY_Top_q0_ln2_pcs_tx_rst_i
        .Customized_PHY_Top_q0_ln3_rx_clk_i(Customized_PHY_Top_q0_ln3_rx_clk_i), //input Customized_PHY_Top_q0_ln3_rx_clk_i
        .Customized_PHY_Top_q0_ln3_rx_fifo_rden_i(Customized_PHY_Top_q0_ln3_rx_fifo_rden_i), //input Customized_PHY_Top_q0_ln3_rx_fifo_rden_i
        .Customized_PHY_Top_q0_ln3_tx_clk_i(Customized_PHY_Top_q0_ln3_tx_clk_i), //input Customized_PHY_Top_q0_ln3_tx_clk_i
        .Customized_PHY_Top_q0_ln3_tx_data_i(Customized_PHY_Top_q0_ln3_tx_data_i), //input [79:0] Customized_PHY_Top_q0_ln3_tx_data_i
        .Customized_PHY_Top_q0_ln3_tx_fifo_wren_i(Customized_PHY_Top_q0_ln3_tx_fifo_wren_i), //input Customized_PHY_Top_q0_ln3_tx_fifo_wren_i
        .Customized_PHY_Top_q0_ln3_pma_rstn_i(Customized_PHY_Top_q0_ln3_pma_rstn_i), //input Customized_PHY_Top_q0_ln3_pma_rstn_i
        .Customized_PHY_Top_q0_ln3_pcs_rx_rst_i(Customized_PHY_Top_q0_ln3_pcs_rx_rst_i), //input Customized_PHY_Top_q0_ln3_pcs_rx_rst_i
        .Customized_PHY_Top_q0_ln3_pcs_tx_rst_i(Customized_PHY_Top_q0_ln3_pcs_tx_rst_i) //input Customized_PHY_Top_q0_ln3_pcs_tx_rst_i
    );

//--------Copy end-------------------
