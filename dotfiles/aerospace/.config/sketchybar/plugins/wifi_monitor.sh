#!/bin/bash

source "$CONFIG_DIR/colors.sh"

ssid=$(/usr/sbin/ipconfig getsummary en0 2>/dev/null | awk -F' : ' '/ SSID/ { print $2 }' | tr -d '\r')

if [ -z "$ssid" ] || [ "$ssid" = "You are not associated with an AirPort network." ]; then
  ip=$(ifconfig en0 2>/dev/null | awk '/inet / {print $2; exit}')
  if [ -n "$ip" ]; then
    sketchybar --set "$NAME" label="$ip" label.color=$WHITE
  else
    sketchybar --set "$NAME" label="off" label.color=$DIM_WHITE
  fi
else
  sketchybar --set "$NAME" label="$ssid" label.color=$WHITE
fi
