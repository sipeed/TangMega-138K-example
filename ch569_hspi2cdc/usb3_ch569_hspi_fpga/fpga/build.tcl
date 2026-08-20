set script_dir [file dirname [file normalize [info script]]]
if {[info exists ::env(BENCH_DIRECTION)] && $::env(BENCH_DIRECTION) eq "reverse"} {
    open_project [file join $script_dir CH569_HSPI_FPGA_reverse.gprj]
} else {
    open_project [file join $script_dir CH569_HSPI_FPGA.gprj]
}
set_option -verilog_std sysv2017
if {[info exists ::env(BENCH_DIRECTION)] && $::env(BENCH_DIRECTION) eq "reverse"} {
    set_option -top_module top_reverse
    set_option -output_base_name usb3_ch569_hspi_fpga_reverse
} else {
    set_option -top_module top
    set_option -output_base_name usb3_ch569_hspi_fpga_forward
}
run all
