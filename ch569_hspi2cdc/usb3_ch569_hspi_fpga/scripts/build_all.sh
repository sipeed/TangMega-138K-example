#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "$0")/.." && pwd)

make -C "$project_dir/firmware" -j"$(nproc)" all

export QT_QPA_PLATFORM=minimal
export QT_QUICK_BACKEND=software
export QT_XCB_GL_INTEGRATION=none
BENCH_DIRECTION=forward gw_sh "$project_dir/fpga/build.tcl"
BENCH_DIRECTION=reverse gw_sh "$project_dir/fpga/build.tcl"

cc -O3 -Wall -Wextra \
  "$project_dir/scripts/usb3_bulk_in_benchmark.c" \
  $(pkg-config --cflags --libs libusb-1.0) \
  -o "$project_dir/scripts/usb3_bulk_in_benchmark"
cc -O3 -Wall -Wextra \
  "$project_dir/scripts/usb3_bulk_out_hspi_benchmark.c" \
  $(pkg-config --cflags --libs libusb-1.0) \
  -o "$project_dir/scripts/usb3_bulk_out_hspi_benchmark"

printf 'CH569: %s\n' "$project_dir/firmware/output/firmware.bin"
printf 'FPGA forward: %s\n' "$project_dir/fpga/impl/pnr/usb3_ch569_hspi_fpga_forward.fs"
printf 'FPGA reverse: %s\n' "$project_dir/fpga/impl/pnr/usb3_ch569_hspi_fpga_reverse.fs"
