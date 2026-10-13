#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../hypr/.local/bin/hypr-dwindle-thirds"

windows() {
  jq -n --argjson widths "$1" '
    reduce range(0; 3) as $i ({x: 0, clients: []};
      .clients += [{address: ("0x" + ($i | tostring)), mapped: true,
        hidden: false, floating: false, fullscreen: 0, workspace: {id: 98},
        monitor: 1, at: [.x, 0], size: [$widths[$i], 1000]}]
      | .x += $widths[$i]) | .clients'
}

[[ "$(resize_plan_for_three_json "$(windows '[1500, 750, 750]')" 98)" == $'0x1 1.0\n0x0 0.667' ]]
[[ "$(resize_plan_for_three_json "$(windows '[750, 750, 1500]')" 98)" == $'0x0 1.0\n0x2 1.333' ]]
if [[ -n "$(resize_plan_for_three_json "$(windows '[1200, 900, 900]')" 98)" ]]; then
  echo 'FAIL: stale 50/50 state must not overwrite a custom split' >&2
  exit 1
fi
[[ -z "$(resize_plan_for_three_json "$(windows '[1000, 1000, 1000]')" 98)" ]]
echo 'PASS: thirds plans accept either half and preserve custom ratios'
