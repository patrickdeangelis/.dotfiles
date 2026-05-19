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

MONITOR_IDS=$($aerospace_bin list-monitors | awk '{print $1}')
MAIN_MONITOR_ID=$($aerospace_bin list-monitors | awk '/ main$/ {print $1; exit}')
if [ -z "$MAIN_MONITOR_ID" ]; then
  MAIN_MONITOR_ID=$(echo "$MONITOR_IDS" | awk 'NR==1 {print $1; exit}')
fi
MONITOR_COUNT=$(echo "$MONITOR_IDS" | wc -l | tr -d ' ')

# Build mapping from aerospace monitor-id to sketchybar arrangement-id.
# Aerospace and sketchybar may number monitors differently, so we match
# by identifying the built-in display (known UUID) in sketchybar and
# the "Built-in" name in aerospace.
BUILTIN_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"

AERO_SKETCH_MAP=$(/usr/bin/python3 -c "
import json, subprocess, sys

# Get sketchybar displays
try:
    sb = json.loads(subprocess.check_output(['$sketchybar_bin', '--query', 'displays'], stderr=subprocess.DEVNULL))
except:
    sys.exit(0)

# Get aerospace monitors: id -> name
try:
    aero_out = subprocess.check_output(['$aerospace_bin', 'list-monitors', '--format', '%{monitor-id} %{monitor-name}'], stderr=subprocess.DEVNULL).decode()
except:
    sys.exit(0)

aero_monitors = {}
for line in aero_out.strip().split('\n'):
    parts = line.split(' ', 1)
    if len(parts) == 2:
        aero_monitors[parts[0]] = parts[1]

# Find builtin in sketchybar
sb_builtin_aid = None
sb_external = []
for d in sb:
    if d.get('UUID') == '$BUILTIN_UUID':
        sb_builtin_aid = d['arrangement-id']
    else:
        sb_external.append(d['arrangement-id'])

# Find builtin in aerospace
aero_builtin_mid = None
aero_external = []
for mid, name in aero_monitors.items():
    if 'Built-in' in name:
        aero_builtin_mid = mid
    else:
        aero_external.append(mid)

# Output mapping lines: aero_id=sketch_id
if sb_builtin_aid is not None and aero_builtin_mid is not None:
    print(f'{aero_builtin_mid}={sb_builtin_aid}')
# Pair external monitors (works for 1-2 externals)
for a, s in zip(aero_external, sb_external):
    print(f'{a}={s}')
" 2>/dev/null)

map_aero_to_sketch() {
  local aero_id="$1"
  local mapped
  mapped=$(echo "$AERO_SKETCH_MAP" | awk -F= -v id="$aero_id" '$1 == id {print $2; exit}')
  if [ -n "$mapped" ]; then
    echo "$mapped"
  else
    echo "$aero_id"
  fi
}

is_connected_monitor() {
  target="$1"
  for id in $MONITOR_IDS; do
    if [ "$id" = "$target" ]; then
      return 0
    fi
  done
  return 1
}

order_workspaces() {
  awk '
    BEGIN {
      n = split("1 2 3 4 5 6 7 8 9 10 q w e r t y u i o p a s d f g h j k l z x c v b n m", arr, " ");
      for (i = 1; i <= n; i++) {
        order[arr[i]] = i;
      }
    }
    {
      w = $1;
      if (w in order) {
        key = sprintf("%03d", order[w]);
      } else {
        key = "999" w;
      }
      print key, $0;
    }
  ' | sort -k1,1 | cut -d' ' -f2-
}

"$sketchybar_bin" --add event aerospace_workspace_change

add_space_item() {
  _asi_sid="$1"
  _asi_display="$(map_aero_to_sketch "$2")"
  _asi_focused="$3"
  _asi_visible="$4"
  "$sketchybar_bin" --add item "space.$_asi_sid" left                           \
                    --subscribe "space.$_asi_sid" aerospace_workspace_change    \
                    --set "space.$_asi_sid"                                     \
                        associated_display="$_asi_display"                      \
                        icon="$_asi_sid"                                        \
                        icon.font="$FONT"                                       \
                        label.drawing=off                                       \
                        update_freq=2                                           \
                        script="$PLUGIN_DIR/aerospacer.sh $_asi_sid"            \
                        click_script="aerospace workspace $_asi_sid"

  if [ "$_asi_focused" = "true" ]; then
    "$sketchybar_bin" --set "space.$_asi_sid" background.drawing=on \
                      background.color=$COLOR_PILL_STRONG \
                      label.color=$WHITE \
                      icon.color=$WHITE
  elif [ "$_asi_visible" = "true" ]; then
    "$sketchybar_bin" --set "space.$_asi_sid" background.drawing=on \
                      background.color=$COLOR_PILL \
                      label.color=$DIM_WHITE \
                      icon.color=$DIM_WHITE
  else
    "$sketchybar_bin" --set "space.$_asi_sid" background.drawing=off \
                      label.color=$DIM_WHITE \
                      icon.color=$DIM_WHITE
  fi
}

refresh_spaces() {
  show_empty="${SHOW_EMPTY_WORKSPACES:-false}"
  "$aerospace_bin" list-workspaces --all --format '%{workspace} %{monitor-id} %{workspace-is-focused} %{workspace-is-visible}' | \
    order_workspaces | \
    while read -r sid mid focused visible; do
      if [ -z "$sid" ]; then
        continue
      fi

      if "$sketchybar_bin" --query "space.$sid" >/dev/null 2>&1; then
        effective_mid="$mid"
        if [ -z "$effective_mid" ] || ! is_connected_monitor "$effective_mid"; then
          effective_mid="$MAIN_MONITOR_ID"
        fi
        if [ -n "$effective_mid" ]; then
          "$sketchybar_bin" --set "space.$sid" associated_display="$(map_aero_to_sketch "$effective_mid")"
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
        effective_mid="$mid"
        if [ -z "$effective_mid" ] || ! is_connected_monitor "$effective_mid"; then
          effective_mid="$MAIN_MONITOR_ID"
        fi
        add_space_item "$sid" "$effective_mid" "$focused" "$visible"
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

if [ "$MONITOR_COUNT" -le 1 ]; then
  "$aerospace_bin" list-workspaces --all --format '%{workspace} %{workspace-is-focused} %{workspace-is-visible}' | \
    order_workspaces | \
    while read -r sid focused visible; do
      if [ -z "$sid" ]; then
        continue
      fi

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
        add_space_item "$sid" "$MAIN_MONITOR_ID" "$focused" "$visible"
      fi
    done
else
  for mid in $MONITOR_IDS; do
    "$aerospace_bin" list-workspaces --monitor "$mid" --format '%{workspace} %{workspace-is-focused} %{workspace-is-visible}' | \
      order_workspaces | \
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
fi
