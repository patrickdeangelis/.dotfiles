#!/bin/bash

get_audio_output() {
  if command -v SwitchAudioSource >/dev/null 2>&1; then
    SwitchAudioSource -c 2>/dev/null
    return
  fi

  if [ -x /opt/homebrew/bin/SwitchAudioSource ]; then
    /opt/homebrew/bin/SwitchAudioSource -c 2>/dev/null
    return
  fi

  if [ -x /usr/local/bin/SwitchAudioSource ]; then
    /usr/local/bin/SwitchAudioSource -c 2>/dev/null
    return
  fi

  return 1
}

device=$(get_audio_output)
if [ -z "$device" ]; then
  device="--"
fi

sketchybar --set "$NAME" label="$device"
