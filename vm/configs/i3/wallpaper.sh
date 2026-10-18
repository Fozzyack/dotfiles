#!/bin/sh
# feh sets the X11 root pixmap and exits; no resident wallpaper daemon needed.
# Use the selected wallpaper; keep a charcoal background if it is missing.
set -eu
xsetroot -solid '#171c20'
wallpaper="$HOME/wallpapers/retro-anime-research-station-4k.png"
[ -f "$wallpaper" ] || exit 0
exec feh --no-fehbg --bg-fill "$wallpaper"
