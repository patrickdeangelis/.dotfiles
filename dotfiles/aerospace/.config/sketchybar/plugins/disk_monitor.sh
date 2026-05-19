#!/bin/bash

disk=$(df -H / | awk 'NR==2{print $5}')
if [ -z "$disk" ]; then
  disk="0%"
fi

sketchybar --set "$NAME" label="$disk"
