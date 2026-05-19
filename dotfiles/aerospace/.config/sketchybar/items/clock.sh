#!/bin/bash

sketchybar --add item clock right                                      \
           --set clock icon="$ICON_CLOCK"                              \
                      label.font="$FONT_SMALL"                        \
                      background.color=$COLOR_PILL_STRONG              \
                      script="$PLUGIN_DIR/clock.sh"                   \
                      update_freq=30
