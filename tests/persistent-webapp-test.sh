#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

export HYPRCTL_BIN="$TEST_DIR/hyprctl"
export COMMAND_LOG="$TEST_DIR/commands.log"
export CLIENTS_JSON="$TEST_DIR/clients.json"
export ACTIVEWINDOW_JSON="$TEST_DIR/activewindow.json"
export ACTIVEWORKSPACE_JSON="$TEST_DIR/activeworkspace.json"
export MONITORS_JSON="$TEST_DIR/monitors.json"
export LAUNCH_WEBAPP_BIN="$TEST_DIR/omarchy-launch-webapp"
export PERSISTENT_WEBAPP_GEOM_DIR="$TEST_DIR/geom"
mkdir -p "$PERSISTENT_WEBAPP_GEOM_DIR"

printf '%s\n' '[{"focused":true,"x":0,"y":0,"width":2560,"height":1440,"reserved":[0,0,0,0]}]' >"$MONITORS_JSON"

: >"$COMMAND_LOG"

cat >"$HYPRCTL_BIN" <<'EOF'
#!/usr/bin/env bash
printf 'hyprctl %s\n' "$*" >>"$COMMAND_LOG"
case "$*" in
  "clients -j") cat "$CLIENTS_JSON" ;;
  "activewindow -j") cat "$ACTIVEWINDOW_JSON" ;;
  "activeworkspace -j") cat "$ACTIVEWORKSPACE_JSON" ;;
  "monitors -j") cat "$MONITORS_JSON" ;;
  dispatch*) printf 'ok\n' ;;
  eval*) printf 'ok\n' ;;
esac
EOF

cat >"$LAUNCH_WEBAPP_BIN" <<'EOF'
#!/usr/bin/env bash
printf 'launch-webapp %s\n' "$*" >>"$COMMAND_LOG"
EOF

chmod +x "$HYPRCTL_BIN" "$LAUNCH_WEBAPP_BIN"

# shellcheck source=/dev/null
source "$REPO_ROOT/hypr/.local/bin/persistent-webapp"

assert_eq() {
  local actual=$1 expected=$2 label=$3
  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL %s\n expected: %s\n actual:   %s\n' "$label" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_true() {
  local label=$1
  shift
  if ! "$@"; then
    printf 'FAIL %s (expected success)\n' "$label" >&2
    exit 1
  fi
}

assert_false() {
  local label=$1
  shift
  if "$@"; then
    printf 'FAIL %s (expected failure)\n' "$label" >&2
    exit 1
  fi
}

assert_true 'messages class matches' \
  class_matches_persistent 'chrome-messages.google.com__web_conversations-Default' \
  'chrome-messages.google.com__web_conversations-Default'

assert_false 'messages class without profile suffix does not match' \
  class_matches_persistent 'chrome-messages.google.com__web_conversations' \
  'chrome-messages.google.com__web_conversations'

assert_false 'regular chrome tab does not match' \
  class_matches_persistent 'google-chrome' 'google-chrome'

assert_true 'freshbooks webapp class matches' \
  class_matches_persistent 'chrome-my.freshbooks.com__-Work' 'chrome-my.freshbooks.com__-Work'

assert_true 'basecamp launchpad class matches' \
  class_matches_persistent 'chrome-launchpad.37signals.com__-Work' 'chrome-launchpad.37signals.com__-Work'

assert_true 'basecamp site class matches' \
  class_matches_persistent 'chrome-3.basecamp.com__-Work' 'chrome-3.basecamp.com__-Work'

assert_eq "$HIDDEN_WORKSPACE" 'special:hidden' 'hidden workspace name'

cat >"$CLIENTS_JSON" <<'EOF'
[
  {
    "address": "0xkitty",
    "class": "kitty",
    "initialClass": "kitty",
    "workspace": { "id": 7, "name": "7" },
    "focusHistoryID": 0
  },
  {
    "address": "0xmessages",
    "class": "chrome-messages.google.com__web_conversations-Default",
    "initialClass": "chrome-messages.google.com__web_conversations-Default",
    "workspace": { "id": -98, "name": "special:hidden" },
    "size": [480, 900],
    "focusHistoryID": 2
  },
  {
    "address": "0xbasecamp-old",
    "class": "chrome-launchpad.37signals.com__-Work",
    "initialClass": "chrome-launchpad.37signals.com__-Work",
    "workspace": { "id": 5, "name": "5" },
    "focusHistoryID": 9
  },
  {
    "address": "0xbasecamp",
    "class": "chrome-3.basecamp.com__-Work",
    "initialClass": "chrome-launchpad.37signals.com__-Work",
    "workspace": { "id": 5, "name": "5" },
    "focusHistoryID": 1
  }
]
EOF

assert_eq "$(find_app_window messages)" '0xmessages' 'find hidden messages window'
assert_eq "$(find_app_window basecamp)" '0xbasecamp' 'find most recently focused basecamp window'
assert_eq "$(find_app_window freshbooks)" '' 'missing freshbooks window is empty'

printf '%s\n' '{"address":"0xkitty","class":"kitty","initialClass":"kitty","workspace":{"id":7,"name":"7"}}' \
  >"$ACTIVEWINDOW_JSON"
printf '%s\n' '{"id":7,"name":"7"}' >"$ACTIVEWORKSPACE_JSON"
: >"$COMMAND_LOG"
hide-active
grep -F 'hl.dsp.window.close()' "$COMMAND_LOG"

printf '%s\n' '{"address":"0xmessages","class":"chrome-messages.google.com__web_conversations-Default","initialClass":"chrome-messages.google.com__web_conversations-Default","workspace":{"id":5,"name":"5"},"at":[720,120],"size":[480,900],"floating":true}' \
  >"$ACTIVEWINDOW_JSON"
