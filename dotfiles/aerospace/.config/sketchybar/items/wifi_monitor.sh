#!/bin/bash

sketchybar --add item wifi_monitor right                               \
           --set wifi_monitor icon="$ICON_WIFI"                        \
                               label.font="$FONT_SMALL"              \
                               script="$PLUGIN_DIR/wifi_monitor.sh"   \
                               update_freq=10
