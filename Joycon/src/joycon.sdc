
create_clock -name clkin -period 20 -waveform {0 10} [get_ports {clk}]
//create_clock -name tck_pad_i -period 50 -waveform {0 25} [get_ports {tck_pad_i}]

create_generated_clock -name uart_left_rxclk -source [get_ports {clk}] -master_clock clkin -multiply_by 1 [get_nets {Joycon_left/joycon_uart_core/i4/rxclk_Z}]
create_generated_clock -name uart_right_rxclk -source [get_ports {clk}] -master_clock clkin -multiply_by 1 [get_nets {Joycon_right/joycon_uart_core/i4/rxclk_Z}]
set_clock_groups -asynchronous -group [get_clocks {clkin}] -group [get_clocks {uart_left_rxclk}] -group [get_clocks {uart_right_rxclk}]// -group [get_clocks {tck_pad_i}]
