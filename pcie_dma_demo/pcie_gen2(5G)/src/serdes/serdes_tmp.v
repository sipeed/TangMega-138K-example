//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.01 (64-bit)
//Part Number: GW5AST-LV138PG484AC1/I0
//Device: GW5AST-138
//Device Version: B
//Created Time: Tue Mar 11 19:07:37 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    SerDes_Top your_instance_name(
        .PCIE_Controller_Top_pcie_tl_rx_sop_o(PCIE_Controller_Top_pcie_tl_rx_sop_o), //output PCIE_Controller_Top_pcie_tl_rx_sop_o
        .PCIE_Controller_Top_pcie_tl_rx_eop_o(PCIE_Controller_Top_pcie_tl_rx_eop_o), //output PCIE_Controller_Top_pcie_tl_rx_eop_o
        .PCIE_Controller_Top_pcie_tl_rx_data_o(PCIE_Controller_Top_pcie_tl_rx_data_o), //output [255:0] PCIE_Controller_Top_pcie_tl_rx_data_o
        .PCIE_Controller_Top_pcie_tl_rx_valid_o(PCIE_Controller_Top_pcie_tl_rx_valid_o), //output [7:0] PCIE_Controller_Top_pcie_tl_rx_valid_o
        .PCIE_Controller_Top_pcie_tl_rx_bardec_o(PCIE_Controller_Top_pcie_tl_rx_bardec_o), //output [5:0] PCIE_Controller_Top_pcie_tl_rx_bardec_o
        .PCIE_Controller_Top_pcie_tl_rx_err_o(PCIE_Controller_Top_pcie_tl_rx_err_o), //output [7:0] PCIE_Controller_Top_pcie_tl_rx_err_o
        .PCIE_Controller_Top_pcie_tl_tx_wait_o(PCIE_Controller_Top_pcie_tl_tx_wait_o), //output PCIE_Controller_Top_pcie_tl_tx_wait_o
        .PCIE_Controller_Top_pcie_tl_int_ack_o(PCIE_Controller_Top_pcie_tl_int_ack_o), //output PCIE_Controller_Top_pcie_tl_int_ack_o
        .PCIE_Controller_Top_pcie_ltssm_o(PCIE_Controller_Top_pcie_ltssm_o), //output [4:0] PCIE_Controller_Top_pcie_ltssm_o
        .PCIE_Controller_Top_pcie_tl_tx_creditsp_o(PCIE_Controller_Top_pcie_tl_tx_creditsp_o), //output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditsp_o
        .PCIE_Controller_Top_pcie_tl_tx_creditsnp_o(PCIE_Controller_Top_pcie_tl_tx_creditsnp_o), //output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditsnp_o
        .PCIE_Controller_Top_pcie_tl_tx_creditscpl_o(PCIE_Controller_Top_pcie_tl_tx_creditscpl_o), //output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditscpl_o
        .PCIE_Controller_Top_pcie_tl_cfg_busdev_o(PCIE_Controller_Top_pcie_tl_cfg_busdev_o), //output [12:0] PCIE_Controller_Top_pcie_tl_cfg_busdev_o
        .PCIE_Controller_Top_pcie_linkup_o(PCIE_Controller_Top_pcie_linkup_o), //output PCIE_Controller_Top_pcie_linkup_o
        .PCIE_Controller_Top_pcie_tl_drp_clk_o(PCIE_Controller_Top_pcie_tl_drp_clk_o), //output PCIE_Controller_Top_pcie_tl_drp_clk_o
        .PCIE_Controller_Top_pcie_tl_drp_rddata_o(PCIE_Controller_Top_pcie_tl_drp_rddata_o), //output [31:0] PCIE_Controller_Top_pcie_tl_drp_rddata_o
        .PCIE_Controller_Top_pcie_tl_drp_resp_o(PCIE_Controller_Top_pcie_tl_drp_resp_o), //output PCIE_Controller_Top_pcie_tl_drp_resp_o
        .PCIE_Controller_Top_pcie_tl_drp_rd_valid_o(PCIE_Controller_Top_pcie_tl_drp_rd_valid_o), //output PCIE_Controller_Top_pcie_tl_drp_rd_valid_o
        .PCIE_Controller_Top_pcie_tl_drp_ready_o(PCIE_Controller_Top_pcie_tl_drp_ready_o), //output PCIE_Controller_Top_pcie_tl_drp_ready_o
        .PCIE_Controller_Top_pcie_rstn_i(PCIE_Controller_Top_pcie_rstn_i), //input PCIE_Controller_Top_pcie_rstn_i
        .PCIE_Controller_Top_pcie_tl_clk_i(PCIE_Controller_Top_pcie_tl_clk_i), //input PCIE_Controller_Top_pcie_tl_clk_i
        .PCIE_Controller_Top_pcie_tl_rx_wait_i(PCIE_Controller_Top_pcie_tl_rx_wait_i), //input PCIE_Controller_Top_pcie_tl_rx_wait_i
        .PCIE_Controller_Top_pcie_tl_rx_masknp_i(PCIE_Controller_Top_pcie_tl_rx_masknp_i), //input PCIE_Controller_Top_pcie_tl_rx_masknp_i
        .PCIE_Controller_Top_pcie_tl_tx_sop_i(PCIE_Controller_Top_pcie_tl_tx_sop_i), //input PCIE_Controller_Top_pcie_tl_tx_sop_i
        .PCIE_Controller_Top_pcie_tl_tx_eop_i(PCIE_Controller_Top_pcie_tl_tx_eop_i), //input PCIE_Controller_Top_pcie_tl_tx_eop_i
        .PCIE_Controller_Top_pcie_tl_tx_data_i(PCIE_Controller_Top_pcie_tl_tx_data_i), //input [255:0] PCIE_Controller_Top_pcie_tl_tx_data_i
        .PCIE_Controller_Top_pcie_tl_tx_valid_i(PCIE_Controller_Top_pcie_tl_tx_valid_i), //input [7:0] PCIE_Controller_Top_pcie_tl_tx_valid_i
        .PCIE_Controller_Top_pcie_tl_int_status_i(PCIE_Controller_Top_pcie_tl_int_status_i), //input PCIE_Controller_Top_pcie_tl_int_status_i
        .PCIE_Controller_Top_pcie_tl_int_req_i(PCIE_Controller_Top_pcie_tl_int_req_i), //input PCIE_Controller_Top_pcie_tl_int_req_i
        .PCIE_Controller_Top_pcie_tl_int_msinum_i(PCIE_Controller_Top_pcie_tl_int_msinum_i), //input [4:0] PCIE_Controller_Top_pcie_tl_int_msinum_i
        .PCIE_Controller_Top_pcie_tl_drp_addr_i(PCIE_Controller_Top_pcie_tl_drp_addr_i), //input [23:0] PCIE_Controller_Top_pcie_tl_drp_addr_i
        .PCIE_Controller_Top_pcie_tl_drp_wrdata_i(PCIE_Controller_Top_pcie_tl_drp_wrdata_i), //input [31:0] PCIE_Controller_Top_pcie_tl_drp_wrdata_i
        .PCIE_Controller_Top_pcie_tl_drp_strb_i(PCIE_Controller_Top_pcie_tl_drp_strb_i), //input [7:0] PCIE_Controller_Top_pcie_tl_drp_strb_i
        .PCIE_Controller_Top_pcie_tl_drp_wr_i(PCIE_Controller_Top_pcie_tl_drp_wr_i), //input PCIE_Controller_Top_pcie_tl_drp_wr_i
        .PCIE_Controller_Top_pcie_tl_drp_rd_i(PCIE_Controller_Top_pcie_tl_drp_rd_i) //input PCIE_Controller_Top_pcie_tl_drp_rd_i
    );

//--------Copy end-------------------
