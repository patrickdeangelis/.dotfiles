#!/bin/bash

if scutil --nc list 2>/dev/null | grep -q "Connected"; then
  sketchybar --set "$NAME" label="on" label.color=$WHITE
else
  sketchybar --set "$NAME" label="off" label.color=$DIM_WHITE
fi
