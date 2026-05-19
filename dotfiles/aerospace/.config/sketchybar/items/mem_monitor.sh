#!/bin/bash

sketchybar --add item mem_monitor right                                \
           --set mem_monitor icon="$ICON_MEM"                          \
                              label.font="$FONT_SMALL"               \
                              script="$PLUGIN_DIR/mem_monitor.sh"     \
                              update_freq=5
