#!/bin/bash

sketchybar --add item bat_monitor right                                \
           --set bat_monitor icon="$ICON_BAT"                          \
                              label.font="$FONT_SMALL"               \
                              script="$PLUGIN_DIR/bat_monitor.sh"     \
                              update_freq=30
