#!/usr/bin/env sh

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
PLUGIN_DIR="${PLUGIN_DIR:-$CONFIG_DIR/plugins}"
FONT="${FONT:-JetBrainsMono Nerd Font:Bold:12.0}"

if [ -f "$CONFIG_DIR/colors.sh" ]; then
  source "$CONFIG_DIR/colors.sh"
fi

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

"$sketchybar_bin" --add event aerospace_workspace_change

add_space_item() {
  sid="$1"
  mid="$2"
  focused="$3"
  visible="$4"
  "$sketchybar_bin" --add item "space.$sid" left                                \
                    --subscribe "space.$sid" aerospace_workspace_change         \
                    --set "space.$sid"                                          \
                        associated_display="$mid"                               \
                        icon="$sid"                                             \
                        icon.font="$FONT"                                       \
                        label.drawing=off                                       \
                        update_freq=2                                           \
                        script="$PLUGIN_DIR/aerospacer.sh $sid"                 \
                        click_script="aerospace workspace $sid"

  if [ "$focused" = "true" ]; then
    "$sketchybar_bin" --set "space.$sid" background.drawing=on \
                      background.color=$COLOR_PILL_STRONG \
                      label.color=$WHITE \
                      icon.color=$WHITE
  elif [ "$visible" = "true" ]; then
    "$sketchybar_bin" --set "space.$sid" background.drawing=on \
                      background.color=$COLOR_PILL \
                      label.color=$DIM_WHITE \
                      icon.color=$DIM_WHITE
  else
    "$sketchybar_bin" --set "space.$sid" background.drawing=off \
                      label.color=$DIM_WHITE \
                      icon.color=$DIM_WHITE
  fi
}

refresh_spaces() {
  show_empty="${SHOW_EMPTY_WORKSPACES:-false}"
  "$aerospace_bin" list-workspaces --all --format '%{workspace} %{monitor-id} %{workspace-is-focused} %{workspace-is-visible}' | \
    while read -r sid mid focused visible; do
      if [ -z "$sid" ]; then
        continue
      fi

      if "$sketchybar_bin" --query "space.$sid" >/dev/null 2>&1; then
        if [ -n "$mid" ]; then
          "$sketchybar_bin" --set "space.$sid" associated_display="$mid"
        fi
        continue
      fi

      include="false"
      if [ "$show_empty" = "true" ] || [ "$focused" = "true" ]; then
        include="true"
      else
        windows_count=$($aerospace_bin list-windows --workspace "$sid" --count 2>/dev/null | tr -d ' ')
        if [ -n "$windows_count" ] && [ "$windows_count" -gt 0 ]; then
          include="true"
        fi
      fi

      if [ "$include" = "true" ]; then
        add_space_item "$sid" "$mid" "$focused" "$visible"
      fi
    done
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  refresh_spaces
  exit 0
fi

for sid in $($aerospace_bin list-workspaces --all); do
  "$sketchybar_bin" --remove "space.$sid" 2>/dev/null || true
done

MONITOR_IDS=$($aerospace_bin list-monitors | awk '{print $1}')

for mid in $MONITOR_IDS; do
  "$aerospace_bin" list-workspaces --monitor "$mid" --format '%{workspace} %{workspace-is-focused} %{workspace-is-visible}' | \
    while read -r sid focused visible; do
      show_empty="${SHOW_EMPTY_WORKSPACES:-false}"
      include="false"
      if [ "$show_empty" = "true" ] || [ "$focused" = "true" ]; then
        include="true"
      else
        windows_count=$($aerospace_bin list-windows --workspace "$sid" --count 2>/dev/null | tr -d ' ')
        if [ -n "$windows_count" ] && [ "$windows_count" -gt 0 ]; then
          include="true"
        fi
      fi

      if [ "$include" = "true" ]; then
        add_space_item "$sid" "$mid" "$focused" "$visible"
      fi
    done
done
