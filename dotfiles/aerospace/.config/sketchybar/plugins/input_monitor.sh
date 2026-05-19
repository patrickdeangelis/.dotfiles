#!/bin/bash

layout=$(osascript -e 'tell application "System Events" to get name of current keyboard layout' 2>/dev/null)
if [ -z "$layout" ]; then
  label="--"
else
  label=$(printf '%s' "$layout" | awk '{printf toupper(substr($0,1,2))}')
fi

sketchybar --set "$NAME" label="$label"