: >"$COMMAND_LOG"
hidden_output=$(hide-active)
assert_eq "$hidden_output" 'hidden 0xmessages' 'hide-active reports hidden address'
grep -F 'workspace = "special:hidden"' "$COMMAND_LOG"
grep -F 'window = "address:0xmessages"' "$COMMAND_LOG"
geom_file="$PERSISTENT_WEBAPP_GEOM_DIR/persistent-webapp-geom-chrome-messages.google.com__web_conversations-Default.json"
[[ -f "$geom_file" ]]
assert_eq "$(jq -c '{x,y,w,h,workspace}' "$geom_file")" '{"x":720,"y":120,"w":480,"h":900,"workspace":5}' 'hide-active saves floating geometry and workspace'

: >"$COMMAND_LOG"
launch_app messages
grep -F 'hyprctl eval' "$COMMAND_LOG"
grep -F 'workspace = "7"' "$COMMAND_LOG"
if grep -F 'workspace = "5"' "$COMMAND_LOG"; then
  echo 'FAIL restore should use the current workspace 7, not the saved workspace 5' >&2
  cat "$COMMAND_LOG" >&2
  exit 1
fi
if grep -E 'x = 720|y = 120|window.center' "$COMMAND_LOG"; then
  echo 'FAIL restore should center on the current monitor, not replay saved x/y or use window.center' >&2
  cat "$COMMAND_LOG" >&2
  exit 1
fi
grep -F 'x = 1040' "$COMMAND_LOG"
grep -F 'y = 270' "$COMMAND_LOG"
grep -F 'x = 480' "$COMMAND_LOG"
grep -F 'y = 900' "$COMMAND_LOG"
ws_line=$(grep -n 'workspace = "7"' "$COMMAND_LOG" | head -1 | cut -d: -f1)
pos_line=$(grep -n 'x = 1040' "$COMMAND_LOG" | head -1 | cut -d: -f1)
if [[ -z "$ws_line" || -z "$pos_line" || "$ws_line" -gt "$pos_line" ]]; then
  echo "FAIL workspace move must happen before center coords in the same eval (ws line $ws_line, pos line $pos_line)" >&2
  cat "$COMMAND_LOG" >&2
  exit 1
fi
if grep -q 'launch-webapp' "$COMMAND_LOG"; then
  echo 'FAIL launch_app messages should restore, not launch' >&2
  exit 1
fi

printf '%s\n' '[{"focused":true,"x":0,"y":0,"width":2880,"height":1920,"scale":2,"reserved":[0,26,0,0]}]' >"$MONITORS_JSON"
jq 'map(if .address == "0xmessages" then .size = [580, 478] else . end)' \
  "$CLIENTS_JSON" >"$CLIENTS_JSON.tmp" && mv "$CLIENTS_JSON.tmp" "$CLIENTS_JSON"
: >"$COMMAND_LOG"
launch_app messages
grep -F 'workspace = "7"' "$COMMAND_LOG"
grep -F 'x = 430' "$COMMAND_LOG"
grep -F 'y = 254' "$COMMAND_LOG"
if grep -E 'x = 1150|y = 734' "$COMMAND_LOG"; then
  echo 'FAIL restore used unscaled monitor pixels (places the window off-screen)' >&2
  cat "$COMMAND_LOG" >&2
  exit 1
fi

printf '%s\n' '[{"focused":true,"x":0,"y":0,"width":2560,"height":1440,"scale":1,"reserved":[0,0,0,0]}]' >"$MONITORS_JSON"
jq 'map(if .address == "0xmessages" then .size = [3000, 2000] else . end)' \
  "$CLIENTS_JSON" >"$CLIENTS_JSON.tmp" && mv "$CLIENTS_JSON.tmp" "$CLIENTS_JSON"
printf '%s\n' '{"x":0,"y":0,"w":3000,"h":2000,"workspace":5}' >"$geom_file"
: >"$COMMAND_LOG"
launch_app messages
grep -F 'workspace = "7"' "$COMMAND_LOG"
grep -F 'x = 2560' "$COMMAND_LOG"
grep -F 'y = 1440' "$COMMAND_LOG"
grep -F 'x = 0' "$COMMAND_LOG"
grep -F 'y = 0' "$COMMAND_LOG"
if grep -E 'x = 3000|y = 2000' "$COMMAND_LOG"; then
  echo 'FAIL window size must be clamped to the current monitor' >&2
  cat "$COMMAND_LOG" >&2
  exit 1
fi

: >"$COMMAND_LOG"
launch_app freshbooks
grep -F 'launch-webapp https://my.freshbooks.com/ --profile-directory=Work' "$COMMAND_LOG"

grep -F 'Exec=persistent-webapp launch messages' \
  "$REPO_ROOT/google-messages/.local/share/applications/Google Messages.desktop"
grep -F 'Exec=persistent-webapp launch basecamp' \
  "$REPO_ROOT/basecamp/.local/share/applications/Basecamp.desktop"
grep -F 'Exec=persistent-webapp launch freshbooks' \
  "$REPO_ROOT/freshbooks/.local/share/applications/Freshbooks.desktop"

grep -F 'hl.unbind("SUPER + W")' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'special:hidden' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
if grep -E 'io\.popen|hide-active' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"; then
  echo 'FAIL Super+W bind must not shell out to hyprctl (deadlocks the compositor)' >&2
  exit 1
fi
grep -F 'release = true' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'no_anim' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'hide_alarm' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'hold_timer' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'persistent-webapp-geom-' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"
grep -F 'ignore_mods = true' "$REPO_ROOT/hypr/.config/hypr/bindings.lua"

echo 'persistent-webapp tests passed'
