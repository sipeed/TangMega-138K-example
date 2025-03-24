//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.01 (64-bit)
//Part Number: GW5AST-LV138PG484AC1/I0
//Device: GW5AST-138
//Device Version: B
//Created Time: Mon Mar 24 18:52:02 2025

module SerDes_Top (PCIE_Controller_Top_pcie_tl_rx_sop_o, PCIE_Controller_Top_pcie_tl_rx_eop_o, PCIE_Controller_Top_pcie_tl_rx_data_o, PCIE_Controller_Top_pcie_tl_rx_valid_o, PCIE_Controller_Top_pcie_tl_rx_bardec_o, PCIE_Controller_Top_pcie_tl_rx_err_o, PCIE_Controller_Top_pcie_tl_tx_wait_o, PCIE_Controller_Top_pcie_tl_int_ack_o, PCIE_Controller_Top_pcie_ltssm_o, PCIE_Controller_Top_pcie_tl_tx_creditsp_o, PCIE_Controller_Top_pcie_tl_tx_creditsnp_o, PCIE_Controller_Top_pcie_tl_tx_creditscpl_o, PCIE_Controller_Top_pcie_tl_cfg_busdev_o, PCIE_Controller_Top_pcie_linkup_o, PCIE_Controller_Top_pcie_tl_drp_clk_o, PCIE_Controller_Top_pcie_tl_drp_rddata_o, PCIE_Controller_Top_pcie_tl_drp_resp_o, PCIE_Controller_Top_pcie_tl_drp_rd_valid_o, PCIE_Controller_Top_pcie_tl_drp_ready_o, PCIE_Controller_Top_pcie_rstn_i, PCIE_Controller_Top_pcie_tl_clk_i, PCIE_Controller_Top_pcie_tl_rx_wait_i, PCIE_Controller_Top_pcie_tl_rx_masknp_i, PCIE_Controller_Top_pcie_tl_tx_sop_i, PCIE_Controller_Top_pcie_tl_tx_eop_i, PCIE_Controller_Top_pcie_tl_tx_data_i, PCIE_Controller_Top_pcie_tl_tx_valid_i, PCIE_Controller_Top_pcie_tl_int_status_i, PCIE_Controller_Top_pcie_tl_int_req_i, PCIE_Controller_Top_pcie_tl_int_msinum_i, PCIE_Controller_Top_pcie_tl_drp_addr_i, PCIE_Controller_Top_pcie_tl_drp_wrdata_i, PCIE_Controller_Top_pcie_tl_drp_strb_i, PCIE_Controller_Top_pcie_tl_drp_wr_i, PCIE_Controller_Top_pcie_tl_drp_rd_i);

output PCIE_Controller_Top_pcie_tl_rx_sop_o;
output PCIE_Controller_Top_pcie_tl_rx_eop_o;
output [255:0] PCIE_Controller_Top_pcie_tl_rx_data_o;
output [7:0] PCIE_Controller_Top_pcie_tl_rx_valid_o;
output [5:0] PCIE_Controller_Top_pcie_tl_rx_bardec_o;
output [7:0] PCIE_Controller_Top_pcie_tl_rx_err_o;
output PCIE_Controller_Top_pcie_tl_tx_wait_o;
output PCIE_Controller_Top_pcie_tl_int_ack_o;
output [4:0] PCIE_Controller_Top_pcie_ltssm_o;
output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditsp_o;
output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditsnp_o;
output [31:0] PCIE_Controller_Top_pcie_tl_tx_creditscpl_o;
output [12:0] PCIE_Controller_Top_pcie_tl_cfg_busdev_o;
output PCIE_Controller_Top_pcie_linkup_o;
output PCIE_Controller_Top_pcie_tl_drp_clk_o;
output [31:0] PCIE_Controller_Top_pcie_tl_drp_rddata_o;
output PCIE_Controller_Top_pcie_tl_drp_resp_o;
output PCIE_Controller_Top_pcie_tl_drp_rd_valid_o;
output PCIE_Controller_Top_pcie_tl_drp_ready_o;
input PCIE_Controller_Top_pcie_rstn_i;
input PCIE_Controller_Top_pcie_tl_clk_i;
input PCIE_Controller_Top_pcie_tl_rx_wait_i;
input PCIE_Controller_Top_pcie_tl_rx_masknp_i;
input PCIE_Controller_Top_pcie_tl_tx_sop_i;
input PCIE_Controller_Top_pcie_tl_tx_eop_i;
input [255:0] PCIE_Controller_Top_pcie_tl_tx_data_i;
input [7:0] PCIE_Controller_Top_pcie_tl_tx_valid_i;
input PCIE_Controller_Top_pcie_tl_int_status_i;
input PCIE_Controller_Top_pcie_tl_int_req_i;
input [4:0] PCIE_Controller_Top_pcie_tl_int_msinum_i;
input [23:0] PCIE_Controller_Top_pcie_tl_drp_addr_i;
input [31:0] PCIE_Controller_Top_pcie_tl_drp_wrdata_i;
input [7:0] PCIE_Controller_Top_pcie_tl_drp_strb_i;
input PCIE_Controller_Top_pcie_tl_drp_wr_i;
input PCIE_Controller_Top_pcie_tl_drp_rd_i;

