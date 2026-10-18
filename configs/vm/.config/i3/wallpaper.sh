#!/bin/sh
# feh sets the X11 root pixmap and exits; no resident wallpaper daemon needed.
# Override with I3_WALLPAPER_DIR, or place your images in ~/wallpapers.
set -eu
xsetroot -solid '#171c20'
wallpapers=${I3_WALLPAPER_DIR:-"$HOME/wallpapers"}
[ -d "$wallpapers" ] || exit 0
# Pass paths as arguments, including names containing spaces. First image wins.
find "$wallpapers" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) -exec sh -c '
    [ "$#" -gt 0 ] || exit 0
    exec feh --no-fehbg --bg-fill "$1"
' sh {} \; -quit
