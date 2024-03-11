module gw_gao(
    \SDRAM_DQ[15] ,
    \SDRAM_DQ[14] ,
    \SDRAM_DQ[13] ,
    \SDRAM_DQ[12] ,
    \SDRAM_DQ[11] ,
    \SDRAM_DQ[10] ,
    \SDRAM_DQ[9] ,
    \SDRAM_DQ[8] ,
    \SDRAM_DQ[7] ,
    \SDRAM_DQ[6] ,
    \SDRAM_DQ[5] ,
    \SDRAM_DQ[4] ,
    \SDRAM_DQ[3] ,
    \SDRAM_DQ[2] ,
    \SDRAM_DQ[1] ,
    \SDRAM_DQ[0] ,
    \SDRAM_A[12] ,
    \SDRAM_A[11] ,
    \SDRAM_A[10] ,
    \SDRAM_A[9] ,
    \SDRAM_A[8] ,
    \SDRAM_A[7] ,
    \SDRAM_A[6] ,
    \SDRAM_A[5] ,
    \SDRAM_A[4] ,
    \SDRAM_A[3] ,
    \SDRAM_A[2] ,
    \SDRAM_A[1] ,
    \SDRAM_A[0] ,
    \SDRAM_BA[1] ,
    \SDRAM_BA[0] ,
    \SDRAM_DQM[1] ,
    \SDRAM_DQM[0] ,
    \sdram_dout[7] ,
    \sdram_dout[6] ,
    \sdram_dout[5] ,
    \sdram_dout[4] ,
    \sdram_dout[3] ,
    \sdram_dout[2] ,
    \sdram_dout[1] ,
    \sdram_dout[0] ,
    \sdram_din[7] ,
    \sdram_din[6] ,
    \sdram_din[5] ,
    \sdram_din[4] ,
    \sdram_din[3] ,
    \sdram_din[2] ,
    \sdram_din[1] ,
    \sdram_din[0] ,
    \sdram_address[26] ,
    \sdram_address[25] ,
    \sdram_address[24] ,
    \sdram_address[23] ,
    \sdram_address[22] ,
    \sdram_address[21] ,
    \sdram_address[20] ,
    \sdram_address[19] ,
    \sdram_address[18] ,
    \sdram_address[17] ,
    \sdram_address[16] ,
    \sdram_address[15] ,
    \sdram_address[14] ,
    \sdram_address[13] ,
    \sdram_address[12] ,
    \sdram_address[11] ,
    \sdram_address[10] ,
    \sdram_address[9] ,
    \sdram_address[8] ,
    \sdram_address[7] ,
    \sdram_address[6] ,
    \sdram_address[5] ,
    \sdram_address[4] ,
    \sdram_address[3] ,
    \sdram_address[2] ,
    \sdram_address[1] ,
    \sdram_address[0] ,
    led_succeed,
    led_fault,
    sdram_read,
    sdram_write,
    sdram_busy,
    sdram_data_ready,
    data_correct,
    scan_finished,
    SDRAM_CLK,
    clk_66p7m,
    clk_66p7m_shifted,
    clk_266m,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \SDRAM_DQ[15] ;
input \SDRAM_DQ[14] ;
input \SDRAM_DQ[13] ;
input \SDRAM_DQ[12] ;
input \SDRAM_DQ[11] ;
input \SDRAM_DQ[10] ;
input \SDRAM_DQ[9] ;
input \SDRAM_DQ[8] ;
input \SDRAM_DQ[7] ;
input \SDRAM_DQ[6] ;
input \SDRAM_DQ[5] ;
input \SDRAM_DQ[4] ;
input \SDRAM_DQ[3] ;
input \SDRAM_DQ[2] ;
input \SDRAM_DQ[1] ;
input \SDRAM_DQ[0] ;
input \SDRAM_A[12] ;
input \SDRAM_A[11] ;
input \SDRAM_A[10] ;
input \SDRAM_A[9] ;
input \SDRAM_A[8] ;
input \SDRAM_A[7] ;
input \SDRAM_A[6] ;
input \SDRAM_A[5] ;
input \SDRAM_A[4] ;
input \SDRAM_A[3] ;
input \SDRAM_A[2] ;
input \SDRAM_A[1] ;
input \SDRAM_A[0] ;
input \SDRAM_BA[1] ;
input \SDRAM_BA[0] ;
input \SDRAM_DQM[1] ;
input \SDRAM_DQM[0] ;
input \sdram_dout[7] ;
input \sdram_dout[6] ;
input \sdram_dout[5] ;
input \sdram_dout[4] ;
input \sdram_dout[3] ;
input \sdram_dout[2] ;
input \sdram_dout[1] ;
input \sdram_dout[0] ;
input \sdram_din[7] ;
input \sdram_din[6] ;
input \sdram_din[5] ;
input \sdram_din[4] ;
input \sdram_din[3] ;
input \sdram_din[2] ;
input \sdram_din[1] ;
input \sdram_din[0] ;
input \sdram_address[26] ;
input \sdram_address[25] ;
input \sdram_address[24] ;
input \sdram_address[23] ;
input \sdram_address[22] ;
input \sdram_address[21] ;
input \sdram_address[20] ;
input \sdram_address[19] ;
input \sdram_address[18] ;
input \sdram_address[17] ;
input \sdram_address[16] ;
input \sdram_address[15] ;
input \sdram_address[14] ;
input \sdram_address[13] ;
input \sdram_address[12] ;
input \sdram_address[11] ;
input \sdram_address[10] ;
input \sdram_address[9] ;
input \sdram_address[8] ;
input \sdram_address[7] ;
input \sdram_address[6] ;
input \sdram_address[5] ;
input \sdram_address[4] ;
input \sdram_address[3] ;
input \sdram_address[2] ;
input \sdram_address[1] ;
input \sdram_address[0] ;
input led_succeed;
input led_fault;
input sdram_read;
input sdram_write;
input sdram_busy;
input sdram_data_ready;
input data_correct;
input scan_finished;
input SDRAM_CLK;
input clk_66p7m;
input clk_66p7m_shifted;
input clk_266m;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \SDRAM_DQ[15] ;
wire \SDRAM_DQ[14] ;
wire \SDRAM_DQ[13] ;
wire \SDRAM_DQ[12] ;
wire \SDRAM_DQ[11] ;
wire \SDRAM_DQ[10] ;
wire \SDRAM_DQ[9] ;
wire \SDRAM_DQ[8] ;
wire \SDRAM_DQ[7] ;
wire \SDRAM_DQ[6] ;
wire \SDRAM_DQ[5] ;
wire \SDRAM_DQ[4] ;
wire \SDRAM_DQ[3] ;
wire \SDRAM_DQ[2] ;
wire \SDRAM_DQ[1] ;
wire \SDRAM_DQ[0] ;
wire \SDRAM_A[12] ;
wire \SDRAM_A[11] ;
wire \SDRAM_A[10] ;
wire \SDRAM_A[9] ;
wire \SDRAM_A[8] ;
wire \SDRAM_A[7] ;
wire \SDRAM_A[6] ;
wire \SDRAM_A[5] ;
wire \SDRAM_A[4] ;
wire \SDRAM_A[3] ;
wire \SDRAM_A[2] ;
wire \SDRAM_A[1] ;
wire \SDRAM_A[0] ;
wire \SDRAM_BA[1] ;
wire \SDRAM_BA[0] ;
wire \SDRAM_DQM[1] ;
wire \SDRAM_DQM[0] ;
wire \sdram_dout[7] ;
wire \sdram_dout[6] ;
wire \sdram_dout[5] ;
wire \sdram_dout[4] ;
wire \sdram_dout[3] ;
wire \sdram_dout[2] ;
wire \sdram_dout[1] ;
wire \sdram_dout[0] ;
wire \sdram_din[7] ;
wire \sdram_din[6] ;
wire \sdram_din[5] ;
wire \sdram_din[4] ;
wire \sdram_din[3] ;
wire \sdram_din[2] ;
wire \sdram_din[1] ;
wire \sdram_din[0] ;
wire \sdram_address[26] ;
wire \sdram_address[25] ;
wire \sdram_address[24] ;
wire \sdram_address[23] ;
wire \sdram_address[22] ;
wire \sdram_address[21] ;
wire \sdram_address[20] ;
wire \sdram_address[19] ;
wire \sdram_address[18] ;
wire \sdram_address[17] ;
wire \sdram_address[16] ;
wire \sdram_address[15] ;
wire \sdram_address[14] ;
wire \sdram_address[13] ;
wire \sdram_address[12] ;
wire \sdram_address[11] ;
wire \sdram_address[10] ;
wire \sdram_address[9] ;
wire \sdram_address[8] ;
wire \sdram_address[7] ;
wire \sdram_address[6] ;
wire \sdram_address[5] ;
wire \sdram_address[4] ;
wire \sdram_address[3] ;
wire \sdram_address[2] ;
wire \sdram_address[1] ;
wire \sdram_address[0] ;
wire led_succeed;
wire led_fault;
wire sdram_read;
wire sdram_write;
wire sdram_busy;
wire sdram_data_ready;
wire data_correct;
wire scan_finished;
wire SDRAM_CLK;
wire clk_66p7m;
wire clk_66p7m_shifted;
wire clk_266m;
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
    .data_i({\SDRAM_DQ[15] ,\SDRAM_DQ[14] ,\SDRAM_DQ[13] ,\SDRAM_DQ[12] ,\SDRAM_DQ[11] ,\SDRAM_DQ[10] ,\SDRAM_DQ[9] ,\SDRAM_DQ[8] ,\SDRAM_DQ[7] ,\SDRAM_DQ[6] ,\SDRAM_DQ[5] ,\SDRAM_DQ[4] ,\SDRAM_DQ[3] ,\SDRAM_DQ[2] ,\SDRAM_DQ[1] ,\SDRAM_DQ[0] ,\SDRAM_A[12] ,\SDRAM_A[11] ,\SDRAM_A[10] ,\SDRAM_A[9] ,\SDRAM_A[8] ,\SDRAM_A[7] ,\SDRAM_A[6] ,\SDRAM_A[5] ,\SDRAM_A[4] ,\SDRAM_A[3] ,\SDRAM_A[2] ,\SDRAM_A[1] ,\SDRAM_A[0] ,\SDRAM_BA[1] ,\SDRAM_BA[0] ,\SDRAM_DQM[1] ,\SDRAM_DQM[0] ,\sdram_dout[7] ,\sdram_dout[6] ,\sdram_dout[5] ,\sdram_dout[4] ,\sdram_dout[3] ,\sdram_dout[2] ,\sdram_dout[1] ,\sdram_dout[0] ,\sdram_din[7] ,\sdram_din[6] ,\sdram_din[5] ,\sdram_din[4] ,\sdram_din[3] ,\sdram_din[2] ,\sdram_din[1] ,\sdram_din[0] ,\sdram_address[26] ,\sdram_address[25] ,\sdram_address[24] ,\sdram_address[23] ,\sdram_address[22] ,\sdram_address[21] ,\sdram_address[20] ,\sdram_address[19] ,\sdram_address[18] ,\sdram_address[17] ,\sdram_address[16] ,\sdram_address[15] ,\sdram_address[14] ,\sdram_address[13] ,\sdram_address[12] ,\sdram_address[11] ,\sdram_address[10] ,\sdram_address[9] ,\sdram_address[8] ,\sdram_address[7] ,\sdram_address[6] ,\sdram_address[5] ,\sdram_address[4] ,\sdram_address[3] ,\sdram_address[2] ,\sdram_address[1] ,\sdram_address[0] ,led_succeed,led_fault,sdram_read,sdram_write,sdram_busy,sdram_data_ready,data_correct,scan_finished,SDRAM_CLK,clk_66p7m,clk_66p7m_shifted,clk_266m}),
    .clk_i(clk_266m)
);

endmodule
