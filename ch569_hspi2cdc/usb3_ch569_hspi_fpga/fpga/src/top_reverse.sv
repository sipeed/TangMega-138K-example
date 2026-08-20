module top_reverse #(
    parameter logic AUTONOMOUS_UPLOAD = 1'b0
)(
	input                               pad_i_clk_50MHz,    // E2
    inout                               pad_io_ready,       // E8
    inout                               pad_io_done,        // D7

    inout                 [15:0]        pad_io_HSPI_HD,

    // FPGA transmitter -> CH569 receiver control group.
    output                              pad_o_HSPI_HTCLK,
    output                              pad_o_HSPI_HTREQ,
    input                               pad_i_HSPI_HTRDY,
    output                              pad_o_HSPI_HTVLD,

    // CH569 transmitter -> FPGA receiver control group.  HSPI has separate
    // control pins in each direction; only HD[15:0] is shared.
    input                               pad_i_CH569_HTCLK,
    input                               pad_i_CH569_HTREQ,
    output                              pad_o_CH569_HTRDY,
    input                               pad_i_CH569_HTVLD

	// N12 is the device's dedicated RECONFIG_N pin in the installed Gowin
	// device database, so the benchmark image keeps this reset deasserted.
);
logic clk;
logic ec_spi_cs1;
logic ec_spi_cs2;

assign clk = pad_i_clk_50MHz;
assign ec_spi_cs1 = pad_io_done;
assign ec_spi_cs2 = pad_io_ready;

wire pad_i_s1 = 1'b0;

logic rst_n;
logic clk_sys;
logic pll_locked;
logic gw_vcc;
logic gw_gnd;
logic clkout1_o;
logic clkout2_o;
logic clkout3_o;
logic clkout4_o;
logic clkout5_o;
logic clkout6_o;
logic clkfbout_o;

assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;
assign rst_n = ~pad_i_s1 & pll_locked;

