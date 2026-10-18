#!/bin/sh
# Preserve Arch's X session hooks (D-Bus/systemd environment, etc.).
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for hook in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ ! -x "$hook" ] || . "$hook"
    done
fi
export XCURSOR_SIZE=24
# Also makes the existing Ghostty config use Fish without changing login shells.
export SHELL=/usr/bin/fish
exec i3
