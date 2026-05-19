#!/bin/bash

sketchybar --add item input_monitor right                              \
           --set input_monitor icon="$ICON_LAYOUT"                     \
                              label.font="$FONT_TINY"                \
                              script="$PLUGIN_DIR/input_monitor.sh"   \
                              update_freq=10
