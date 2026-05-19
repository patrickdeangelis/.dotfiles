#!/bin/bash

cpu=$(top -l 1 -n 0 | awk -F'[, ]+' '/CPU usage/ {
  user=$3; sys=$5; gsub("%","",user); gsub("%","",sys);
  printf "%d%%", user+sys
}')

if [ -z "$cpu" ]; then
  cpu="0%"
fi

sketchybar --set "$NAME" label="$cpu"
