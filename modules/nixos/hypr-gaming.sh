#!/usr/bin/env bash

# Run a game with the compositor out of the way, then put everything back.
#
#   hypr-gaming gamemoderun mangohud %command%
#
# Rounding, opacity and blur each force hyprland to composite the game instead
# of handing its buffer straight to the display, and the bar counts as an
# overlay. With them on, `hyprctl monitors` reports
#   solitaryBlockedBy: not opaque,other overlays
# and render:direct_scanout never engages. Scale drops to 1 so a native Wayland
# game renders at 3840x2160 rather than 3072x1728 upscaled; XWayland games are
# already covered by xwayland.force_zero_scaling in monitors.lua.
#
# Restore is `hyprctl reload`, so "normal" is whatever monitors.lua and
# looknfeel.lua say and nothing is written to disk. `hyprctl keyword` is
# rejected by the lua parser, so eval is the way in.

MONITOR="HDMI-A-2"
NATIVE_MODE="3840x2160@120"

set -uo pipefail

mode="$NATIVE_MODE"

# --res <mode> for 21:9, e.g. `hypr-gaming --res 3840x1600@59.96 ...`.
#
# Pick the refresh from what the EDID actually has -- `hyprctl monitors all`
# lists availableModes. The C2 only offers 3840x1600 at 59.96, so 3840x1600@120
# does not exist: hyprland takes it, says ok, and silently gives you 59.96. The
# 21:9 mode that does run at 120 is 2560x1080. So it is width or refresh, not
# both, and staying at native 3840x2160@120 with the game letterboxing itself is
# usually the better trade.
if [ "${1-}" = "--res" ]; then
	mode="$2"
	shift 2
fi

restore() {
	hyprctl reload >/dev/null || true
	noctalia msg bar-show >/dev/null || true
}
trap restore EXIT INT TERM

hyprctl eval "hl.config({
	decoration = { rounding = 0, active_opacity = 1, inactive_opacity = 1, blur = { enabled = false } },
	animations = { enabled = false },
	general = { border_size = 0, gaps_in = 0, gaps_out = 0 },
})" >/dev/null || true

# Partial spec: hyprland merges it, so bitdepth/cm/vrr from monitors.lua stay.
hyprctl eval "hl.monitor({ output = '$MONITOR', mode = '$mode', scale = 1 })" >/dev/null || true

# An unavailable refresh is not an error, it is a quiet downgrade, so report what
# the display actually ended up on rather than what was asked for.
printf 'hypr-gaming: %s\n' "$(hyprctl monitors | sed -n '2p' | xargs)" >&2

# bar-hide rather than auto-hide -- auto-hide leaves the layer up, and the layer
# is what blocks solitary.
noctalia msg bar-hide >/dev/null || true

"$@"
