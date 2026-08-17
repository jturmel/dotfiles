#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

export POWER_STATE_FILE="$TEST_DIR/online"
export COMMAND_LOG="$TEST_DIR/commands.log"
export MONITORS_FILE="$TEST_DIR/monitors"
export BRIGHTNESSCTL_BIN="$TEST_DIR/brightnessctl"
export HYPRCTL_BIN="$TEST_DIR/hyprctl"
export UPOWER_BIN="$TEST_DIR/upower"

printf 'Monitor eDP-1 (ID 0):\n' >"$MONITORS_FILE"
: >"$COMMAND_LOG"

cat >"$BRIGHTNESSCTL_BIN" <<'EOF'
#!/usr/bin/env bash
printf 'brightnessctl %s\n' "$*" >>"$COMMAND_LOG"
EOF

cat >"$HYPRCTL_BIN" <<'EOF'
#!/usr/bin/env bash
if [[ "$*" == "monitors all" ]]; then
  cat "$MONITORS_FILE"
else
  printf 'hyprctl %s\n' "$*" >>"$COMMAND_LOG"
fi
EOF

cat >"$UPOWER_BIN" <<'EOF'
#!/usr/bin/env bash
printf 'changed\n'
EOF

chmod +x "$BRIGHTNESSCTL_BIN" "$HYPRCTL_BIN" "$UPOWER_BIN"

# shellcheck source=/dev/null
source "$REPO_ROOT/hypr/.local/bin/power-source-display"

printf '0\n' >"$POWER_STATE_FILE"
apply_current_power_state
grep -F 'set 60%' "$COMMAND_LOG"
grep -F 'eDP-1,2880x1920@60,0x0,2' "$COMMAND_LOG"

: >"$COMMAND_LOG"
apply_current_power_state
[[ ! -s "$COMMAND_LOG" ]]

printf '1\n' >"$POWER_STATE_FILE"
apply_current_power_state
grep -F 'set 100%' "$COMMAND_LOG"
grep -F 'eDP-1,2880x1920@120,0x0,2' "$COMMAND_LOG"

: >"$COMMAND_LOG"
printf 'Monitor DP-1 (ID 1):\n' >"$MONITORS_FILE"
printf '0\n' >"$POWER_STATE_FILE"
apply_current_power_state
[[ ! -s "$COMMAND_LOG" ]]

rm "$POWER_STATE_FILE"
if apply_current_power_state; then
  echo 'expected unreadable power state to fail' >&2
  exit 1
fi

echo 'power-source-display tests passed'
