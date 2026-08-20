#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "$0")/.." && pwd)
workspace_dir=$(cd "$project_dir/.." && pwd)
firmware="$project_dir/firmware/output/firmware.bin"
if [[ ! -f "$firmware" ]]; then
  firmware="$project_dir/prebuilt/ch569_usb3_hspi.bin"
fi
isp=${WCH_CH56X_ISP:-}
if [[ -z "$isp" ]]; then
  isp=$(command -v wch-ch56x-isp || true)
fi
if [[ -z "$isp" && -x "$workspace_dir/tools/wch-ch56x-isp/wch-ch56x-isp" ]]; then
  isp="$workspace_dir/tools/wch-ch56x-isp/wch-ch56x-isp"
fi

if [[ -z "$isp" || ! -x "$isp" ]]; then
  echo "wch-ch56x-isp not found; install it or set WCH_CH56X_ISP." >&2
  exit 1
fi
if [[ ! -f "$firmware" ]]; then
  echo "Missing firmware and prebuilt image; run scripts/build_all.sh first." >&2
  exit 1
fi

# Put CH569 into USB bootloader immediately before running this command.
# Deliberately do not pass -b: the board must retain PA13 as its BOOT pin.
exec "$isp" -vr -f="$firmware"
