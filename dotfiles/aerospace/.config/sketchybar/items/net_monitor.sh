#!/bin/bash

sketchybar --add item net_monitor right                                \
           --set net_monitor icon="$ICON_NET"                          \
                              label.font="$FONT_TINY"                \
                              script="$PLUGIN_DIR/net_monitor.sh"     \
                              update_freq=2
