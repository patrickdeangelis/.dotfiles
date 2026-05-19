#!/bin/bash

sketchybar --add item ble_monitor right                                \
           --set ble_monitor icon="$ICON_AIRPODS"                      \
                              label.drawing=off                        \
                              background.drawing=off                   \
                              script="$PLUGIN_DIR/ble_monitor.sh"      \
                              update_freq=10                           \
                              drawing=off
