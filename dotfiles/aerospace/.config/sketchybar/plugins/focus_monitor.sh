#!/bin/sh

monitor="$1"

sketchybar_bin="sketchybar"
if [ -x /opt/homebrew/bin/sketchybar ]; then
  sketchybar_bin="/opt/homebrew/bin/sketchybar"
elif [ -x /usr/local/bin/sketchybar ]; then
  sketchybar_bin="/usr/local/bin/sketchybar"
fi

aerospace_bin="aerospace"
if [ -x /opt/homebrew/bin/aerospace ]; then
  aerospace_bin="/opt/homebrew/bin/aerospace"
elif [ -x /usr/local/bin/aerospace ]; then
  aerospace_bin="/usr/local/bin/aerospace"
fi

if [ -z "$monitor" ]; then
  exit 0
fi

app=$(
  "$aerospace_bin" list-windows --monitor "$monitor" --format '%{workspace-is-visible} %{app-name}' 2>/dev/null \
    | awk '$1 == "true" { $1=""; sub(/^ /, ""); print; exit }'
)

if [ -z "$app" ]; then
  "$sketchybar_bin" --set "$NAME" icon="" label=""
  exit 0
fi

if [ -x "$CONFIG_DIR/plugins/icon_map_fn.sh" ]; then
  icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  if [ -z "$icon" ] || [ "$icon" = ":default:" ]; then
    "$sketchybar_bin" --set "$NAME" icon="$app" label="$app"
  else
    "$sketchybar_bin" --set "$NAME" icon="$icon" label="$app"
  fi
else
  "$sketchybar_bin" --set "$NAME" label="$app"
fi
