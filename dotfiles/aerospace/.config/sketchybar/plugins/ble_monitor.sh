#!/bin/bash

connected_name=$(system_profiler SPBluetoothDataType -detailLevel mini 2>/dev/null | awk '
  /^[[:space:]]{4}.*:$/ { name=$0; gsub(/^[ \t]+|:$/, "", name) }
  /Connected: Yes/ { if (name != "") { print name; exit } }
')

if printf "%s" "$connected_name" | rg -qi "AirPods"; then
  sketchybar --set "$NAME" drawing=on icon="$ICON_AIRPODS"
else
  sketchybar --set "$NAME" drawing=off
fi
