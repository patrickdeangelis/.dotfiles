#!/bin/bash

items=(net_monitor wifi_monitor disk_monitor)

sketchybar_bin="sketchybar"
if [ -x /opt/homebrew/bin/sketchybar ]; then
  sketchybar_bin="/opt/homebrew/bin/sketchybar"
elif [ -x /usr/local/bin/sketchybar ]; then
  sketchybar_bin="/usr/local/bin/sketchybar"
fi

target=$("$sketchybar_bin" --query displays 2>/dev/null | /usr/bin/python3 - <<'PY'
import json
import sys

builtin_uuid = "37D8832A-2D66-02CA-B9F7-8F30A301B230"

try:
    displays = json.load(sys.stdin)
except Exception:
    print("unknown")
    raise SystemExit(0)

if len(displays) < 2:
    print("hide")
    raise SystemExit(0)

external = None
for d in displays:
    if d.get("UUID") != builtin_uuid:
        external = d
        break

if external is None:
    print("hide")
    raise SystemExit(0)

arr_id = external.get("arrangement-id")
if arr_id is None:
    print("hide")
else:
    print(arr_id)
PY
)

if [ "$target" = "hide" ] || [ "$target" = "unknown" ] || [ -z "$target" ]; then
  for item in "${items[@]}"; do
    "$sketchybar_bin" --set "$item" drawing=off
  done
else
  for item in "${items[@]}"; do
    "$sketchybar_bin" --set "$item" drawing=on display="$target"
  done
fi
