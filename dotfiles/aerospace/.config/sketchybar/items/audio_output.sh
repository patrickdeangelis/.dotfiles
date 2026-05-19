#!/bin/bash

sketchybar --add item audio_output right                              \
           --set audio_output icon="$ICON_AUDIO"                      \
                              label.font="$FONT_TINY"                 \
                              script="$PLUGIN_DIR/audio_output.sh"    \
                              update_freq=5
