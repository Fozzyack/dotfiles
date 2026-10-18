# Lightweight i3 VM

This profile targets an existing **Arch Linux** VM with networking, a normal
user, and `sudo` configured. Suggested starting size: **2 vCPUs, 2–4 GiB RAM,
20 GiB disk**. It uses Xorg/i3, Ghostty, Fish, Rofi, Thunar, i3bar/i3status,
Dunst, feh and Picom. No Hyprland, Waybar or GTK widgets are started.

## Setup with Temperz

```sh
git clone https://github.com/Fozzyack/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo pacman -Syu
mkdir -p ~/.config
./temperz
```

1. Select **5 — Setup VM**, then Enter to select all and confirm the preview.
2. Select **6 — Install VM deps**, then Enter to install all commands.
3. From a local VM console, run `startx`. With an existing display manager,
   select its i3 session instead; no display manager is installed by this profile.

The VM menu links each entry in `vm/configs/` into `~/.config/`, and
`vm/home/.xinitrc` to `~/.xinitrc`. Dependencies come from `vm/install.config`.
Create `~/.config` before setup; its existing contents are preserved. Temperz
skips existing destination entries (such as `~/.config/fish` or `~/.xinitrc`)
instead of merging or replacing them. Review and back up only the conflicting
entries if you want to replace them with the VM profile.
Also check for an older `~/.i3/config`, which takes precedence over the new config.
Keep this repository in place because the installed paths are symlinks.

Use a Temperz build supporting `vm/home/` and `vm/configs/`; older builds scan
`configs/vm/` instead and will not find this profile.

If you installed the old layout, existing links into `configs/vm/` now point at
the old location. Check them with `readlink ~/.config` and `readlink ~/.xinitrc`.
Only if they are symlinks into that old profile, unlink those symlinks (not their
targets), recreate `~/.config` as a directory, and run Setup VM again. Leave real
directories and unrelated symlinks untouched.

Ghostty, Fish, Rofi, Starship and Fastfetch are independent copies of the existing
configs. Changes to the main profile do not automatically update the VM copies.
Fastfetch is installed and displayed by the existing Fish greeting. The Go
package dependency and `exa` compatibility link support the unchanged Fish config.
Ghostty explicitly launches Fish via the i3 terminal shortcut; the login shell
is not changed. Optional personal shell helpers still expect `~/dotfiles`.

### Neovim dependencies

Run Setup VM **before** Install VM deps: the final dependency command checks that
`~/.config/nvim` (or `$XDG_CONFIG_HOME/nvim`) links to this VM profile so it cannot
accidentally bootstrap an unrelated editor config. Run Temperz from this repository's root.

The dependency list includes compilers, archive/download tools, Node/npm, Python
with pip/virtualenv, Go, Zig, .NET, CMake, the Tree-sitter CLI, ripgrep and the
X11 clipboard provider (`xclip`). The final command synchronizes Lazy plugins,
installs configured language servers and formatters through Mason (including
Roslyn, but excluding `rzls`), and waits for the configured Tree-sitter parsers to compile.
Internet access is required; this can take several minutes and uses additional
disk space beyond the lightweight desktop. Failed tool installs stop the command;
check `:MasonLog`, fix the reported issue and rerun the final dependency command.

After installation, use `:checkhealth`, `:Mason` and `:ConformInfo` to inspect the
editor. NeoCodeium authentication remains manual (`:NeoCodeium auth`) if you
choose to enable that optional plugin.

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

### Terminal transparency

Picom starts with i3 and displays Ghostty's existing 70% background opacity
without making text translucent. It uses GLX with dual-Kawase background blur
(strength 5), with shadows and fading disabled. Ghostty's config is unchanged.
Blur requires working OpenGL in the VM; if it causes rendering problems, change
`backend` to `"xrender"` and remove the `blur` block in
`vm/configs/i3/picom.conf`.

For an existing session, install `picom`, then run
`picom --config ~/.config/i3/picom.conf` once, or log out and back in.

### Wallpapers

On login and i3 restart, `~/.config/i3/wallpaper.sh` runs **feh** to fill the
screen with `~/wallpapers/retro-anime-research-station-4k.png`.
The image is not bundled; if it is missing, the background is solid charcoal.
feh sets the wallpaper and exits rather than keeping a daemon running.
Edit the `wallpaper` path in the script to select another image. Reapply with
`sh ~/.config/i3/wallpaper.sh`.

For QEMU/SPICE, `spice-vdagent` is installed by the VM dependency menu and
started with i3 for clipboard and display integration. The VM must expose a
SPICE agent channel (`com.redhat.spice.0`).
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
