# Lightweight i3 VM

This profile targets an existing **Arch Linux** VM with networking, a normal
user, and `sudo` configured. Suggested starting size: **2 vCPUs, 2–4 GiB RAM,
20 GiB disk**. It uses Xorg/i3, Ghostty, Fish, Rofi, Thunar, i3bar/i3status,
Dunst and feh. No compositor, Hyprland, Waybar or GTK widgets are started.

## Setup with Temperz

```sh
git clone https://github.com/Fozzyack/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo pacman -Syu
./temperz
```

1. Select **6 — Install VM deps**, then Enter to install all commands.
2. Select **5 — Setup VM**, then Enter to select all and confirm the preview.
3. From a local VM console, run `startx`. With an existing display manager,
   select its i3 session instead; no display manager is installed by this profile.

The VM menu links `configs/vm/.config` to `~/.config` and `.xinitrc` to
`~/.xinitrc`. **Do not create `~/.config` before VM setup.** Temperz skips
existing paths instead of merging or replacing them. If either already exists,
review it and move it to a backup before setup, or manually copy only the wanted
subdirectories from `configs/vm/.config/` into your existing configuration.
Also check for an older `~/.i3/config`, which takes precedence over the new config.
Keep this repository in place because the installed paths are symlinks.

Ghostty, Fish, Rofi, Starship and Fastfetch are independent copies of the existing
configs. Changes to the main profile do not automatically update the VM copies.
Fastfetch is installed and displayed by the existing Fish greeting. The Go
package dependency and `exa` compatibility link support the unchanged Fish config.
Ghostty explicitly launches Fish via the i3 terminal shortcut; the login shell
is not changed. Optional personal shell helpers still expect `~/dotfiles`.

### Shortcuts and styling

The main modifier is **Alt**, matching Hyprland:

| Shortcut | Action |
| --- | --- |
| Alt+Enter / C / E / R | Ghostty / close / Thunar / Rofi |
| Alt+arrows or H/J/K/L | Focus left/right/up/down (J is right, matching the supplied config) |
| Alt+1…0 / Alt+Shift+1…0 | Switch workspace / move window |
| Alt+V / F | Toggle floating / fullscreen |
| Alt+S / Alt+Shift+S | Show scratchpad / send window to scratchpad |
| Alt+Shift+J / Alt+P | Toggle split direction / split-tabbed layout |
| Alt+drag left/right button | Move floating window / resize |
| Alt+Shift+C / R / E | Reload config / restart i3 / confirm logout |

Alt+scroll over a window cycles workspaces. Volume, brightness and media keys
match Hyprland where the VM exposes the necessary devices. Orange borders,
charcoal/cream/teal colours, 3px inner gaps and 10px outer gaps match the desktop
palette. i3 has no direct pseudo-tiling equivalent. Split toggling uses
Alt+Shift+J to avoid Hyprland's duplicate Alt+J binding. i3's Alt+Enter binding
takes precedence over Ghostty's own fullscreen shortcut; use Alt+F instead.

### Wallpapers

Put PNG/JPEG/WebP images in `~/wallpapers/`. On login and i3 restart,
`~/.config/i3/wallpaper.sh` runs **feh** to fill the screen with the first image
found. No images are bundled; without them, the background is solid charcoal.
feh sets the wallpaper and exits rather than keeping a daemon running.
Set `I3_WALLPAPER_DIR` in `.xinitrc` to use a different directory. Reapply after
adding images with `sh ~/.config/i3/wallpaper.sh`.

For QEMU/SPICE, optionally install `spice-vdagent` for guest integration.
VirtualBox users should instead install the matching VirtualBox guest tools.

## Existing OpenGL troubleshooting notes

> [!NOTE]
> This seems to be like a nvidia issue (as per usual)

Currently - due to OpenGL limits on windows QEMU the OpenGL version seems to be stuck at 
4.2 whereas some applications need version 4.3+.

> [!INFO]
> It seems like this is a known VirGL design limitation that has affected nvidia users for years

A workaround to this is to set:

```
MESA_GL_VERSION_OVERRIDE 4.3
MESA_GLSL_VERSION_OVERRIDE 430
```

You can set it in hyprland or in `~/.profile` (though it depends on how you start the desktop env / window manager)
e.g
`export MESA_GL_VERSION_OVERRIDE 4.3`
