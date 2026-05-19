#!/bin/bash

sketchybar --add event aerospace_workspace_change

MONITORS=$(aerospace list-monitors | awk '{print $3}')
HAS_THIRD_MONITOR=$(echo "$MONITORS" | grep -c "Display \(2\)")
MONITOR_IDS=$(aerospace list-monitors | awk '{print $1}')

for mid in $MONITOR_IDS; do
  for sid in $(aerospace list-workspaces --monitor $mid); do
    if [ "$HAS_THIRD_MONITOR" -eq 0 ]; then
      case "$sid" in
        q|w|e|r|t|6|7|8|9|10) continue;;
      esac
    fi

    sketchybar --add item "space.$sid" left                              \
               --subscribe "space.$sid" aerospace_workspace_change       \
               --set "space.$sid"                                        \
                   icon="$sid"                                           \
                   label.drawing=off                                     \
                   background.drawing=off                                \
                   associated_display=$mid                               \
                   script="$PLUGIN_DIR/aerospacer.sh $sid"               \
                   click_script="aerospace workspace $sid"
  done
done
