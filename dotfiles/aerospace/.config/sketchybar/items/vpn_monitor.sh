#!/bin/bash

sketchybar --add item vpn_monitor right                                \
           --set vpn_monitor icon="$ICON_VPN"                          \
                              label.font="$FONT_TINY"                \
                              script="$PLUGIN_DIR/vpn_monitor.sh"     \
                              update_freq=10
