#!/usr/bin/env bash

# Toggle: black wallpaper, no borders, scale 1 (so gamescope's -W/-H are real
# pixels). Setting the wallpaper makes noctalia reload hyprland, which discards
# any `hyprctl eval` made before it, hence the wait for the template rewrite.
# `hyprctl keyword` is rejected by the lua parser, so eval is the way in.

set -uo pipefail

dir="${XDG_STATE_HOME:-$HOME/.local/state}/gaming-mode"
saved="$dir/saved"
black="$dir/black.png"
template="$HOME/.config/hypr/noctalia.lua"

read -r mon res < <(hyprctl monitors |
    awk '/^Monitor /{n=$2} /^\t[0-9]+x[0-9]+@/{split($1,a,"@"); print n, a[1]; exit}')

apply() { # <wallpaper> <border> <scale>
    local stamp i
    stamp=$(stat -c %Y "$template")
    noctalia msg wallpaper-set "$mon" "$1" >/dev/null
    for ((i = 0; i < 40; i++)); do
        [ "$(stat -c %Y "$template")" != "$stamp" ] && break
        sleep 0.25
    done
    sleep 1
    hyprctl eval "hl.config({ general = { border_size = $2 } })" >/dev/null
    hyprctl eval "hl.monitor({ output = '$mon', scale = $3 })" >/dev/null
}

if [ -f "$saved" ]; then
    # Line-wise, because wallpaper filenames contain spaces.
    {
        read -r wallpaper
        read -r border
        read -r scale
    } <"$saved"
    apply "$wallpaper" "$border" "$scale"
    rm -f "$saved"
else
    mkdir -p "$dir"
    {
        noctalia msg wallpaper-get "$mon"
        hyprctl getoption general:border_size | awk '/int:/{print $2}'
        hyprctl monitors | awk '/scale:/{print $2; exit}'
    } >"$saved"
    [ -f "$black" ] || ffmpeg -y -loglevel error -f lavfi -i "color=c=black:s=$res" -frames:v 1 "$black"
    apply "$black" 0 1
fi
