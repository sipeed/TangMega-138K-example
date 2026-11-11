// SPDX-License-Identifier: Apache-2.0
// SerDes boot-register replay for PCIe links whose reference clock is not a
// steady 100 MHz when the FPGA configures. Contributed by NextTang
// (github.com/jattree/NextTang), where it is nt_serdes_reinit.v.
//
// The Raspberry Pi 5 drives its PCIe reference clock at 54 MHz while its
// firmware boots, and stops it after a failed link. A SerDes configured before
// the clock reaches 100 MHz never trains. Replaying the PCIe IP's own boot
// register file (src/serdes/serdes.csr) over the PCIe core's DRP port once the
// clock has settled, then holding the PCIe core in reset for about 10 ms, brings
// the link up at boot. See sipeed/TangMega-60K-example#1 for the bench results.
//
// The write list is src/include/serdes_reinit_rom.vh, made from serdes.csr by
// ../tools/csr_rom.py (NW and wrom(i) = {addr, data}). Regenerate it whenever
// the SerDes/PCIe IP is regenerated.
//
// REFCLK check: refclk/16 counted in 100 us gates of clk; 615..635 counts is
// 100 MHz +-1.6%. A replay runs after 10 good gates (1 ms) that follow any bad
// one, so it runs at power-up and after every loss of the clock, never while
// the clock stays good. refclk is the quad's REFCLK as the fabric sees it
// (q0_fabric_cmu_ck_ref_o, brought out of SerDes_Top by ../tools/add_refclk_tap.py).
//
// DRP write handshake (IPUG1024 3.11): hold drp_wr with address, data and
// drp_strb = 8'hFF until drp_ready rises. drp_ready idles low. A one-cycle
// write pulse is ignored.
module serdes_reinit #(
    parameter [19:0] HOLD = 20'hFFFFF   // drp_clk cycles of PCIe core reset after the replay
) (
    input             clk,          // free-running 100 MHz fabric clock
    input             refclk,       // PCIe REFCLK as seen through the quad
    input             drp_clk,      // SerDes_Top PCIE_Controller_Top_pcie_tl_drp_clk_o
    input             drp_ready,
    output reg [23:0] drp_addr = 24'd0,
    output reg [31:0] drp_wrdata = 32'd0,
    output     [7:0]  drp_strb,
    output reg        drp_wr = 1'b0,
    output            drp_rd,
    output reg        hold_reset = 1'b0,  // keep the PCIe core in reset while high (drp_clk domain)
    output reg        refclk_ok = 1'b0,   // clk domain
    output reg [7:0]  replays = 8'd0,     // completed replays (drp_clk domain)
    output reg [7:0]  timeouts = 8'd0     // writes not acknowledged within 4095 cycles
);
`include "serdes_reinit_rom.vh"

    assign drp_strb = 8'hFF;
    assign drp_rd = 1'b0;

    // ---- REFCLK frequency (clk domain)
    reg [3:0]  div = 4'd0;
    always @(posedge refclk) div <= div + 1'b1;
    reg [2:0]  s = 3'd0;
    reg [13:0] gate = 14'd0;
    reg [10:0] cnt = 11'd0;
    reg [3:0]  goods = 4'd0;
    reg        bad_seen = 1'b1;
    reg        req_t = 1'b0;                 // toggles once per replay request
    wire       edge_ = s[1] & ~s[2];
    always @(posedge clk) begin
        s <= {s[1:0], div[3]};
        if (gate == 14'd9999) begin
            gate <= 14'd0;
            cnt <= {10'd0, edge_};
            if (cnt >= 11'd615 && cnt <= 11'd635) begin
                if (goods != 4'd10) goods <= goods + 1'b1;
                else begin
                    refclk_ok <= 1'b1;
                    if (bad_seen) begin req_t <= ~req_t; bad_seen <= 1'b0; end
                end
            end else begin
                goods <= 4'd0; bad_seen <= 1'b1; refclk_ok <= 1'b0;
            end
        end else begin
            gate <= gate + 1'b1;
            if (edge_) cnt <= cnt + 1'b1;
        end
    end

    // ---- replay (drp_clk domain)
    localparam IDLE = 2'd0, WR = 2'd1, GAP = 2'd2, HOLDST = 2'd3;
    reg [2:0]  req_s = 3'd0;
    reg [1:0]  st = IDLE;
    reg [8:0]  i = 9'd0;
    reg [11:0] wait_ = 12'd0;
    reg [19:0] post = 20'd0;
    reg        seen_low = 1'b0;
    wire [55:0] wcur = wrom(i);
    always @(posedge drp_clk) begin
        req_s <= {req_s[1:0], req_t};
        drp_wr <= 1'b0;
        case (st)
        IDLE:
            if (req_s[2] ^ req_s[1]) begin
                i <= 9'd0; wait_ <= 12'd0; st <= WR;
            end
        WR: begin
                if (wait_ == 12'd0) begin
                    drp_addr <= wcur[55:32]; drp_wrdata <= wcur[31:0];
                    drp_wr <= 1'b1; seen_low <= 1'b0; wait_ <= 12'd1;
                end else if (drp_ready && (seen_low || wait_ >= 12'd8)) begin
                    st <= GAP; wait_ <= 12'd8;            // acknowledged
                end else if (wait_ == 12'hFFF) begin
                    timeouts <= timeouts + 1'b1; st <= GAP; wait_ <= 12'd8;
                end else begin
                    if (!drp_ready) seen_low <= 1'b1;
                    drp_wr <= 1'b1; wait_ <= wait_ + 1'b1;
                end
            end
        GAP:
            if (wait_ != 12'd0) wait_ <= wait_ - 1'b1;
            else if (i == NW - 1) begin
                hold_reset <= 1'b1; post <= 20'd0; st <= HOLDST;
            end else begin
                i <= i + 1'b1; st <= WR;
            end
        HOLDST:
            if (post == HOLD) begin
                hold_reset <= 1'b0; replays <= replays + 1'b1; st <= IDLE;
            end else post <= post + 1'b1;
        endcase
    end
endmodule
