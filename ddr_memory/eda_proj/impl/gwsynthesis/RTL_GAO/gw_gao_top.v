module gw_gao(
    \u_ddr3/wr_data_rdy ,
    \u_ddr3/wr_data_en ,
    \u_ddr3/rd_data_valid ,
    \u_ddr3/init_calib_complete ,
    \u_ddr3/clk_out ,
    \u_ddr_test/app_rdy ,
    \u_ddr_test/app_en ,
    \u_ddr_test/app_wdf_wren ,
    \u_ddr_test/app_wdf_end ,
    \u_ddr_test/app_burst ,
    \u_ddr_test/app_rd_data_valid ,
    \u_ddr_test/init_calib_complete ,
    \u_ddr_test/wdone ,
    \u_ddr_test/rdone ,
    sys_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \u_ddr3/wr_data_rdy ;
input \u_ddr3/wr_data_en ;
input \u_ddr3/rd_data_valid ;
input \u_ddr3/init_calib_complete ;
input \u_ddr3/clk_out ;
input \u_ddr_test/app_rdy ;
input \u_ddr_test/app_en ;
input \u_ddr_test/app_wdf_wren ;
input \u_ddr_test/app_wdf_end ;
input \u_ddr_test/app_burst ;
input \u_ddr_test/app_rd_data_valid ;
input \u_ddr_test/init_calib_complete ;
input \u_ddr_test/wdone ;
input \u_ddr_test/rdone ;
input sys_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \u_ddr3/wr_data_rdy ;
wire \u_ddr3/wr_data_en ;
wire \u_ddr3/rd_data_valid ;
wire \u_ddr3/init_calib_complete ;
wire \u_ddr3/clk_out ;
wire \u_ddr_test/app_rdy ;
wire \u_ddr_test/app_en ;
wire \u_ddr_test/app_wdf_wren ;
wire \u_ddr_test/app_wdf_end ;
wire \u_ddr_test/app_burst ;
wire \u_ddr_test/app_rd_data_valid ;
wire \u_ddr_test/init_calib_complete ;
wire \u_ddr_test/wdone ;
wire \u_ddr_test/rdone ;
wire sys_clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\u_ddr3/wr_data_rdy ,\u_ddr3/wr_data_en ,\u_ddr3/rd_data_valid ,\u_ddr3/init_calib_complete ,\u_ddr3/clk_out ,\u_ddr_test/app_rdy ,\u_ddr_test/app_en ,\u_ddr_test/app_wdf_wren ,\u_ddr_test/app_wdf_end ,\u_ddr_test/app_burst ,\u_ddr_test/app_rd_data_valid ,\u_ddr_test/init_calib_complete ,\u_ddr_test/wdone ,\u_ddr_test/rdone }),
    .clk_i(sys_clk)
);

endmodule