wire PCIE_Controller_Top_pcie_half_clk_i;
wire PCIE_Controller_Top_pcie_tl_clk_o;
wire q0_ahb_rstn;
wire q0_test_dec_en;
wire q0_quad_pcie_clk;
wire q0_pcie_div2_reg;
wire q0_pcie_div4_reg;
wire q0_pmac_ln_rstn;
wire [91:0] q0_inet_q0_q1;
wire [531:0] q0_inet_q_pmac;
wire [227:0] q0_inet_q_test;
wire [420:0] q0_inet_q_upar;
wire q0_ln0_txm_o;
wire q0_ln0_txp_o;
wire q0_ln1_txm_o;
wire q0_ln1_txp_o;
wire q0_ln2_txm_o;
wire q0_ln2_txp_o;
wire q0_ln3_txm_o;
wire q0_ln3_txp_o;
wire q0_fabric_ln0_rxdet_result;
wire q0_fabric_ln1_rxdet_result;
wire q0_fabric_ln2_rxdet_result;
wire q0_fabric_ln3_rxdet_result;
wire q0_fabric_pma_cm0_dr_refclk_det_o;
wire q0_fabric_pma_cm1_dr_refclk_det_o;
wire q0_fabric_cm1_life_clk_o;
wire q0_fabric_cm_life_clk_o;
wire q0_fabric_cmu1_ck_ref_o;
wire q0_fabric_cmu1_ok_o;
wire q0_fabric_cmu1_refclk_gate_ack_o;
wire q0_fabric_cmu_ck_ref_o;
wire q0_fabric_cmu_ok_o;
wire q0_fabric_cmu_refclk_gate_ack_o;
wire q0_fabric_lane0_cmu_ck_ref_o;
wire q0_fabric_lane1_cmu_ck_ref_o;
wire q0_fabric_lane2_cmu_ck_ref_o;
wire q0_fabric_lane3_cmu_ck_ref_o;
wire [5:0] q0_fabric_ln0_astat_o;
wire q0_fabric_ln0_burn_in_toggle_o;
wire q0_fabric_ln0_pma_rx_lock_o;
wire [87:0] q0_fabric_ln0_rxdata_o;
wire [12:0] q0_fabric_ln0_stat_o;
wire [5:0] q0_fabric_ln1_astat_o;
wire q0_fabric_ln1_burn_in_toggle_o;
wire q0_fabric_ln1_pma_rx_lock_o;
wire [87:0] q0_fabric_ln1_rxdata_o;
wire [12:0] q0_fabric_ln1_stat_o;
wire [5:0] q0_fabric_ln2_astat_o;
wire q0_fabric_ln2_burn_in_toggle_o;
wire q0_fabric_ln2_pma_rx_lock_o;
wire [87:0] q0_fabric_ln2_rxdata_o;
wire [12:0] q0_fabric_ln2_stat_o;
wire [5:0] q0_fabric_ln3_astat_o;
wire q0_fabric_ln3_burn_in_toggle_o;
wire q0_fabric_ln3_pma_rx_lock_o;
wire [87:0] q0_fabric_ln3_rxdata_o;
wire [12:0] q0_fabric_ln3_stat_o;
wire q0_fabric_refclk_gate_ack_o;
wire q0_lane0_align_link;
wire q0_lane0_k_lock;
wire [1:0] q0_lane0_disp_err_o;
wire [1:0] q0_lane0_dec_err_o;
wire [1:0] q0_lane0_cur_disp_o;
wire q0_lane1_align_link;
wire q0_lane1_k_lock;
wire [1:0] q0_lane1_disp_err_o;
wire [1:0] q0_lane1_dec_err_o;
wire [1:0] q0_lane1_cur_disp_o;
wire q0_lane2_align_link;
wire q0_lane2_k_lock;
wire [1:0] q0_lane2_disp_err_o;
wire [1:0] q0_lane2_dec_err_o;
wire [1:0] q0_lane2_cur_disp_o;
wire q0_lane3_align_link;
wire q0_lane3_k_lock;
wire [1:0] q0_lane3_disp_err_o;
wire [1:0] q0_lane3_dec_err_o;
wire [1:0] q0_lane3_cur_disp_o;
wire q0_lane0_pcs_rx_o_fabric_clk;
wire q0_lane1_pcs_rx_o_fabric_clk;
wire q0_lane2_pcs_rx_o_fabric_clk;
wire q0_lane3_pcs_rx_o_fabric_clk;
wire q0_lane0_pcs_tx_o_fabric_clk;
wire q0_lane1_pcs_tx_o_fabric_clk;
wire q0_lane2_pcs_tx_o_fabric_clk;
wire q0_lane3_pcs_tx_o_fabric_clk;
wire q0_fabric_cmu0_clk;
wire q0_fabric_cmu1_clk;
wire q0_fabric_quad_clk_rx;
wire [4:0] q0_lane0_rx_if_fifo_rdusewd;
wire q0_lane0_rx_if_fifo_aempty;
wire q0_lane0_rx_if_fifo_empty;
wire [4:0] q0_lane1_rx_if_fifo_rdusewd;
wire q0_lane1_rx_if_fifo_aempty;
wire q0_lane1_rx_if_fifo_empty;
wire [4:0] q0_lane2_rx_if_fifo_rdusewd;
wire q0_lane2_rx_if_fifo_aempty;
wire q0_lane2_rx_if_fifo_empty;
wire [4:0] q0_lane3_rx_if_fifo_rdusewd;
wire q0_lane3_rx_if_fifo_aempty;
wire q0_lane3_rx_if_fifo_empty;
wire [4:0] q0_lane0_tx_if_fifo_wrusewd;
wire q0_lane0_tx_if_fifo_afull;
wire q0_lane0_tx_if_fifo_full;
wire [4:0] q0_lane1_tx_if_fifo_wrusewd;
wire q0_lane1_tx_if_fifo_afull;
wire q0_lane1_tx_if_fifo_full;
wire [4:0] q0_lane2_tx_if_fifo_wrusewd;
wire q0_lane2_tx_if_fifo_afull;
wire q0_lane2_tx_if_fifo_full;
wire [4:0] q0_lane3_tx_if_fifo_wrusewd;
wire q0_lane3_tx_if_fifo_afull;
wire q0_lane3_tx_if_fifo_full;
wire q0_fabric_clk_mon_o;
wire q0_fabric_gearfifo_err_rpt;
wire q0_fabric_ln0_rx_vld_out;
wire q0_fabric_ln0_rxelecidle_o;
wire q0_fabric_ln0_rxelecidle_o_h;
wire [12:0] q0_fabric_ln0_stat_o_h;
wire q0_fabric_ln1_rx_vld_out;
wire q0_fabric_ln1_rxelecidle_o;
wire q0_fabric_ln1_rxelecidle_o_h;
wire [12:0] q0_fabric_ln1_stat_o_h;
wire q0_fabric_ln2_rx_vld_out;
wire q0_fabric_ln2_rxelecidle_o;
wire q0_fabric_ln2_rxelecidle_o_h;
wire [12:0] q0_fabric_ln2_stat_o_h;
wire q0_fabric_ln3_rx_vld_out;
wire q0_fabric_ln3_rxelecidle_o;
wire q0_fabric_ln3_rxelecidle_o_h;
wire [12:0] q0_fabric_ln3_stat_o_h;
wire q0_fabric_lane0_cmu_ok_o;
wire q0_fabric_lane1_cmu_ok_o;
wire q0_fabric_lane2_cmu_ok_o;
wire q0_fabric_lane3_cmu_ok_o;
wire upar_rst;
wire upar_wren_s;
wire [23:0] upar_addr_s;
wire [31:0] upar_wrdata_s;
wire upar_rden_s;
wire [7:0] upar_strb_s;
wire upar_bus_width_s;
wire [5466:0] inet_upar_pmac;
wire [420:0] inet_upar_q0;
wire [420:0] inet_upar_q1;
wire [1328:0] inet_upar_test;
wire csr_tdo;
wire [31:0] upar_rddata_s;
wire upar_rdvld_s;
wire upar_ready_s;
wire spi_miso;
wire ahb_clk_o;
wire tl_clkp_i;
wire [23:0] upar_arbiter_wrap_SerDes_Top_inst_drp_addr_i;
wire [0:0] upar_arbiter_wrap_SerDes_Top_inst_drp_wren_i;
wire [31:0] upar_arbiter_wrap_SerDes_Top_inst_drp_wrdata_i;
wire [7:0] upar_arbiter_wrap_SerDes_Top_inst_drp_strb_i;
wire [0:0] upar_arbiter_wrap_SerDes_Top_inst_drp_rden_i;
wire [7:0] upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o;
wire [7:0] upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o;
wire [7:0] upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o;
wire [255:0] upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o;
wire [7:0] upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o;
wire PCIE_Controller_Top_pcie_tl_rx_sop_i;
wire PCIE_Controller_Top_pcie_tl_rx_eop_i;
wire [255:0] PCIE_Controller_Top_pcie_tl_rx_data_i;
wire [7:0] PCIE_Controller_Top_pcie_tl_rx_valid_i;
wire [5:0] PCIE_Controller_Top_pcie_tl_rx_bardec_i;
wire [7:0] PCIE_Controller_Top_pcie_tl_rx_err_i;
wire PCIE_Controller_Top_pcie_tl_tx_wait_i;
wire PCIE_Controller_Top_pcie_tl_int_ack_i;
wire [95:0] PCIE_Controller_Top_pcie_tl_tx_credits_i;
wire [31:0] PCIE_Controller_Top_pcie_pl_test_out_i;
wire [12:0] PCIE_Controller_Top_pcie_tl_cfg_busdev_i;
wire [127:0] PCIE_Controller_Top_fabric_pl_txdata;
wire [127:0] PCIE_Controller_Top_fabric_pl_txdata_h;
wire [15:0] PCIE_Controller_Top_fabric_pl_txdatak;
wire [15:0] PCIE_Controller_Top_fabric_pl_txdatak_h;
wire [7:0] PCIE_Controller_Top_fabric_pl_txdatavalid;
wire [7:0] PCIE_Controller_Top_fabric_pl_txdatavalid_h;
wire [1:0] PCIE_Controller_Top_fabric_pl_rate;
wire [1:0] PCIE_Controller_Top_fabric_pl_rate_h;
wire PCIE_Controller_Top_pcie_tl_rx_wait_o;
wire PCIE_Controller_Top_pcie_tl_rx_masknp_o;
wire PCIE_Controller_Top_pcie_tl_tx_sop_o;
wire PCIE_Controller_Top_pcie_tl_tx_eop_o;
wire [255:0] PCIE_Controller_Top_pcie_tl_tx_data_o;
wire [7:0] PCIE_Controller_Top_pcie_tl_tx_valid_o;
wire PCIE_Controller_Top_pcie_tl_int_status_o;
wire PCIE_Controller_Top_pcie_tl_int_req_o;
wire [4:0] PCIE_Controller_Top_pcie_tl_int_msinum_o;
wire PCIE_Controller_Top_pcie_pmac_rstn_o;
wire [21:0] PCIE_Controller_Top_pcie_tl_clk_freq_o;
wire [31:0] PCIE_Controller_Top_pcie_tl_tx_prot_o;
wire [7:0] PCIE_Controller_Top_pcie_tl_brsw_in_o;
wire [3:0] PCIE_Controller_Top_pcie_tl_pm_obffcontrol_o;
wire PCIE_Controller_Top_pcie_VCC;
wire PCIE_Controller_Top_pcie_GND;
wire [531:0] inet_pmac_q0;
wire [531:0] inet_pmac_q1;
wire [780:0] inet_pmac_test;
wire [5466:0] inet_pmac_upar;
wire [3:0] pl_exit;
wire [64:0] tl_flr_req0;
wire [64:0] tl_flr_req1;
wire [64:0] tl_flr_req2;
wire [64:0] tl_flr_req3;
wire pl_wake_oen;
wire pl_clkreq_oen;
wire [31:0] tl_rx_prot0;
wire [13:0] tl_rx_bardec0_w;
wire [15:0] tl_rx_mchit0;
wire [31:0] tl_tx_proterr0;
wire [7:0] tl_brsw_out;
wire tl_int_ack1;
wire tl_int_ack2;
wire tl_int_ack3;
wire [3:0] tl_int_pinstate;
wire [3:0] tl_pm_clkstatus;
wire tl_pm_tostatus;
wire [3:0] tl_pm_obffstatus;
wire [7:0] tl_report_event;
wire [3:0] tl_report_timer;
wire [7:0] fabric_phy_invalidreq;
wire [7:0] fabric_phy_invalidreq_h;
wire [7:0] fabric_phy_reqlocal;
wire [7:0] fabric_phy_reqlocal_h;
wire [31:0] fabric_phy_reqlocalidx;
wire [31:0] fabric_phy_reqlocalidx_h;
wire [7:0] fabric_phy_rxeqeval;
wire [7:0] fabric_phy_rxeqeval_h;
wire [7:0] fabric_phy_rxeqinprogress;
wire [7:0] fabric_phy_rxeqinprogress_h;
wire [23:0] fabric_phy_rxprehint;
wire [23:0] fabric_phy_rxprehint_h;
wire [15:0] fabric_phy_txdeemph;
wire [15:0] fabric_phy_txdeemph_h;
wire fabric_pl_blockaligncontrol;
wire fabric_pl_blockaligncontrol_h;
wire [1:0] fabric_pl_powerdown;
wire [1:0] fabric_pl_powerdown_h;
wire [7:0] fabric_pl_rxpolarity;
wire [7:0] fabric_pl_rxpolarity_h;
wire [7:0] fabric_pl_rxstandby;
wire [7:0] fabric_pl_rxstandby_h;
wire [7:0] fabric_pl_txcompliance;
wire [7:0] fabric_pl_txcompliance_h;
wire [7:0] fabric_pl_txdetectrx;
wire [7:0] fabric_pl_txdetectrx_h;
wire [7:0] fabric_pl_txelecidle;
wire [7:0] fabric_pl_txelecidle_h;
wire [2:0] fabric_pl_txmargin;
wire [2:0] fabric_pl_txmargin_h;
wire [7:0] fabric_pl_txstartblock;
wire [7:0] fabric_pl_txstartblock_h;
wire fabric_pl_txswing;
wire fabric_pl_txswing_h;
wire [15:0] fabric_pl_txsyncheader;
wire [15:0] fabric_pl_txsyncheader_h;
wire [1:0] fabric_pl_width;
wire [1:0] fabric_pl_width_h;
wire [18:0] tl_cfgexpaddr0;
wire [18:0] tl_cfgexpaddr1;
wire [18:0] tl_cfgexpaddr2;
wire [18:0] tl_cfgexpaddr3;
wire tl_cfgexpread0;
wire tl_cfgexpread1;
wire tl_cfgexpread2;
wire tl_cfgexpread3;
wire [3:0] tl_cfgexpstrb0;
wire [3:0] tl_cfgexpstrb1;
wire [3:0] tl_cfgexpstrb2;
wire [3:0] tl_cfgexpstrb3;
wire [31:0] tl_cfgexpwdata0;
wire [31:0] tl_cfgexpwdata1;
wire [31:0] tl_cfgexpwdata2;
wire [31:0] tl_cfgexpwdata3;
wire tl_cfgexpwrite0;
wire tl_cfgexpwrite1;
wire tl_cfgexpwrite2;
wire tl_cfgexpwrite3;
wire gw_vcc;
wire gw_gnd;


assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;

GTR12_QUAD gtr12_quad_inst0 (
    .LN0_TXM_O(q0_ln0_txm_o),
    .LN0_TXP_O(q0_ln0_txp_o),
    .LN1_TXM_O(q0_ln1_txm_o),
    .LN1_TXP_O(q0_ln1_txp_o),
    .LN2_TXM_O(q0_ln2_txm_o),
    .LN2_TXP_O(q0_ln2_txp_o),
    .LN3_TXM_O(q0_ln3_txm_o),
    .LN3_TXP_O(q0_ln3_txp_o),
    .FABRIC_LN0_RXDET_RESULT(q0_fabric_ln0_rxdet_result),
    .FABRIC_LN1_RXDET_RESULT(q0_fabric_ln1_rxdet_result),
    .FABRIC_LN2_RXDET_RESULT(q0_fabric_ln2_rxdet_result),
    .FABRIC_LN3_RXDET_RESULT(q0_fabric_ln3_rxdet_result),
    .FABRIC_PMA_CM0_DR_REFCLK_DET_O(q0_fabric_pma_cm0_dr_refclk_det_o),
    .FABRIC_PMA_CM1_DR_REFCLK_DET_O(q0_fabric_pma_cm1_dr_refclk_det_o),
    .FABRIC_CM1_LIFE_CLK_O(q0_fabric_cm1_life_clk_o),
    .FABRIC_CM_LIFE_CLK_O(q0_fabric_cm_life_clk_o),
    .FABRIC_CMU1_CK_REF_O(q0_fabric_cmu1_ck_ref_o),
    .FABRIC_CMU1_OK_O(q0_fabric_cmu1_ok_o),
    .FABRIC_CMU1_REFCLK_GATE_ACK_O(q0_fabric_cmu1_refclk_gate_ack_o),
    .FABRIC_CMU_CK_REF_O(q0_fabric_cmu_ck_ref_o),
    .FABRIC_CMU_OK_O(q0_fabric_cmu_ok_o),
    .FABRIC_CMU_REFCLK_GATE_ACK_O(q0_fabric_cmu_refclk_gate_ack_o),
    .FABRIC_LANE0_CMU_CK_REF_O(q0_fabric_lane0_cmu_ck_ref_o),
    .FABRIC_LANE1_CMU_CK_REF_O(q0_fabric_lane1_cmu_ck_ref_o),
    .FABRIC_LANE2_CMU_CK_REF_O(q0_fabric_lane2_cmu_ck_ref_o),
    .FABRIC_LANE3_CMU_CK_REF_O(q0_fabric_lane3_cmu_ck_ref_o),
    .FABRIC_LN0_ASTAT_O(q0_fabric_ln0_astat_o),
    .FABRIC_LN0_BURN_IN_TOGGLE_O(q0_fabric_ln0_burn_in_toggle_o),
    .FABRIC_LN0_PMA_RX_LOCK_O(q0_fabric_ln0_pma_rx_lock_o),
    .FABRIC_LN0_RXDATA_O(q0_fabric_ln0_rxdata_o),
    .FABRIC_LN0_STAT_O(q0_fabric_ln0_stat_o),
    .FABRIC_LN1_ASTAT_O(q0_fabric_ln1_astat_o),
    .FABRIC_LN1_BURN_IN_TOGGLE_O(q0_fabric_ln1_burn_in_toggle_o),
    .FABRIC_LN1_PMA_RX_LOCK_O(q0_fabric_ln1_pma_rx_lock_o),
    .FABRIC_LN1_RXDATA_O(q0_fabric_ln1_rxdata_o),
    .FABRIC_LN1_STAT_O(q0_fabric_ln1_stat_o),
    .FABRIC_LN2_ASTAT_O(q0_fabric_ln2_astat_o),
    .FABRIC_LN2_BURN_IN_TOGGLE_O(q0_fabric_ln2_burn_in_toggle_o),
    .FABRIC_LN2_PMA_RX_LOCK_O(q0_fabric_ln2_pma_rx_lock_o),
    .FABRIC_LN2_RXDATA_O(q0_fabric_ln2_rxdata_o),
    .FABRIC_LN2_STAT_O(q0_fabric_ln2_stat_o),
    .FABRIC_LN3_ASTAT_O(q0_fabric_ln3_astat_o),
    .FABRIC_LN3_BURN_IN_TOGGLE_O(q0_fabric_ln3_burn_in_toggle_o),
    .FABRIC_LN3_PMA_RX_LOCK_O(q0_fabric_ln3_pma_rx_lock_o),
    .FABRIC_LN3_RXDATA_O(q0_fabric_ln3_rxdata_o),
    .FABRIC_LN3_STAT_O(q0_fabric_ln3_stat_o),
    .FABRIC_REFCLK_GATE_ACK_O(q0_fabric_refclk_gate_ack_o),
    .LANE0_ALIGN_LINK(q0_lane0_align_link),
    .LANE0_K_LOCK(q0_lane0_k_lock),
    .LANE0_DISP_ERR_O(q0_lane0_disp_err_o),
    .LANE0_DEC_ERR_O(q0_lane0_dec_err_o),
    .LANE0_CUR_DISP_O(q0_lane0_cur_disp_o),
    .LANE1_ALIGN_LINK(q0_lane1_align_link),
    .LANE1_K_LOCK(q0_lane1_k_lock),
    .LANE1_DISP_ERR_O(q0_lane1_disp_err_o),
    .LANE1_DEC_ERR_O(q0_lane1_dec_err_o),
    .LANE1_CUR_DISP_O(q0_lane1_cur_disp_o),
    .LANE2_ALIGN_LINK(q0_lane2_align_link),
    .LANE2_K_LOCK(q0_lane2_k_lock),
    .LANE2_DISP_ERR_O(q0_lane2_disp_err_o),
    .LANE2_DEC_ERR_O(q0_lane2_dec_err_o),
    .LANE2_CUR_DISP_O(q0_lane2_cur_disp_o),
    .LANE3_ALIGN_LINK(q0_lane3_align_link),
    .LANE3_K_LOCK(q0_lane3_k_lock),
    .LANE3_DISP_ERR_O(q0_lane3_disp_err_o),
    .LANE3_DEC_ERR_O(q0_lane3_dec_err_o),
    .LANE3_CUR_DISP_O(q0_lane3_cur_disp_o),
    .LANE0_PCS_RX_O_FABRIC_CLK(q0_lane0_pcs_rx_o_fabric_clk),
    .LANE1_PCS_RX_O_FABRIC_CLK(q0_lane1_pcs_rx_o_fabric_clk),
    .LANE2_PCS_RX_O_FABRIC_CLK(q0_lane2_pcs_rx_o_fabric_clk),
    .LANE3_PCS_RX_O_FABRIC_CLK(q0_lane3_pcs_rx_o_fabric_clk),
    .LANE0_PCS_TX_O_FABRIC_CLK(q0_lane0_pcs_tx_o_fabric_clk),
    .LANE1_PCS_TX_O_FABRIC_CLK(q0_lane1_pcs_tx_o_fabric_clk),
    .LANE2_PCS_TX_O_FABRIC_CLK(q0_lane2_pcs_tx_o_fabric_clk),
    .LANE3_PCS_TX_O_FABRIC_CLK(q0_lane3_pcs_tx_o_fabric_clk),
    .FABRIC_CMU0_CLK(q0_fabric_cmu0_clk),
    .FABRIC_CMU1_CLK(q0_fabric_cmu1_clk),
    .FABRIC_QUAD_CLK_RX(q0_fabric_quad_clk_rx),
    .LANE0_RX_IF_FIFO_RDUSEWD(q0_lane0_rx_if_fifo_rdusewd),
    .LANE0_RX_IF_FIFO_AEMPTY(q0_lane0_rx_if_fifo_aempty),
    .LANE0_RX_IF_FIFO_EMPTY(q0_lane0_rx_if_fifo_empty),
    .LANE1_RX_IF_FIFO_RDUSEWD(q0_lane1_rx_if_fifo_rdusewd),
    .LANE1_RX_IF_FIFO_AEMPTY(q0_lane1_rx_if_fifo_aempty),
    .LANE1_RX_IF_FIFO_EMPTY(q0_lane1_rx_if_fifo_empty),
    .LANE2_RX_IF_FIFO_RDUSEWD(q0_lane2_rx_if_fifo_rdusewd),
    .LANE2_RX_IF_FIFO_AEMPTY(q0_lane2_rx_if_fifo_aempty),
    .LANE2_RX_IF_FIFO_EMPTY(q0_lane2_rx_if_fifo_empty),
    .LANE3_RX_IF_FIFO_RDUSEWD(q0_lane3_rx_if_fifo_rdusewd),
    .LANE3_RX_IF_FIFO_AEMPTY(q0_lane3_rx_if_fifo_aempty),
    .LANE3_RX_IF_FIFO_EMPTY(q0_lane3_rx_if_fifo_empty),
    .LANE0_TX_IF_FIFO_WRUSEWD(q0_lane0_tx_if_fifo_wrusewd),
    .LANE0_TX_IF_FIFO_AFULL(q0_lane0_tx_if_fifo_afull),
    .LANE0_TX_IF_FIFO_FULL(q0_lane0_tx_if_fifo_full),
    .LANE1_TX_IF_FIFO_WRUSEWD(q0_lane1_tx_if_fifo_wrusewd),
    .LANE1_TX_IF_FIFO_AFULL(q0_lane1_tx_if_fifo_afull),
    .LANE1_TX_IF_FIFO_FULL(q0_lane1_tx_if_fifo_full),
    .LANE2_TX_IF_FIFO_WRUSEWD(q0_lane2_tx_if_fifo_wrusewd),
    .LANE2_TX_IF_FIFO_AFULL(q0_lane2_tx_if_fifo_afull),
    .LANE2_TX_IF_FIFO_FULL(q0_lane2_tx_if_fifo_full),
    .LANE3_TX_IF_FIFO_WRUSEWD(q0_lane3_tx_if_fifo_wrusewd),
    .LANE3_TX_IF_FIFO_AFULL(q0_lane3_tx_if_fifo_afull),
    .LANE3_TX_IF_FIFO_FULL(q0_lane3_tx_if_fifo_full),
    .FABRIC_CLK_MON_O(q0_fabric_clk_mon_o),
    .FABRIC_GEARFIFO_ERR_RPT(q0_fabric_gearfifo_err_rpt),
    .FABRIC_LN0_RX_VLD_OUT(q0_fabric_ln0_rx_vld_out),
    .FABRIC_LN0_RXELECIDLE_O(q0_fabric_ln0_rxelecidle_o),
    .FABRIC_LN0_RXELECIDLE_O_H(q0_fabric_ln0_rxelecidle_o_h),
    .FABRIC_LN0_STAT_O_H(q0_fabric_ln0_stat_o_h),
    .FABRIC_LN1_RX_VLD_OUT(q0_fabric_ln1_rx_vld_out),
    .FABRIC_LN1_RXELECIDLE_O(q0_fabric_ln1_rxelecidle_o),
    .FABRIC_LN1_RXELECIDLE_O_H(q0_fabric_ln1_rxelecidle_o_h),
    .FABRIC_LN1_STAT_O_H(q0_fabric_ln1_stat_o_h),
    .FABRIC_LN2_RX_VLD_OUT(q0_fabric_ln2_rx_vld_out),
    .FABRIC_LN2_RXELECIDLE_O(q0_fabric_ln2_rxelecidle_o),
    .FABRIC_LN2_RXELECIDLE_O_H(q0_fabric_ln2_rxelecidle_o_h),
    .FABRIC_LN2_STAT_O_H(q0_fabric_ln2_stat_o_h),
    .FABRIC_LN3_RX_VLD_OUT(q0_fabric_ln3_rx_vld_out),
    .FABRIC_LN3_RXELECIDLE_O(q0_fabric_ln3_rxelecidle_o),
    .FABRIC_LN3_RXELECIDLE_O_H(q0_fabric_ln3_rxelecidle_o_h),
    .FABRIC_LN3_STAT_O_H(q0_fabric_ln3_stat_o_h),
    .FABRIC_LANE0_CMU_OK_O(q0_fabric_lane0_cmu_ok_o),
    .FABRIC_LANE1_CMU_OK_O(q0_fabric_lane1_cmu_ok_o),
    .FABRIC_LANE2_CMU_OK_O(q0_fabric_lane2_cmu_ok_o),
    .FABRIC_LANE3_CMU_OK_O(q0_fabric_lane3_cmu_ok_o),
    .INET_Q0_Q1(q0_inet_q0_q1),
    .INET_Q_PMAC(q0_inet_q_pmac),
    .INET_Q_TEST(q0_inet_q_test),
    .INET_Q_UPAR(q0_inet_q_upar),
    .LN0_RXM_I(gw_gnd),
    .LN0_RXP_I(gw_gnd),
    .LN1_RXM_I(gw_gnd),
    .LN1_RXP_I(gw_gnd),
    .LN2_RXM_I(gw_gnd),
    .LN2_RXP_I(gw_gnd),
    .LN3_RXM_I(gw_gnd),
    .LN3_RXP_I(gw_gnd),
    .FABRIC_CLK_LIFE_DIV_I({gw_gnd,gw_gnd}),
    .FABRIC_CM0_RXCLK_OE_L_I(gw_gnd),
    .FABRIC_CM0_RXCLK_OE_R_I(gw_gnd),
    .FABRIC_PMA_PD_REFHCLK_I(gw_gnd),
    .FABRIC_REFCLK1_INPUT_SEL_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_REFCLK_INPUT_SEL_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_REFCLK_OE_L_I(gw_gnd),
    .FABRIC_REFCLK_OE_R_I(gw_gnd),
    .FABRIC_REFCLK_OUTPUT_SEL_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .REFCLKM0_I(gw_gnd),
    .REFCLKM1_I(gw_gnd),
    .REFCLKP0_I(gw_gnd),
    .REFCLKP1_I(gw_gnd),
    .FABRIC_BURN_IN_I(gw_gnd),
    .FABRIC_CK_SOC_DIV_I({gw_gnd,gw_gnd}),
    .FABRIC_CLK_REF_CORE_I(gw_gnd),
    .FABRIC_CMU1_REFCLK_GATE_I(gw_gnd),
    .FABRIC_CMU_REFCLK_GATE_I(gw_gnd),
    .FABRIC_GLUE_MAC_INIT_INFO_I(gw_gnd),
    .FABRIC_LN0_CTRL_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN0_IDDQ_I(gw_gnd),
    .FABRIC_LN0_PD_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN0_RATE_I({gw_gnd,gw_gnd}),
    .FABRIC_LN0_RSTN_I(gw_gnd),
    .FABRIC_LN0_TXDATA_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN1_CTRL_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN1_IDDQ_I(gw_gnd),
    .FABRIC_LN1_PD_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN1_RATE_I({gw_gnd,gw_gnd}),
    .FABRIC_LN1_RSTN_I(gw_gnd),
    .FABRIC_LN1_TXDATA_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN2_CTRL_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN2_IDDQ_I(gw_gnd),
    .FABRIC_LN2_PD_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN2_RATE_I({gw_gnd,gw_gnd}),
    .FABRIC_LN2_RSTN_I(gw_gnd),
    .FABRIC_LN2_TXDATA_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN3_CTRL_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN3_IDDQ_I(gw_gnd),
    .FABRIC_LN3_PD_I({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN3_RATE_I({gw_gnd,gw_gnd}),
    .FABRIC_LN3_RSTN_I(gw_gnd),
    .FABRIC_LN3_TXDATA_I({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_REFCLK_GATE_I(gw_gnd),
    .LANE0_PCS_RX_RST(gw_gnd),
    .LANE1_PCS_RX_RST(gw_gnd),
    .LANE2_PCS_RX_RST(gw_gnd),
    .LANE3_PCS_RX_RST(gw_gnd),
    .LANE0_ALIGN_TRIGGER(gw_gnd),
    .LANE1_ALIGN_TRIGGER(gw_gnd),
    .LANE2_ALIGN_TRIGGER(gw_gnd),
    .LANE3_ALIGN_TRIGGER(gw_gnd),
    .LANE0_CHBOND_START(gw_gnd),
    .LANE1_CHBOND_START(gw_gnd),
    .LANE2_CHBOND_START(gw_gnd),
    .LANE3_CHBOND_START(gw_gnd),
    .LANE0_PCS_TX_RST(gw_gnd),
    .LANE1_PCS_TX_RST(gw_gnd),
    .LANE2_PCS_TX_RST(gw_gnd),
    .LANE3_PCS_TX_RST(gw_gnd),
    .LANE0_FABRIC_RX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE1_FABRIC_RX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE2_FABRIC_RX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE3_FABRIC_RX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE0_FABRIC_C2I_CLK(gw_gnd),
    .LANE1_FABRIC_C2I_CLK(gw_gnd),
    .LANE2_FABRIC_C2I_CLK(gw_gnd),
    .LANE3_FABRIC_C2I_CLK(gw_gnd),
    .LANE0_FABRIC_TX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE1_FABRIC_TX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE2_FABRIC_TX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE3_FABRIC_TX_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .LANE0_RX_IF_FIFO_RDEN(gw_gnd),
    .LANE1_RX_IF_FIFO_RDEN(gw_gnd),
    .LANE2_RX_IF_FIFO_RDEN(gw_gnd),
    .LANE3_RX_IF_FIFO_RDEN(gw_gnd),
    .FABRIC_CMU0_RESETN_I(gw_gnd),
    .FABRIC_CMU0_PD_I(gw_gnd),
    .FABRIC_CMU0_IDDQ_I(gw_gnd),
    .FABRIC_CMU1_RESETN_I(gw_gnd),
    .FABRIC_CMU1_PD_I(gw_gnd),
    .FABRIC_CMU1_IDDQ_I(gw_gnd),
    .FABRIC_PLL_CDN_I(gw_gnd),
    .FABRIC_LN0_CPLL_RESETN_I(gw_gnd),
    .FABRIC_LN0_CPLL_PD_I(gw_gnd),
    .FABRIC_LN0_CPLL_IDDQ_I(gw_gnd),
    .FABRIC_LN1_CPLL_RESETN_I(gw_gnd),
    .FABRIC_LN1_CPLL_PD_I(gw_gnd),
    .FABRIC_LN1_CPLL_IDDQ_I(gw_gnd),
    .FABRIC_LN2_CPLL_RESETN_I(gw_gnd),
    .FABRIC_LN2_CPLL_PD_I(gw_gnd),
    .FABRIC_LN2_CPLL_IDDQ_I(gw_gnd),
    .FABRIC_LN3_CPLL_RESETN_I(gw_gnd),
    .FABRIC_LN3_CPLL_PD_I(gw_gnd),
    .FABRIC_LN3_CPLL_IDDQ_I(gw_gnd),
    .FABRIC_CM1_PD_REFCLK_DET_I(gw_gnd),
    .FABRIC_CM0_PD_REFCLK_DET_I(gw_gnd),
    .FABRIC_LN0_CTRL_I_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN0_PD_I_H({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN0_RATE_I_H({gw_gnd,gw_gnd}),
    .FABRIC_LN0_TX_VLD_IN(gw_gnd),
    .FABRIC_LN1_CTRL_I_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN1_PD_I_H({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN1_RATE_I_H({gw_gnd,gw_gnd}),
    .FABRIC_LN1_TX_VLD_IN(gw_gnd),
    .FABRIC_LN2_CTRL_I_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN2_PD_I_H({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN2_RATE_I_H({gw_gnd,gw_gnd}),
    .FABRIC_LN2_TX_VLD_IN(gw_gnd),
    .FABRIC_LN3_CTRL_I_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN3_PD_I_H({gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_LN3_RATE_I_H({gw_gnd,gw_gnd}),
    .FABRIC_LN3_TX_VLD_IN(gw_gnd),
    .FABRIC_POR_N_I(gw_gnd),
    .FABRIC_QUAD_MCU_REQ_I(gw_gnd),
    .CK_AHB_I(PCIE_Controller_Top_pcie_tl_clk_o),
    .AHB_RSTN(q0_ahb_rstn),
    .TEST_DEC_EN(q0_test_dec_en),
    .QUAD_PCIE_CLK(q0_quad_pcie_clk),
    .PCIE_DIV2_REG(q0_pcie_div2_reg),
    .PCIE_DIV4_REG(q0_pcie_div4_reg),
    .PMAC_LN_RSTN(q0_pmac_ln_rstn)
);

defparam gtr12_quad_inst0.POSITION = "Q0";

GTR12_UPAR gtr12_upar_inst (
    .CSR_TDO(csr_tdo),
    .UPAR_RDDATA_S(upar_rddata_s),
    .UPAR_RDVLD_S(upar_rdvld_s),
    .UPAR_READY_S(upar_ready_s),
    .SPI_MISO(spi_miso),
    .AHB_CLK_O(ahb_clk_o),
    .QUAD_CFG_TEST_DEC_EN(q0_test_dec_en),
    .AHB_RSTN_O(q0_ahb_rstn),
    .TL_CLKP_I(tl_clkp_i),
    .INET_UPAR_PMAC(inet_upar_pmac),
    .INET_UPAR_Q0(inet_upar_q0),
    .INET_UPAR_Q1(inet_upar_q1),
    .INET_UPAR_TEST(inet_upar_test),
    .CSR_TCK(gw_gnd),
    .CSR_TMS(gw_gnd),
    .CSR_TDI(gw_gnd),
    .UPAR_CLK(PCIE_Controller_Top_pcie_tl_clk_o),
    .UPAR_RST(upar_rst),
    .SPI_CLK(gw_gnd),
    .UPAR_WREN_S(upar_wren_s),
    .UPAR_ADDR_S(upar_addr_s),
    .UPAR_WRDATA_S(upar_wrdata_s),
    .UPAR_RDEN_S(upar_rden_s),
    .UPAR_STRB_S(upar_strb_s),
    .UPAR_BUS_WIDTH_S(upar_bus_width_s),
    .SPI_MOSI(gw_gnd),
    .SPI_SS(gw_gnd),
    .CSR_MODE({gw_vcc,gw_gnd,gw_vcc,gw_gnd,gw_gnd}),
    .FABRIC_DFT_EDT_UPDATE(gw_gnd),
    .FABRIC_DFT_IJTAG_CE(gw_gnd),
    .FABRIC_DFT_IJTAG_RESET(gw_gnd),
    .FABRIC_DFT_IJTAG_SE(gw_gnd),
    .FABRIC_DFT_IJTAG_SEL(gw_gnd),
    .FABRIC_DFT_IJTAG_SI(gw_gnd),
    .FABRIC_DFT_IJTAG_TCK(gw_gnd),
    .FABRIC_DFT_IJTAG_UE(gw_gnd),
    .FABRIC_DFT_PLL_BYPASS_CLK(gw_gnd),
    .FABRIC_DFT_PLL_BYPASS_MODE(gw_gnd),
    .FABRIC_DFT_SCAN_CLK(gw_gnd),
    .FABRIC_DFT_SCAN_EN(gw_gnd),
    .FABRIC_DFT_SCAN_IN0(gw_gnd),
    .FABRIC_DFT_SCAN_IN1(gw_gnd),
    .FABRIC_DFT_SCAN_IN2(gw_gnd),
    .FABRIC_DFT_SCAN_IN3(gw_gnd),
    .FABRIC_DFT_SCAN_IN4(gw_gnd),
    .FABRIC_DFT_SCAN_IN5(gw_gnd),
    .FABRIC_DFT_SCAN_IN6(gw_gnd),
    .FABRIC_DFT_SCAN_RSTN(gw_gnd),
    .FABRIC_DFT_SHIFT_SCAN_EN(gw_gnd)
);

\~upar_arbiter_wrap.SerDes_Top upar_arbiter_wrap_SerDes_Top_inst (
    .drp_clk_o({upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[7],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[6],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[5],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[4],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[3],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[2],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[1],upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[0]}),
    .drp_ready_o({upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[7],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[6],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[5],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[4],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[3],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[2],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[1],upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[0]}),
    .drp_rdvld_o({upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[7],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[6],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[5],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[4],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[3],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[2],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[1],upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[0]}),
    .drp_rddata_o({upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[255:224],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[223:192],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[191:160],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[159:128],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[127:96],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[95:64],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[63:32],upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[31:0]}),
    .drp_resp_o({upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[7],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[6],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[5],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[4],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[3],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[2],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[1],upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[0]}),
    .upar_rst_o(upar_rst),
    .upar_addr_o(upar_addr_s),
    .upar_wren_o(upar_wren_s),
    .upar_wrdata_o(upar_wrdata_s),
    .upar_strb_o(upar_strb_s),
    .upar_rden_o(upar_rden_s),
    .upar_bus_width_o(upar_bus_width_s),
    .drp_addr_i({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,upar_arbiter_wrap_SerDes_Top_inst_drp_addr_i[23:0]}),
    .drp_wren_i({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,upar_arbiter_wrap_SerDes_Top_inst_drp_wren_i[0]}),
    .drp_wrdata_i({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,upar_arbiter_wrap_SerDes_Top_inst_drp_wrdata_i[31:0]}),
    .drp_strb_i({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,upar_arbiter_wrap_SerDes_Top_inst_drp_strb_i[7:0]}),
    .drp_rden_i({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,upar_arbiter_wrap_SerDes_Top_inst_drp_rden_i[0]}),
    .upar_clk_i(PCIE_Controller_Top_pcie_tl_clk_o),
    .upar_ready_i(upar_ready_s),
    .upar_rdvld_i(upar_rdvld_s),
    .upar_rddata_i(upar_rddata_s)
);

PCIE_Controller_Top PCIE_Controller_Top_inst (
    .pcie_tl_rx_sop_o(PCIE_Controller_Top_pcie_tl_rx_sop_o),
    .pcie_tl_rx_eop_o(PCIE_Controller_Top_pcie_tl_rx_eop_o),
    .pcie_tl_rx_data_o(PCIE_Controller_Top_pcie_tl_rx_data_o[255:0]),
    .pcie_tl_rx_valid_o(PCIE_Controller_Top_pcie_tl_rx_valid_o[7:0]),
    .pcie_tl_rx_bardec_o(PCIE_Controller_Top_pcie_tl_rx_bardec_o[5:0]),
    .pcie_tl_rx_err_o(PCIE_Controller_Top_pcie_tl_rx_err_o[7:0]),
    .pcie_tl_tx_wait_o(PCIE_Controller_Top_pcie_tl_tx_wait_o),
    .pcie_tl_int_ack_o(PCIE_Controller_Top_pcie_tl_int_ack_o),
    .pcie_ltssm_o(PCIE_Controller_Top_pcie_ltssm_o[4:0]),
    .pcie_tl_tx_creditsp_o(PCIE_Controller_Top_pcie_tl_tx_creditsp_o[31:0]),
    .pcie_tl_tx_creditsnp_o(PCIE_Controller_Top_pcie_tl_tx_creditsnp_o[31:0]),
    .pcie_tl_tx_creditscpl_o(PCIE_Controller_Top_pcie_tl_tx_creditscpl_o[31:0]),
    .pcie_tl_cfg_busdev_o(PCIE_Controller_Top_pcie_tl_cfg_busdev_o[12:0]),
    .pcie_linkup_o(PCIE_Controller_Top_pcie_linkup_o),
    .pcie_tl_rx_wait_o(PCIE_Controller_Top_pcie_tl_rx_wait_o),
    .pcie_tl_rx_masknp_o(PCIE_Controller_Top_pcie_tl_rx_masknp_o),
    .pcie_tl_tx_sop_o(PCIE_Controller_Top_pcie_tl_tx_sop_o),
    .pcie_tl_tx_eop_o(PCIE_Controller_Top_pcie_tl_tx_eop_o),
    .pcie_tl_tx_data_o(PCIE_Controller_Top_pcie_tl_tx_data_o[255:0]),
    .pcie_tl_tx_valid_o(PCIE_Controller_Top_pcie_tl_tx_valid_o[7:0]),
    .pcie_tl_int_status_o(PCIE_Controller_Top_pcie_tl_int_status_o),
    .pcie_tl_int_req_o(PCIE_Controller_Top_pcie_tl_int_req_o),
    .pcie_tl_int_msinum_o(PCIE_Controller_Top_pcie_tl_int_msinum_o[4:0]),
    .pcie_pmac_rstn_o(PCIE_Controller_Top_pcie_pmac_rstn_o),
    .pcie_tl_clk_freq_o(PCIE_Controller_Top_pcie_tl_clk_freq_o[21:0]),
    .pcie_tl_tx_prot_o(PCIE_Controller_Top_pcie_tl_tx_prot_o[31:0]),
    .pcie_tl_brsw_in_o(PCIE_Controller_Top_pcie_tl_brsw_in_o[7:0]),
    .pcie_tl_pm_obffcontrol_o(PCIE_Controller_Top_pcie_tl_pm_obffcontrol_o[3:0]),
    .pcie_VCC(PCIE_Controller_Top_pcie_VCC),
    .pcie_GND(PCIE_Controller_Top_pcie_GND),
    .pcie_tl_clk_o(PCIE_Controller_Top_pcie_tl_clk_o),
    .pcie_tl_drp_clk_o(PCIE_Controller_Top_pcie_tl_drp_clk_o),
    .pcie_tl_drp_rddata_o(PCIE_Controller_Top_pcie_tl_drp_rddata_o[31:0]),
    .pcie_tl_drp_resp_o(PCIE_Controller_Top_pcie_tl_drp_resp_o),
    .pcie_tl_drp_rd_valid_o(PCIE_Controller_Top_pcie_tl_drp_rd_valid_o),
    .pcie_tl_drp_ready_o(PCIE_Controller_Top_pcie_tl_drp_ready_o),
    .pcie_tl_drp_addr_o(upar_arbiter_wrap_SerDes_Top_inst_drp_addr_i[23:0]),
    .pcie_tl_drp_wrdata_o(upar_arbiter_wrap_SerDes_Top_inst_drp_wrdata_i[31:0]),
    .pcie_tl_drp_wr_o(upar_arbiter_wrap_SerDes_Top_inst_drp_wren_i[0]),
    .pcie_tl_drp_rd_o(upar_arbiter_wrap_SerDes_Top_inst_drp_rden_i[0]),
    .pcie_tl_drp_strb_o(upar_arbiter_wrap_SerDes_Top_inst_drp_strb_i[7:0]),
    .pcie_rstn_i(PCIE_Controller_Top_pcie_rstn_i),
    .pcie_tl_clk_i(PCIE_Controller_Top_pcie_tl_clk_i),
    .pcie_tl_rx_wait_i(PCIE_Controller_Top_pcie_tl_rx_wait_i),
    .pcie_tl_rx_masknp_i(PCIE_Controller_Top_pcie_tl_rx_masknp_i),
    .pcie_tl_tx_sop_i(PCIE_Controller_Top_pcie_tl_tx_sop_i),
    .pcie_tl_tx_eop_i(PCIE_Controller_Top_pcie_tl_tx_eop_i),
    .pcie_tl_tx_data_i(PCIE_Controller_Top_pcie_tl_tx_data_i[255:0]),
    .pcie_tl_tx_valid_i(PCIE_Controller_Top_pcie_tl_tx_valid_i[7:0]),
    .pcie_tl_int_status_i(PCIE_Controller_Top_pcie_tl_int_status_i),
    .pcie_tl_int_req_i(PCIE_Controller_Top_pcie_tl_int_req_i),
    .pcie_tl_int_msinum_i(PCIE_Controller_Top_pcie_tl_int_msinum_i[4:0]),
    .pcie_tl_rx_sop_i(PCIE_Controller_Top_pcie_tl_rx_sop_i),
    .pcie_tl_rx_eop_i(PCIE_Controller_Top_pcie_tl_rx_eop_i),
    .pcie_tl_rx_data_i(PCIE_Controller_Top_pcie_tl_rx_data_i[255:0]),
    .pcie_tl_rx_valid_i(PCIE_Controller_Top_pcie_tl_rx_valid_i[7:0]),
    .pcie_tl_rx_bardec_i(PCIE_Controller_Top_pcie_tl_rx_bardec_i[5:0]),
    .pcie_tl_rx_err_i(PCIE_Controller_Top_pcie_tl_rx_err_i[7:0]),
    .pcie_tl_tx_wait_i(PCIE_Controller_Top_pcie_tl_tx_wait_i),
    .pcie_tl_int_ack_i(PCIE_Controller_Top_pcie_tl_int_ack_i),
    .pcie_tl_tx_credits_i(PCIE_Controller_Top_pcie_tl_tx_credits_i[95:0]),
    .pcie_pl_test_out_i(PCIE_Controller_Top_pcie_pl_test_out_i[31:0]),
    .pcie_tl_cfg_busdev_i(PCIE_Controller_Top_pcie_tl_cfg_busdev_i[12:0]),
    .fabric_pl_rx_det(q0_fabric_ln0_rxdet_result),
    .fabric_ln0_pma_rx_lock(q0_fabric_ln0_pma_rx_lock_o),
    .fabric_ln0_astat(q0_fabric_ln0_astat_o[5:0]),
    .fabric_pl_txdata(PCIE_Controller_Top_fabric_pl_txdata[127:0]),
    .fabric_pl_txdata_h(PCIE_Controller_Top_fabric_pl_txdata_h[127:0]),
    .fabric_pl_txdatak(PCIE_Controller_Top_fabric_pl_txdatak[15:0]),
    .fabric_pl_txdatak_h(PCIE_Controller_Top_fabric_pl_txdatak_h[15:0]),
    .fabric_pl_txdatavalid(PCIE_Controller_Top_fabric_pl_txdatavalid[7:0]),
    .fabric_pl_txdatavalid_h(PCIE_Controller_Top_fabric_pl_txdatavalid_h[7:0]),
    .fabric_ln0_rxdata(q0_fabric_ln0_rxdata_o[87:0]),
    .fabric_ln0_rxdatavalid(q0_fabric_ln0_rx_vld_out),
    .fabric_ln1_rxdata(q0_fabric_ln1_rxdata_o[87:0]),
    .fabric_ln2_rxdata(q0_fabric_ln2_rxdata_o[87:0]),
    .fabric_ln3_rxdata(q0_fabric_ln3_rxdata_o[87:0]),
    .fabric_pl_rate(PCIE_Controller_Top_fabric_pl_rate[1:0]),
    .fabric_pl_rate_h(PCIE_Controller_Top_fabric_pl_rate_h[1:0]),
    .pcie_half_clk_i(PCIE_Controller_Top_pcie_half_clk_i),
    .pcie_tl_drp_addr_i(PCIE_Controller_Top_pcie_tl_drp_addr_i[23:0]),
    .pcie_tl_drp_wrdata_i(PCIE_Controller_Top_pcie_tl_drp_wrdata_i[31:0]),
    .pcie_tl_drp_strb_i(PCIE_Controller_Top_pcie_tl_drp_strb_i[7:0]),
    .pcie_tl_drp_wr_i(PCIE_Controller_Top_pcie_tl_drp_wr_i),
    .pcie_tl_drp_rd_i(PCIE_Controller_Top_pcie_tl_drp_rd_i),
    .pcie_tl_drp_clk_i(upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[0]),
    .pcie_tl_drp_rddata_i(upar_arbiter_wrap_SerDes_Top_inst_drp_rddata_o[31:0]),
    .pcie_tl_drp_rd_valid_i(upar_arbiter_wrap_SerDes_Top_inst_drp_rdvld_o[0]),
    .pcie_tl_drp_ready_i(upar_arbiter_wrap_SerDes_Top_inst_drp_ready_o[0]),
    .pcie_tl_drp_resp_i(upar_arbiter_wrap_SerDes_Top_inst_drp_resp_o[0])
);

GTR12_PMAC gtr12_pmac_inst (
    .PL_EXIT(pl_exit),
    .TL_FLR_REQ0(tl_flr_req0),
    .TL_FLR_REQ1(tl_flr_req1),
    .TL_FLR_REQ2(tl_flr_req2),
    .TL_FLR_REQ3(tl_flr_req3),
    .PL_WAKE_OEN(pl_wake_oen),
    .PL_CLKREQ_OEN(pl_clkreq_oen),
    .TL_RX_SOP0(PCIE_Controller_Top_pcie_tl_rx_sop_i),
    .TL_RX_EOP0(PCIE_Controller_Top_pcie_tl_rx_eop_i),
    .TL_RX_DATA0(PCIE_Controller_Top_pcie_tl_rx_data_i),
    .TL_RX_VALID0(PCIE_Controller_Top_pcie_tl_rx_valid_i),
    .TL_RX_PROT0(tl_rx_prot0),
    .TL_RX_BARDEC0({tl_rx_bardec0_w[13:0],PCIE_Controller_Top_pcie_tl_rx_bardec_i[5:0]}),
    .TL_RX_MCHIT0(tl_rx_mchit0),
    .TL_RX_ERR0(PCIE_Controller_Top_pcie_tl_rx_err_i),
    .TL_TX_WAIT0(PCIE_Controller_Top_pcie_tl_tx_wait_i),
    .TL_TX_CREDITS0(PCIE_Controller_Top_pcie_tl_tx_credits_i),
    .TL_TX_PROTERR0(tl_tx_proterr0),
    .TL_BRSW_OUT(tl_brsw_out),
    .TL_INT_ACK0(PCIE_Controller_Top_pcie_tl_int_ack_i),
    .TL_INT_ACK1(tl_int_ack1),
    .TL_INT_ACK2(tl_int_ack2),
    .TL_INT_ACK3(tl_int_ack3),
    .TL_INT_PINSTATE(tl_int_pinstate),
    .TL_PM_CLKSTATUS(tl_pm_clkstatus),
    .TL_PM_TOSTATUS(tl_pm_tostatus),
    .TL_PM_OBFFSTATUS(tl_pm_obffstatus),
    .TL_REPORT_EVENT(tl_report_event),
    .TL_REPORT_TIMER(tl_report_timer),
    .PCIE_HALF_CLK(PCIE_Controller_Top_pcie_half_clk_i),
    .FABRIC_PHY_INVALIDREQ(fabric_phy_invalidreq),
    .FABRIC_PHY_INVALIDREQ_H(fabric_phy_invalidreq_h),
    .FABRIC_PHY_REQLOCAL(fabric_phy_reqlocal),
    .FABRIC_PHY_REQLOCAL_H(fabric_phy_reqlocal_h),
    .FABRIC_PHY_REQLOCALIDX(fabric_phy_reqlocalidx),
    .FABRIC_PHY_REQLOCALIDX_H(fabric_phy_reqlocalidx_h),
    .FABRIC_PHY_RXEQEVAL(fabric_phy_rxeqeval),
    .FABRIC_PHY_RXEQEVAL_H(fabric_phy_rxeqeval_h),
    .FABRIC_PHY_RXEQINPROGRESS(fabric_phy_rxeqinprogress),
    .FABRIC_PHY_RXEQINPROGRESS_H(fabric_phy_rxeqinprogress_h),
    .FABRIC_PHY_RXPREHINT(fabric_phy_rxprehint),
    .FABRIC_PHY_RXPREHINT_H(fabric_phy_rxprehint_h),
    .FABRIC_PHY_TXDEEMPH(fabric_phy_txdeemph),
    .FABRIC_PHY_TXDEEMPH_H(fabric_phy_txdeemph_h),
    .FABRIC_PL_BLOCKALIGNCONTROL(fabric_pl_blockaligncontrol),
    .FABRIC_PL_BLOCKALIGNCONTROL_H(fabric_pl_blockaligncontrol_h),
    .FABRIC_PL_POWERDOWN(fabric_pl_powerdown),
    .FABRIC_PL_POWERDOWN_H(fabric_pl_powerdown_h),
    .FABRIC_PL_RATE(PCIE_Controller_Top_fabric_pl_rate),
    .FABRIC_PL_RATE_H(PCIE_Controller_Top_fabric_pl_rate_h),
    .FABRIC_PL_RXPOLARITY(fabric_pl_rxpolarity),
    .FABRIC_PL_RXPOLARITY_H(fabric_pl_rxpolarity_h),
    .FABRIC_PL_RXSTANDBY(fabric_pl_rxstandby),
    .FABRIC_PL_RXSTANDBY_H(fabric_pl_rxstandby_h),
    .FABRIC_PL_TXCOMPLIANCE(fabric_pl_txcompliance),
    .FABRIC_PL_TXCOMPLIANCE_H(fabric_pl_txcompliance_h),
    .FABRIC_PL_TXDATA(PCIE_Controller_Top_fabric_pl_txdata),
    .FABRIC_PL_TXDATA_H(PCIE_Controller_Top_fabric_pl_txdata_h),
    .FABRIC_PL_TXDATAK(PCIE_Controller_Top_fabric_pl_txdatak),
    .FABRIC_PL_TXDATAK_H(PCIE_Controller_Top_fabric_pl_txdatak_h),
    .FABRIC_PL_TXDATAVALID(PCIE_Controller_Top_fabric_pl_txdatavalid),
    .FABRIC_PL_TXDATAVALID_H(PCIE_Controller_Top_fabric_pl_txdatavalid_h),
    .FABRIC_PL_TXDETECTRX(fabric_pl_txdetectrx),
    .FABRIC_PL_TXDETECTRX_H(fabric_pl_txdetectrx_h),
    .FABRIC_PL_TXELECIDLE(fabric_pl_txelecidle),
    .FABRIC_PL_TXELECIDLE_H(fabric_pl_txelecidle_h),
    .FABRIC_PL_TXMARGIN(fabric_pl_txmargin),
    .FABRIC_PL_TXMARGIN_H(fabric_pl_txmargin_h),
    .FABRIC_PL_TXSTARTBLOCK(fabric_pl_txstartblock),
    .FABRIC_PL_TXSTARTBLOCK_H(fabric_pl_txstartblock_h),
    .FABRIC_PL_TXSWING(fabric_pl_txswing),
    .FABRIC_PL_TXSWING_H(fabric_pl_txswing_h),
    .FABRIC_PL_TXSYNCHEADER(fabric_pl_txsyncheader),
    .FABRIC_PL_TXSYNCHEADER_H(fabric_pl_txsyncheader_h),
    .FABRIC_PL_WIDTH(fabric_pl_width),
    .FABRIC_PL_WIDTH_H(fabric_pl_width_h),
    .FABRIC_TEST_BUS_MON(PCIE_Controller_Top_pcie_pl_test_out_i),
    .TL_CFGEXPADDR0(tl_cfgexpaddr0),
    .TL_CFGEXPADDR1(tl_cfgexpaddr1),
    .TL_CFGEXPADDR2(tl_cfgexpaddr2),
    .TL_CFGEXPADDR3(tl_cfgexpaddr3),
    .TL_CFGEXPREAD0(tl_cfgexpread0),
    .TL_CFGEXPREAD1(tl_cfgexpread1),
    .TL_CFGEXPREAD2(tl_cfgexpread2),
    .TL_CFGEXPREAD3(tl_cfgexpread3),
    .TL_CFGEXPSTRB0(tl_cfgexpstrb0),
    .TL_CFGEXPSTRB1(tl_cfgexpstrb1),
    .TL_CFGEXPSTRB2(tl_cfgexpstrb2),
    .TL_CFGEXPSTRB3(tl_cfgexpstrb3),
    .TL_CFGEXPWDATA0(tl_cfgexpwdata0),
    .TL_CFGEXPWDATA1(tl_cfgexpwdata1),
    .TL_CFGEXPWDATA2(tl_cfgexpwdata2),
    .TL_CFGEXPWDATA3(tl_cfgexpwdata3),
    .TL_CFGEXPWRITE0(tl_cfgexpwrite0),
    .TL_CFGEXPWRITE1(tl_cfgexpwrite1),
    .TL_CFGEXPWRITE2(tl_cfgexpwrite2),
    .TL_CFGEXPWRITE3(tl_cfgexpwrite3),
    .TLCFG_BUSDEV(PCIE_Controller_Top_pcie_tl_cfg_busdev_i),
    .PCIE_CLK(q0_quad_pcie_clk),
    .PMAC_LN_RSTN(q0_pmac_ln_rstn),
    .PCIE_DIV2_REG(q0_pcie_div2_reg),
    .PCIE_DIV4_REG(q0_pcie_div4_reg),
    .INET_PMAC_Q0(inet_pmac_q0),
    .INET_PMAC_Q1(inet_pmac_q1),
    .INET_PMAC_TEST(inet_pmac_test),
    .INET_PMAC_UPAR(inet_pmac_upar),
    .TL_FLR_ACK0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_FLR_ACK1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_FLR_ACK2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_FLR_ACK3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_CLOCK_FREQ(PCIE_Controller_Top_pcie_tl_clk_freq_o),
    .PL_WAKE_IN(PCIE_Controller_Top_pcie_GND),
    .PL_CLKREQ_IN(PCIE_Controller_Top_pcie_GND),
    .PL_LTSSM_ENABLE(PCIE_Controller_Top_pcie_VCC),
    .TL_RX_MASKNP0(PCIE_Controller_Top_pcie_tl_rx_masknp_o),
    .TL_RX_WAIT0(PCIE_Controller_Top_pcie_tl_rx_wait_o),
    .TL_TX_SOP0(PCIE_Controller_Top_pcie_tl_tx_sop_o),
    .TL_TX_EOP0(PCIE_Controller_Top_pcie_tl_tx_eop_o),
    .TL_TX_DATA0(PCIE_Controller_Top_pcie_tl_tx_data_o),
    .TL_TX_VALID0(PCIE_Controller_Top_pcie_tl_tx_valid_o),
    .TL_TX_PROT0(PCIE_Controller_Top_pcie_tl_tx_prot_o),
    .TL_TX_STREAM0(PCIE_Controller_Top_pcie_GND),
    .TL_TX_ERR0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_TX_PROTACK0(PCIE_Controller_Top_pcie_GND),
    .TL_BRSW_IN(PCIE_Controller_Top_pcie_tl_brsw_in_o),
    .TL_INT_STATUS0(PCIE_Controller_Top_pcie_tl_int_status_o),
    .TL_INT_REQ0(PCIE_Controller_Top_pcie_tl_int_req_o),
    .TL_INT_MSINUM0(PCIE_Controller_Top_pcie_tl_int_msinum_o),
    .TL_INT_VFNUM0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_INT_STATUS1(PCIE_Controller_Top_pcie_GND),
    .TL_INT_REQ1(PCIE_Controller_Top_pcie_GND),
    .TL_INT_MSINUM1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_VFNUM1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_STATUS2(PCIE_Controller_Top_pcie_GND),
    .TL_INT_REQ2(PCIE_Controller_Top_pcie_GND),
    .TL_INT_MSINUM2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_VFNUM2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_STATUS3(PCIE_Controller_Top_pcie_GND),
    .TL_INT_REQ3(PCIE_Controller_Top_pcie_GND),
    .TL_INT_MSINUM3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_VFNUM3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_INT_PINCONTROL({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_PM_EVENT0(PCIE_Controller_Top_pcie_GND),
    .TL_PM_DATA0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_PM_EVENT1(PCIE_Controller_Top_pcie_GND),
    .TL_PM_DATA1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_PM_EVENT2(PCIE_Controller_Top_pcie_GND),
    .TL_PM_DATA2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_PM_EVENT3(PCIE_Controller_Top_pcie_GND),
    .TL_PM_DATA3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_PM_CLKCONTROL(PCIE_Controller_Top_pcie_GND),
    .TL_PM_BWCHANGE({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_PM_TOCONTROL(PCIE_Controller_Top_pcie_GND),
    .TL_PM_AUXPWR(PCIE_Controller_Top_pcie_GND),
    .TL_PM_OBFFCONTROL(PCIE_Controller_Top_pcie_tl_pm_obffcontrol_o),
    .TL_REPORT_ERROR0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_STATE0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_CPLPENDING0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_HEADER0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_ERROR1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_STATE1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_CPLPENDING1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_HEADER1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_ERROR2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_STATE2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_CPLPENDING2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_HEADER2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_ERROR3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_STATE3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_CPLPENDING3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_HEADER3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_HOTPLUG({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .TL_REPORT_LATENCY({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,PCIE_Controller_Top_pcie_GND}),
    .FABRIC_PL_NPOR(PCIE_Controller_Top_pcie_pmac_rstn_o),
    .FABRIC_PL_RSTN(PCIE_Controller_Top_pcie_GND),
    .FABRIC_PL_RSTNP(PCIE_Controller_Top_pcie_GND),
    .FABRIC_PL_SRST(PCIE_Controller_Top_pcie_GND),
    .FABRIC_TL_NPOR(PCIE_Controller_Top_pcie_pmac_rstn_o),
    .FABRIC_TL_RSTN(PCIE_Controller_Top_pcie_GND),
    .FABRIC_TL_RSTNP(PCIE_Controller_Top_pcie_GND),
    .FABRIC_TL_CRSTN(PCIE_Controller_Top_pcie_GND),
    .FABRIC_TL_SRST(PCIE_Controller_Top_pcie_GND),
    .FABRIC_TL_CRST(PCIE_Controller_Top_pcie_GND),
    .FABRIC_PL_PCLK_STOP(gw_gnd),
    .FABRIC_CTRL_GATE_TL_CLK(gw_gnd),
    .FABRIC_PHY_ACKLOCAL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PHY_ACKLOCAL_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_PHYSTATUS({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_PHYSTATUS_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATA_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATAK({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATAK_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATAVALID({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXDATAVALID_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXELECIDLE({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXELECIDLE_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSTARTBLOCK({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSTARTBLOCK_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSTATUS({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSTATUS_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSYNCHEADER({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXSYNCHEADER_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXVALID({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FABRIC_PL_RXVALID_H({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_CFGEXPRDATA0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_CFGEXPRDATA1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_CFGEXPRDATA2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_CFGEXPRDATA3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .TL_CFGEXPVALID0(gw_gnd),
    .TL_CFGEXPVALID1(gw_gnd),
    .TL_CFGEXPVALID2(gw_gnd),
    .TL_CFGEXPVALID3(gw_gnd),
    .TL_CLKP(PCIE_Controller_Top_pcie_tl_clk_o),
    .Q0_CPLL0_OK_I(q0_fabric_lane0_cmu_ok_o),
    .Q0_CPLL1_OK_I(q0_fabric_lane1_cmu_ok_o),
    .Q0_CPLL2_OK_I(q0_fabric_lane2_cmu_ok_o),
    .Q0_CPLL3_OK_I(q0_fabric_lane3_cmu_ok_o),
    .Q1_CPLL0_OK_I(gw_gnd),
    .Q1_CPLL1_OK_I(gw_gnd),
    .Q1_CPLL2_OK_I(gw_gnd),
    .Q1_CPLL3_OK_I(gw_gnd),
    .FABRIC_PCLK_I(PCIE_Controller_Top_pcie_tl_clk_o)
);

endmodule //SerDes_Top
