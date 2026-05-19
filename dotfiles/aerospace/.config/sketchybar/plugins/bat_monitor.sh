#!/bin/bash

info=$(pmset -g batt 2>/dev/null | tail -n 1)
percent=$(printf '%s' "$info" | awk -F';' '{print $1}' | awk '{print $NF}')
status=$(printf '%s' "$info" | awk -F';' '{print $2}' | xargs)

label="$percent"
case "$status" in
  charging*|charged*|finishing*)
    label="${percent}+"
    ;;
  *)
    label="$percent"
    ;;
esac

if [ -z "$percent" ]; then
  label="--"
fi

sketchybar --set "$NAME" label="$label"
