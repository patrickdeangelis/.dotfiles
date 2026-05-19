#!/bin/bash

iface=$(route get default 2>/dev/null | awk '/interface:/{print $2}' | head -n 1)
if [ -z "$iface" ]; then
  iface="en0"
fi

read -r rx tx < <(netstat -ibn | awk -v iface="$iface" '$1==iface && $7 ~ /^[0-9]+$/ {rx=$7; tx=$10} END {print rx, tx}')
if [ -z "$rx" ] || [ -z "$tx" ]; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi

now=$(date +%s)
state_file="/tmp/sketchybar_net_${iface}"
if [ -f "$state_file" ]; then
  read -r prev_rx prev_tx prev_time < "$state_file"
  dt=$((now - prev_time))
  if [ "$dt" -gt 0 ]; then
    down=$(( (rx - prev_rx) / dt ))
    up=$(( (tx - prev_tx) / dt ))
  else
    down=0
    up=0
  fi
else
  down=0
  up=0
fi

echo "$rx $tx $now" > "$state_file"

fmt() {
  local bytes=$1
  if [ "$bytes" -ge 1048576 ]; then
    printf "%.1fM" "$(awk "BEGIN {print $bytes/1048576}")"
  elif [ "$bytes" -ge 1024 ]; then
    printf "%.0fK" "$(awk "BEGIN {print $bytes/1024}")"
  else
    printf "%dB" "$bytes"
  fi
}

down_fmt=$(fmt "$down")
up_fmt=$(fmt "$up")

sketchybar --set "$NAME" label="↓${down_fmt} ↑${up_fmt}"
