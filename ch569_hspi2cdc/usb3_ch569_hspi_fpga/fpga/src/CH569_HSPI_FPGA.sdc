create_clock -name hspi_rx_clk -period 8.333 -waveform {0 4.167} [get_ports {pad_i_CH569_HTCLK}]
create_clock -name sys_clk -period 8.333 -waveform {0 4.167} [get_nets {clk_sys}]

// Incoming CH569 HSPI clock and the FPGA PLL are frequency-matched but not
// phase-related.  Toggle synchronizers plus stable payload snapshots perform
// the clock-domain crossing in both directions.
set_clock_groups -asynchronous -group [get_clocks {hspi_rx_clk}] -group [get_clocks {sys_clk}]
