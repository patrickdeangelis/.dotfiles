#!/bin/bash

sketchybar_bin="sketchybar"
if [ -x /opt/homebrew/bin/sketchybar ]; then
  sketchybar_bin="/opt/homebrew/bin/sketchybar"
elif [ -x /usr/local/bin/sketchybar ]; then
  sketchybar_bin="/usr/local/bin/sketchybar"
fi

aerospace_bin="aerospace"
if [ -x /opt/homebrew/bin/aerospace ]; then
  aerospace_bin="/opt/homebrew/bin/aerospace"
elif [ -x /usr/local/bin/aerospace ]; then
  aerospace_bin="/usr/local/bin/aerospace"
fi

"$sketchybar_bin" --remove focus_monitor 2>/dev/null || true

MONITOR_IDS=$($aerospace_bin list-monitors | awk '{print $1}')

for mid in $MONITOR_IDS; do
  "$sketchybar_bin" --add item "focus_monitor.$mid" left                                \
                     --set "focus_monitor.$mid" icon=""                                  \
                                            icon.font="sketchybar-app-font:Regular:14.0" \
                                            label.font="$FONT_SMALL"               \
                                            background.color=$COLOR_PILL_STRONG      \
                                            display="$mid"                            \
                                            script="$PLUGIN_DIR/focus_monitor.sh $mid"   \
                     --subscribe "focus_monitor.$mid" front_app_switched aerospace_workspace_change
done
