#!/bin/bash

sketchybar --add item sys_monitor right                                \
           --set sys_monitor icon="$ICON_SYS"                          \
                              label.font="$FONT_TINY"                \
                              script="$PLUGIN_DIR/sys_monitor.sh"     \
                              update_freq=60