PLL PLL_inst (
    .LOCK(pll_locked),
    .CLKOUT0(clk_sys),
    .CLKOUT1(clkout1_o),
    .CLKOUT2(clkout2_o),
    .CLKOUT3(clkout3_o),
    .CLKOUT4(clkout4_o),
    .CLKOUT5(clkout5_o),
    .CLKOUT6(clkout6_o),
    .CLKFBOUT(clkfbout_o),
    .CLKIN(clk),
    .CLKFB(gw_gnd),
    .RESET(pad_i_s1),
    .PLLPWD(gw_gnd),
    .RESET_I(gw_gnd),
    .RESET_O(gw_gnd),
    .FBDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .IDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .MDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .MDSEL_FRAC({gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL0({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL0_FRAC({gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL1({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL2({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL3({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL4({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL5({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL6({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .DT0({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .DT1({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .DT2({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .DT3({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ICPSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .LPFRES({gw_gnd,gw_gnd,gw_gnd}),
    .LPFCAP({gw_gnd,gw_gnd}),
    .PSSEL({gw_gnd,gw_gnd,gw_gnd}),
    .PSDIR(gw_gnd),
    .PSPULSE(gw_gnd),
    .ENCLK0(gw_vcc),
    .ENCLK1(gw_vcc),
    .ENCLK2(gw_vcc),
    .ENCLK3(gw_vcc),
    .ENCLK4(gw_vcc),
    .ENCLK5(gw_vcc),
    .ENCLK6(gw_vcc),
    .SSCPOL(gw_gnd),
    .SSCON(gw_gnd),
    .SSCMDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .SSCMDSEL_FRAC({gw_gnd,gw_gnd,gw_gnd})
);

defparam PLL_inst.DYN_IDIV_SEL = "FALSE";
defparam PLL_inst.DYN_FBDIV_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV0_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV1_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV2_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV3_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV4_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV5_SEL = "FALSE";
defparam PLL_inst.DYN_ODIV6_SEL = "FALSE";
defparam PLL_inst.DYN_MDIV_SEL = "FALSE";
defparam PLL_inst.DYN_DT0_SEL = "FALSE";
defparam PLL_inst.DYN_DT1_SEL = "FALSE";
defparam PLL_inst.DYN_DT2_SEL = "FALSE";
defparam PLL_inst.DYN_DT3_SEL = "FALSE";
defparam PLL_inst.DYN_ICP_SEL = "FALSE";
defparam PLL_inst.DYN_LPF_SEL = "FALSE";
defparam PLL_inst.FCLKIN = "50";
defparam PLL_inst.IDIV_SEL = 1;
defparam PLL_inst.FBDIV_SEL = 1;
defparam PLL_inst.CLKFB_SEL = "INTERNAL";
// 50 MHz * 24 / 10 = 120 MHz, the CH569 HSPI specification limit.
defparam PLL_inst.ODIV0_SEL = 10;
defparam PLL_inst.ODIV0_FRAC_SEL = 0;
defparam PLL_inst.ODIV1_SEL = 8;
defparam PLL_inst.ODIV2_SEL = 8;
defparam PLL_inst.ODIV3_SEL = 8;
defparam PLL_inst.ODIV4_SEL = 8;
defparam PLL_inst.ODIV5_SEL = 8;
defparam PLL_inst.ODIV6_SEL = 8;
defparam PLL_inst.MDIV_SEL = 24;
defparam PLL_inst.MDIV_FRAC_SEL = 0;
defparam PLL_inst.CLKOUT0_EN = "TRUE";
defparam PLL_inst.CLKOUT1_EN = "FALSE";
defparam PLL_inst.CLKOUT2_EN = "FALSE";
defparam PLL_inst.CLKOUT3_EN = "FALSE";
defparam PLL_inst.CLKOUT4_EN = "FALSE";
defparam PLL_inst.CLKOUT5_EN = "FALSE";
defparam PLL_inst.CLKOUT6_EN = "FALSE";
defparam PLL_inst.CLKOUT0_DT_DIR = 1'b1;
defparam PLL_inst.CLKOUT1_DT_DIR = 1'b1;
defparam PLL_inst.CLKOUT2_DT_DIR = 1'b1;
defparam PLL_inst.CLKOUT3_DT_DIR = 1'b1;
defparam PLL_inst.CLK0_IN_SEL = 1'b0;
defparam PLL_inst.CLK0_OUT_SEL = 1'b0;
defparam PLL_inst.CLK1_IN_SEL = 1'b0;
defparam PLL_inst.CLK1_OUT_SEL = 1'b0;
defparam PLL_inst.CLK2_IN_SEL = 1'b0;
defparam PLL_inst.CLK2_OUT_SEL = 1'b0;
defparam PLL_inst.CLK3_IN_SEL = 1'b0;
defparam PLL_inst.CLK3_OUT_SEL = 1'b0;
defparam PLL_inst.CLK4_IN_SEL = 2'b00;
defparam PLL_inst.CLK4_OUT_SEL = 1'b0;
defparam PLL_inst.CLK5_IN_SEL = 1'b0;
defparam PLL_inst.CLK5_OUT_SEL = 1'b0;
defparam PLL_inst.CLK6_IN_SEL = 1'b0;
defparam PLL_inst.CLK6_OUT_SEL = 1'b0;
defparam PLL_inst.CLKOUT0_PE_COARSE = 0;
defparam PLL_inst.CLKOUT0_PE_FINE = 0;
defparam PLL_inst.CLKOUT1_PE_COARSE = 0;
defparam PLL_inst.CLKOUT1_PE_FINE = 0;
defparam PLL_inst.CLKOUT2_PE_COARSE = 0;
defparam PLL_inst.CLKOUT2_PE_FINE = 0;
defparam PLL_inst.CLKOUT3_PE_COARSE = 0;
defparam PLL_inst.CLKOUT3_PE_FINE = 0;
defparam PLL_inst.CLKOUT4_PE_COARSE = 0;
defparam PLL_inst.CLKOUT4_PE_FINE = 0;
defparam PLL_inst.CLKOUT5_PE_COARSE = 0;
defparam PLL_inst.CLKOUT5_PE_FINE = 0;
defparam PLL_inst.CLKOUT6_PE_COARSE = 0;
defparam PLL_inst.CLKOUT6_PE_FINE = 0;
defparam PLL_inst.DE0_EN = "FALSE";
defparam PLL_inst.DE1_EN = "FALSE";
defparam PLL_inst.DE2_EN = "FALSE";
defparam PLL_inst.DE3_EN = "FALSE";
defparam PLL_inst.DE4_EN = "FALSE";
defparam PLL_inst.DE5_EN = "FALSE";
defparam PLL_inst.DE6_EN = "FALSE";
defparam PLL_inst.DYN_DPA_EN = "FALSE";
defparam PLL_inst.DYN_PE0_SEL = "FALSE";
defparam PLL_inst.DYN_PE1_SEL = "FALSE";
defparam PLL_inst.DYN_PE2_SEL = "FALSE";
defparam PLL_inst.DYN_PE3_SEL = "FALSE";
defparam PLL_inst.DYN_PE4_SEL = "FALSE";
defparam PLL_inst.DYN_PE5_SEL = "FALSE";
defparam PLL_inst.DYN_PE6_SEL = "FALSE";
defparam PLL_inst.RESET_I_EN = "FALSE";
defparam PLL_inst.RESET_O_EN = "FALSE";
defparam PLL_inst.ICP_SEL = 6'bXXXXXX;
defparam PLL_inst.LPF_RES = 3'bXXX;
defparam PLL_inst.LPF_CAP = 2'b00;
defparam PLL_inst.SSC_EN = "FALSE";
defparam PLL_inst.CLKOUT0_DT_STEP = 0;
defparam PLL_inst.CLKOUT1_DT_STEP = 0;
defparam PLL_inst.CLKOUT2_DT_STEP = 0;
defparam PLL_inst.CLKOUT3_DT_STEP = 0;

logic clk_15MHz;

CLKDIV clkdiv_inst (
    .HCLKIN(clk_sys),
    .RESETN(rst_n),
    .CALIB(gw_gnd),
    .CLKOUT(clk_15MHz)
);
defparam clkdiv_inst.DIV_MODE="8";

localparam logic [31:0] BENCH_MAGIC_CMD = 32'h4242_5348; // "HSBB"
localparam logic [15:0] BENCH_VERSION = 16'd1;
localparam logic [15:0] OP_PC_TO_FPGA = 16'd1;
localparam logic [15:0] OP_FPGA_TO_PC = 16'd2;

logic [24:0] led_counter;
always_ff @(posedge clk_15MHz or negedge rst_n) begin
    if (!rst_n)
        led_counter <= '0;
    else
        led_counter <= led_counter + 1'b1;
end

logic tx_trigger;
logic [11:0] tx_length;
logic tx_done;
logic rx_done;
logic rx_crc_error;
logic rx_num_error;
logic [15:0] rx_crc_value;
logic [15:0] rx_last_crc_value;

wire hspi_tx_clk;
wire hspi_tx_req;
wire hspi_tx_vld;
wire hspi_rx_ack;
wire [31:0] hspi_tx_data;
wire [2:0] hspi_tx_oe;
wire hspi_tx_active = hspi_tx_req;
wire hspi_rx_clk = pad_i_CH569_HTCLK;
wire hspi_rx_act = pad_i_CH569_HTREQ;
wire hspi_rx_vld = pad_i_CH569_HTVLD;

assign pad_o_HSPI_HTCLK = hspi_tx_clk;
assign pad_o_HSPI_HTREQ = hspi_tx_req;
assign pad_o_HSPI_HTVLD = hspi_tx_vld;
// The benchmark receiver is permanently available: CH569 sends exactly one
// frame at a time and waits for its completion before reusing the DMA buffer.
// Keeping HTRDY asserted also avoids a needless asynchronous request/ack
// round trip before every frame.
assign pad_o_CH569_HTRDY = 1'b1;
assign pad_io_HSPI_HD[15:0] = (hspi_tx_active && hspi_tx_oe[1]) ?
                               hspi_tx_data[15:0] : 16'hzzzz;

logic ram_clk;
logic ram_csn;
logic ram_wen;
logic [8:0] ram_addr;
logic [31:0] ram_rdata;
logic [31:0] ram_rdata_next;
logic [31:0] ram_wdata;
logic rx_write;
logic [8:0] rx_write_addr;
logic [31:0] rx_write_data;
logic [8:0] tx_read_addr;

function automatic [15:0] payload_pattern(
    input logic [31:0] word_index,
    input logic [31:0] seed
);
    payload_pattern = word_index[15:0] ^ word_index[23:8] ^ seed[15:0];
endfunction

// CH569-to-FPGA command and data processing stays entirely in the incoming
// HSPI clock domain.  Every payload word is checked while the core writes it.
logic rx_data_mode;
logic [15:0] cmd_word0;
logic [15:0] cmd_word1;
logic [15:0] cmd_version;
logic [15:0] cmd_op;
logic [31:0] cmd_total_bytes;
logic [31:0] cmd_seed;
logic [31:0] active_total_bytes;
logic [31:0] active_seed;
logic [31:0] rx_word_count;
logic [31:0] rx_frames;
logic [31:0] rx_crc_errors;
logic [31:0] rx_num_errors;
logic [31:0] rx_pattern_errors;
logic [31:0] rx_active_cycles;
logic forward_report_toggle;
logic reverse_request_toggle;

always_ff @(posedge hspi_rx_clk or negedge rst_n) begin
    if (!rst_n) begin
        rx_data_mode <= 1'b0;
        cmd_word0 <= '0;
        cmd_word1 <= '0;
        cmd_version <= '0;
        cmd_op <= '0;
        cmd_total_bytes <= '0;
        cmd_seed <= '0;
        active_total_bytes <= '0;
        active_seed <= '0;
        rx_word_count <= '0;
        rx_frames <= '0;
        rx_crc_errors <= '0;
        rx_num_errors <= '0;
        rx_pattern_errors <= '0;
        rx_active_cycles <= '0;
        rx_last_crc_value <= '0;
        forward_report_toggle <= 1'b0;
        reverse_request_toggle <= 1'b0;
    end else begin
        if (rx_data_mode)
            rx_active_cycles <= rx_active_cycles + 1'b1;

        if (rx_write) begin
            if (!rx_data_mode) begin
                case (rx_write_addr)
                    9'd0: cmd_word0 <= rx_write_data[15:0];
                    9'd1: cmd_word1 <= rx_write_data[15:0];
                    9'd2: cmd_version <= rx_write_data[15:0];
                    9'd3: cmd_op <= rx_write_data[15:0];
                    9'd4: cmd_total_bytes[15:0] <= rx_write_data[15:0];
                    9'd5: cmd_total_bytes[31:16] <= rx_write_data[15:0];
                    9'd6: cmd_seed[15:0] <= rx_write_data[15:0];
                    9'd7: cmd_seed[31:16] <= rx_write_data[15:0];
                    default: ;
                endcase
            end else begin
                if (rx_write_data[15:0] != payload_pattern(rx_word_count, active_seed))
                    rx_pattern_errors <= rx_pattern_errors + 1'b1;
                rx_word_count <= rx_word_count + 1'b1;
            end
        end

        if (rx_done) begin
            rx_last_crc_value <= rx_crc_value;
            if (!rx_data_mode &&
                {cmd_word1, cmd_word0} == BENCH_MAGIC_CMD &&
                cmd_version == BENCH_VERSION) begin
                active_total_bytes <= cmd_total_bytes;
                active_seed <= cmd_seed;
                rx_word_count <= '0;
                rx_frames <= '0;
                rx_crc_errors <= rx_crc_error ? 32'd1 : 32'd0;
                rx_num_errors <= rx_num_error ? 32'd1 : 32'd0;
                rx_pattern_errors <= '0;
                rx_active_cycles <= '0;
                if (cmd_op == OP_PC_TO_FPGA) begin
                    rx_data_mode <= 1'b1;
                end else if (cmd_op == OP_FPGA_TO_PC) begin
                    reverse_request_toggle <= ~reverse_request_toggle;
                end
            end else if (rx_data_mode) begin
                rx_frames <= rx_frames + 1'b1;
                if (rx_crc_error)
                    rx_crc_errors <= rx_crc_errors + 1'b1;
                if (rx_num_error)
                    rx_num_errors <= rx_num_errors + 1'b1;
                if (rx_word_count == (active_total_bytes >> 1)) begin
                    rx_data_mode <= 1'b0;
                    forward_report_toggle <= ~forward_report_toggle;
                end
            end
        end
    end
end

typedef enum logic [2:0] {
    TX_IDLE,
    TX_START_DELAY,
    TX_DATA_WAIT,
    TX_DATA_GAP,
    TX_REPORT_GAP,
    TX_REPORT_WAIT
} tx_state_t;

tx_state_t tx_state;
logic report_mode;
logic [15:0] report_op;
logic [31:0] report_total_bytes;
logic [31:0] report_seed;
logic [31:0] tx_word_base;
logic [31:0] tx_frames;
logic [31:0] tx_elapsed_cycles;
logic [31:0] report_cycles;
logic [31:0] report_fpga_frames;
logic [31:0] report_crc_errors;
logic [31:0] report_seq_errors;
logic [31:0] report_pattern_errors;
logic [15:0] tx_delay;
logic forward_report_sync1;
logic forward_report_sync2;
logic forward_report_seen;
logic reverse_request_sync1;
logic reverse_request_sync2;
logic reverse_request_seen;

// Forward mode continuously generates complete 4096-byte FPGA->PC frames.
// Reverse benchmark keeps autonomous upload disabled, leaving HD[15:0] idle
// until CH569 sends PC data to the FPGA.
localparam logic [11:0] AUTONOMOUS_TX_LENGTH = 12'd4095;
localparam logic [31:0] AUTONOMOUS_WORDS_PER_FRAME = 32'd2048;

// FPGA-to-CH569 data generation and final reports use the 120 MHz system/HSPI
// transmit clock. A request is allowed to wait indefinitely for HTRDY, which
// is the backpressure asserted by CH569 while USB IN owns the DMA buffer.
always_ff @(posedge clk_sys or negedge rst_n) begin
    if (!rst_n) begin
        tx_trigger <= 1'b0;
        tx_length <= AUTONOMOUS_UPLOAD ? AUTONOMOUS_TX_LENGTH : 12'd1023;
        tx_state <= AUTONOMOUS_UPLOAD ? TX_START_DELAY : TX_IDLE;
        report_mode <= 1'b0;
        report_op <= '0;
        report_total_bytes <= AUTONOMOUS_UPLOAD ? 32'hffff_ff00 : 32'd0;
        report_seed <= '0;
        tx_word_base <= '0;
        tx_frames <= '0;
        tx_elapsed_cycles <= '0;
        report_cycles <= '0;
        report_fpga_frames <= '0;
        report_crc_errors <= '0;
        report_seq_errors <= '0;
        report_pattern_errors <= '0;
        tx_delay <= '0;
        forward_report_sync1 <= 1'b0;
        forward_report_sync2 <= 1'b0;
        forward_report_seen <= 1'b0;
        reverse_request_sync1 <= 1'b0;
        reverse_request_sync2 <= 1'b0;
        reverse_request_seen <= 1'b0;
    end else begin
        tx_trigger <= 1'b0;
        forward_report_sync1 <= forward_report_toggle;
        forward_report_sync2 <= forward_report_sync1;
        reverse_request_sync1 <= reverse_request_toggle;
        reverse_request_sync2 <= reverse_request_sync1;

        if (tx_state != TX_IDLE)
            tx_elapsed_cycles <= tx_elapsed_cycles + 1'b1;

        case (tx_state)
        TX_IDLE: begin
            report_mode <= 1'b0;
            tx_delay <= '0;
            if (forward_report_sync2 != forward_report_seen) begin
                forward_report_seen <= forward_report_sync2;
                report_mode <= 1'b1;
                report_op <= OP_PC_TO_FPGA;
                report_total_bytes <= active_total_bytes;
                report_seed <= active_seed;
                tx_elapsed_cycles <= rx_active_cycles;
                report_cycles <= rx_active_cycles;
                report_fpga_frames <= rx_frames;
                report_crc_errors <= rx_crc_errors;
                report_seq_errors <= rx_num_errors;
                report_pattern_errors <= rx_pattern_errors;
                tx_state <= TX_REPORT_GAP;
            end else if (reverse_request_sync2 != reverse_request_seen) begin
                reverse_request_seen <= reverse_request_sync2;
                report_op <= OP_FPGA_TO_PC;
                report_total_bytes <= active_total_bytes;
                report_seed <= active_seed;
                tx_word_base <= '0;
                tx_frames <= '0;
                tx_elapsed_cycles <= '0;
                report_fpga_frames <= '0;
                report_crc_errors <= '0;
                report_seq_errors <= '0;
                report_pattern_errors <= '0;
                tx_state <= TX_START_DELAY;
            end
        end
        TX_START_DELAY: begin
            tx_delay <= tx_delay + 1'b1;
            if (&tx_delay) begin
                tx_length <= AUTONOMOUS_UPLOAD ? AUTONOMOUS_TX_LENGTH : 12'd1023;
                tx_trigger <= 1'b1;
                tx_state <= TX_DATA_WAIT;
            end
        end
        TX_DATA_WAIT: begin
            if (tx_done) begin
                tx_word_base <= tx_word_base +
                                (AUTONOMOUS_UPLOAD ? AUTONOMOUS_WORDS_PER_FRAME : 32'd512);
                tx_frames <= tx_frames + 1'b1;
                tx_delay <= '0;
                if (!AUTONOMOUS_UPLOAD &&
                    tx_word_base + 32'd512 == (report_total_bytes >> 1)) begin
                    report_mode <= 1'b1;
                    report_cycles <= tx_elapsed_cycles;
                    report_fpga_frames <= tx_frames + 1'b1;
                    tx_state <= TX_REPORT_GAP;
                end else begin
                    tx_state <= TX_DATA_GAP;
                end
            end
        end
        TX_DATA_GAP: begin
            tx_delay <= tx_delay + 1'b1;
            /* Keep only a short turnaround between complete 4096-byte
             * frames.  The CH569 64 KiB ring applies HTRDY backpressure at
             * frame boundaries if USB3 falls behind. */
            if (tx_delay == 16'd383) begin
                tx_length <= AUTONOMOUS_UPLOAD ? AUTONOMOUS_TX_LENGTH : 12'd1023;
                tx_trigger <= 1'b1;
                tx_state <= TX_DATA_WAIT;
            end
        end
        TX_REPORT_GAP: begin
            tx_delay <= tx_delay + 1'b1;
            if (tx_delay == 16'd4095) begin
                tx_length <= 12'd63;
                tx_trigger <= 1'b1;
                tx_state <= TX_REPORT_WAIT;
            end
        end
        TX_REPORT_WAIT: begin
            if (tx_done) begin
                report_mode <= 1'b0;
                tx_state <= TX_IDLE;
            end
        end
        default: tx_state <= TX_IDLE;
        endcase
    end
end

assign pad_io_done = (tx_state == TX_IDLE) ? led_counter[21] : led_counter[18];
assign pad_io_ready = rx_data_mode ? led_counter[18] : led_counter[20];

logic [15:0] report_word;
always_comb begin
    report_word = 16'h0000;
    if (!report_mode) begin
        ram_rdata_next = {16'h0000, payload_pattern(tx_word_base + tx_read_addr, report_seed)};
    end else begin
        case (tx_read_addr)
            9'd0:  report_word = 16'h5348; // "HS"
            9'd1:  report_word = 16'h5250; // "PR"
            9'd2:  report_word = BENCH_VERSION;
            9'd3:  report_word = report_op;
            9'd4:  report_word = report_total_bytes[15:0];
            9'd5:  report_word = report_total_bytes[31:16];
            9'd6:  report_word = report_fpga_frames[15:0];
            9'd7:  report_word = report_fpga_frames[31:16];
            9'd8:  report_word = report_crc_errors[15:0];
            9'd9:  report_word = report_crc_errors[31:16];
            9'd10: report_word = report_seq_errors[15:0];
            9'd11: report_word = report_seq_errors[31:16];
            9'd12: report_word = report_pattern_errors[15:0];
            9'd13: report_word = report_pattern_errors[31:16];
            9'd20: report_word = report_cycles[15:0];
            9'd21: report_word = report_cycles[31:16];
            9'd26: report_word = 16'd1024;
            9'd27: report_word = 16'd0;
            9'd28: report_word = report_seed[15:0];
            9'd29: report_word = report_seed[31:16];
            9'd30: report_word = rx_last_crc_value;
            default: report_word = 16'h0000;
        endcase
        ram_rdata_next = {16'h0000, report_word};
    end
end

// The HSPI core consumes RAM data and advances its address on opposite clock
// edges.  This register both models a synchronous ROM and gives the CRC path a
// full clock period instead of an address-to-CRC half-cycle path.
always_ff @(posedge clk_sys or negedge rst_n) begin
    if (!rst_n)
        ram_rdata <= '0;
    else
        ram_rdata <= ram_rdata_next;
end

EXM_HSPI #(
    .TX_LEN(12'd1023),
    .HSPI_UDF(26'h000ffff),
    .TX_ADDR(9'h000),
    .RX_ADDR(9'h000)
) M_HSPI (
    .HTCLK(hspi_tx_clk),
    .HTREQ(hspi_tx_req),
    .HTRDY(pad_i_HSPI_HTRDY),
    .HTVLD(hspi_tx_vld),
    .HTD(hspi_tx_data),
    .HTOE(hspi_tx_oe),
    .tx_act(tx_trigger),
    .tx_len(tx_length),
    .HRCLK(hspi_rx_clk),
    .HRACT(hspi_rx_act),
    .HRVLD(hspi_rx_vld),
    .HTACK(hspi_rx_ack),
    .HRD({16'h0000, pad_io_HSPI_HD[15:0]}),
    .rstn(rst_n),
    .clk(clk_sys),
    .dat_mod(2'b01),
    .ram_clk(ram_clk),
    .ram_csn(ram_csn),
    .ram_wen(ram_wen),
    .ram_addr(ram_addr),
    .ram_rdata(ram_rdata),
    .ram_wdata(ram_wdata),
    .rx_write(rx_write),
    .rx_addr(rx_write_addr),
    .rx_data(rx_write_data),
    .tx_addr(tx_read_addr),
    .tx_done(tx_done),
    .rx_done(rx_done),
    .rx_crc_error(rx_crc_error),
    .rx_num_error(rx_num_error),
    .rx_crc_value(rx_crc_value)
);
endmodule
