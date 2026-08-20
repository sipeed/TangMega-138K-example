#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "$0")/.." && pwd)
direction=${1:-forward}
if [[ "$direction" != forward && "$direction" != reverse ]]; then
  echo "usage: $0 [forward|reverse]" >&2
  exit 2
fi
bitstream="$project_dir/fpga/impl/pnr/usb3_ch569_hspi_fpga_${direction}.fs"
if [[ ! -f "$bitstream" ]]; then
  compressed="$project_dir/prebuilt/fpga_${direction}.fs.gz"
  if [[ -f "$compressed" ]]; then
    mkdir -p "$(dirname "$bitstream")"
    gzip -dc "$compressed" > "$bitstream"
  fi
fi

if [[ ! -f "$bitstream" ]]; then
  echo "Missing bitstream and prebuilt image; run scripts/build_all.sh first." >&2
  exit 1
fi
openFPGALoader -b tangmega138k "$bitstream"
