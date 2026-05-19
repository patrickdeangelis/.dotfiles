#!/bin/bash

sketchybar --add item cpu_monitor right                                \
           --set cpu_monitor icon="$ICON_CPU"                          \
                              label.font="$FONT_SMALL"               \
                              script="$PLUGIN_DIR/cpu_monitor.sh"     \
                              update_freq=5
