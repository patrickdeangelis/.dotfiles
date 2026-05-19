#!/bin/bash

sketchybar --add item disk_monitor right                               \
           --set disk_monitor icon="$ICON_DISK"                        \
                               label.font="$FONT_SMALL"              \
                               script="$PLUGIN_DIR/disk_monitor.sh"   \
                               update_freq=60
