#!/bin/bash

mem=$(top -l 1 -n 0 | awk '/PhysMem/ {print $2}')
if [ -z "$mem" ]; then
  mem="0G"
fi

sketchybar --set "$NAME" label="$mem"
