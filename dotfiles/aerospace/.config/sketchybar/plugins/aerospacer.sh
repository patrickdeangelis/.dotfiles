#!/bin/bash

source "$CONFIG_DIR/colors.sh"

workspace="$1"
focused="${FOCUSED_WORKSPACE}"
if [ -z "$focused" ]; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null)"
fi

visible="$(aerospace list-workspaces --all --format '%{workspace} %{workspace-is-visible}' 2>/dev/null | awk -v w="$workspace" '$1 == w { print $2; exit }')"

windows_count="$(aerospace list-windows --workspace "$workspace" 2>/dev/null | wc -l | tr -d ' ')"
has_windows=false
if [ -n "$windows_count" ] && [ "$windows_count" -gt 0 ]; then
  has_windows=true
fi

if [ "$workspace" != "$focused" ] && [ "$has_windows" = "false" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$workspace" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                         background.color=$COLOR_PILL_STRONG \
                         label.color=$WHITE \
                         drawing=on \
                         icon.color=$WHITE
elif [ "$visible" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                         background.color=$COLOR_PILL \
                         label.color=$DIM_WHITE \
                         drawing=on \
                         icon.color=$DIM_WHITE
else
  sketchybar --set "$NAME" background.drawing=off \
                         label.color=$DIM_WHITE \
                         drawing=on \
                         icon.color=$DIM_WHITE
fi
