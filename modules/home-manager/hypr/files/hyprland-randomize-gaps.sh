#!/bin/bash

# Randomize the outer gaps to keep static content off the OLED edges.
#
# `hyprctl keyword` is rejected by the Lua config parser ("keyword can't work
# with non-legacy parsers"), so evaluate an hl.config() call instead.

TOP_GAP=$((300 + RANDOM % 50))
BOTTOM_GAP=$((200 + RANDOM % 50))

hyprctl eval "hl.config({ general = { gaps_out = { top = $TOP_GAP, right = 16, bottom = $BOTTOM_GAP, left = 16 } } })"
