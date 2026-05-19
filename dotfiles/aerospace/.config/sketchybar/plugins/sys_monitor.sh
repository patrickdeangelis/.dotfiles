#!/bin/bash

uptime_label=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')
if [ -z "$uptime_label" ]; then
  uptime_label="--"
fi

sketchybar --set "$NAME" label="$uptime_label"
