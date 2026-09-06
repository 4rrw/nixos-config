#!/usr/bin/env bash
# Freeze the screen, pick a region or window, copy to the clipboard and save.
# Same approach as omarchy: grim captures, slurp selects, hyprpicker freezes,
# satty annotates. Usage: screenshot.sh [smart|region|fullscreen]

OUT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$OUT_DIR"

# A second press cancels an in-progress selection rather than starting another.
pkill slurp && exit 0

MODE="${1:-smart}"

annotate() {
  satty --filename "$1" --output-filename "$1" \
    --actions-on-enter save-to-clipboard --save-after-copy --copy-command wl-copy
}

# Reopen the most recent shot. The notification below is the quick path; this is
# the one that still works once the toast is gone.
if [[ $MODE == edit ]]; then
  LAST=$(ls -t "$OUT_DIR"/*.png 2>/dev/null | head -1)
  [[ -z $LAST ]] && exit 0
  annotate "$LAST"
  exit $?
fi

# Width and height are logical pixels, so divide by scale; on a rotated monitor
# transform 1 and 3 are the 90-degree ones, which swap the two.
MONITOR_GEO='
  def geo:
    if .transform == 1 or .transform == 3
    then "\(.x),\(.y) \(.height / .scale | floor)x\(.width / .scale | floor)"
    else "\(.x),\(.y) \(.width / .scale | floor)x\(.height / .scale | floor)"
    end;
'

# Every monitor and window on the active workspace as slurp rectangles, which
# is what lets a click snap to the thing under the cursor.
rectangles() {
  local ws
  ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')
  hyprctl monitors -j | jq -r --argjson ws "$ws" "$MONITOR_GEO"' .[] | select(.activeWorkspace.id == $ws) | geo'
  hyprctl clients -j | jq -r --argjson ws "$ws" '.[] | select(.workspace.id == $ws) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

# hyprpicker -r -z paints a frozen copy of the screen so nothing animates while
# you drag. It has to outlive slurp, or grim captures the teardown instead.
freeze() {
  hyprpicker -r -z >/dev/null 2>&1 &
  FREEZE_PID=$!
  sleep 0.1
}

# A software-composited cursor is drawn into the framebuffer, so grim captures
# it even though it never asked for a cursor. Force hardware cursors for the
# duration and put the setting back afterwards.
NO_HW_CURSORS=$(hyprctl getoption cursor:no_hardware_cursors -j | jq '.int')
set_no_hw_cursors() {
  hyprctl eval "hl.config({ cursor = { no_hardware_cursors = $1 } })" &>/dev/null ||
    hyprctl keyword cursor:no_hardware_cursors "$1" &>/dev/null
}
cleanup() {
  [[ -n ${FREEZE_PID:-} ]] && kill "$FREEZE_PID" 2>/dev/null
  set_no_hw_cursors "$NO_HW_CURSORS"
}
trap cleanup EXIT
set_no_hw_cursors 0

case "$MODE" in
fullscreen)
  REGION=$(hyprctl monitors -j | jq -r "$MONITOR_GEO"' .[] | select(.focused) | geo')
  ;;
region)
  freeze
  REGION=$(slurp 2>/dev/null)
  ;;
smart | *)
  RECTS=$(rectangles)
  freeze
  REGION=$(echo "$RECTS" | slurp 2>/dev/null)

  # A click that registers as a tiny drag would capture a few pixels. Treat
  # anything under 20 square pixels as "select whatever is under the cursor".
  if [[ $REGION =~ ^([0-9]+),([0-9]+)\ ([0-9]+)x([0-9]+)$ ]] &&
    ((BASH_REMATCH[3] * BASH_REMATCH[4] < 20)); then
    x=${BASH_REMATCH[1]} y=${BASH_REMATCH[2]}
    while IFS= read -r rect; do
      [[ $rect =~ ^([0-9]+),([0-9]+)\ ([0-9]+)x([0-9]+)$ ]] || continue
      if ((x >= BASH_REMATCH[1] && x < BASH_REMATCH[1] + BASH_REMATCH[3] &&
        y >= BASH_REMATCH[2] && y < BASH_REMATCH[2] + BASH_REMATCH[4])); then
        REGION=$rect
        break
      fi
    done <<<"$RECTS"
  fi
  ;;
esac

[[ -z $REGION ]] && exit 0

FILE="$OUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
grim -g "$REGION" "$FILE" || exit 1
wl-copy --type image/png <"$FILE"

# Annotation is opt-in: the shot is already saved and on the clipboard, and
# satty only opens if the notification is clicked.
(
  action=$(notify-send "Screenshot copied and saved" "Click to annotate, or SUPER + ALT + PRINT" \
    -t 30000 -i "$FILE" -A "default=Annotate")
  [[ $action == default ]] && annotate "$FILE"
) >/dev/null 2>&1 &
