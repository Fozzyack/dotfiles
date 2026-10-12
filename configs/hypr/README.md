# Hyprland

A Dwindle desktop with orange window borders, rounded corners, translucent
terminal blur, and animated workspace transitions. Starts
[Waybar](../waybar/README.md) and Hyprpaper, with
[Ghostty](../ghostty/README.md) as the terminal.

## Files and requirements

| File | Purpose |
| --- | --- |
| `hyprland.lua` | Active Lua configuration: monitors, input, styling, bindings, and rules |
| `hyprpaper.conf` | Per-monitor wallpapers and a fallback wallpaper |
| `hyprland.conf.bak` | Older configuration kept as a backup |

Use a Hyprland build supporting the Lua `hl.*` configuration API used here.
This is a Hyprland configuration, not a standalone Lua script. The wallpaper
config uses Hyprpaper's `wallpaper { ... }` syntax.

Programs referenced by the active configuration:

- `waybar` and `hyprpaper`: launched when the Hyprland session starts.
- `ghostty`, `dolphin`, and `rofi`: terminal, file manager, and launcher.
- `wpctl` (WirePlumber), `brightnessctl`, and `playerctl`: hardware/media keys.
- `hyprshutdown`: preferred session-exit helper, with a `hyprctl` fallback.

## Setup and reload

Use the repository's `dotman` to link this directory to `~/.config/hypr`, or,
if that destination does not already exist, run from the repository root:

```sh
mkdir -p ~/.config
ln -s "$PWD/configs/hypr" ~/.config/hypr
```

Adjust monitor names and wallpaper paths below for your machine. Start a
Hyprland session, then use these commands to inspect and reload it:

```sh
hyprctl monitors
hyprctl reload
hyprctl configerrors
```

The startup hook runs at session start; reloading does not rerun the Waybar and
Hyprpaper launch commands. Wallpaper changes belong to Hyprpaper and require
its own reload/restart rather than just `hyprctl reload`.

## Monitors and workspaces

| Output | Resolution | Position | Scale |
| --- | --- | --- | --- |
| `eDP-1` | 1920×1200 | `0x0` | 1 |
| `DP-3` | 1920×1080 | `-1920x0` (left) | 1 |
| `HDMI-A-1` | 1920×1080 | `1920x0` (right) | Auto |

`HDMI-A-1` also sets `reserved_area = 70`.

Workspaces **1–11** are assigned by parity: odd numbers to `eDP-1`, even numbers
to `DP-3`. The HDMI assignment in the loop is commented out. Number-key
shortcuts cover **1–10**; `0` selects workspace 10. Workspace 11 has no dedicated
number-key binding.

## Keybindings

**Super** is the Windows key.

| Shortcut | Action |
| --- | --- |
| Super+Q | Open Ghostty |
| Super+C | Close the focused window |
| Super+M | Exit the session through hyprshutdown, or the Hyprland exit fallback |
| Super+E | Open Dolphin |
| Super+R | Open Rofi (`rofi -show combi`) |
| Super+V | Toggle floating |
| Super+P | Toggle pseudotiling |
| Super+Arrow | Focus in that direction |
| Super+H / J / K / L | Configured as left / right / up / down focus; see J overlap below |
| Super+1–9 / 0 | Switch to workspace 1–9 / 10 |
| Super+Shift+1–9 / 0 | Move the focused window to that workspace |
| Super+S | Toggle the `magic` scratchpad |
| Super+Shift+S | Move the focused window to the scratchpad |
| Super+Scroll | Cycle existing workspaces |
| Super+Left drag | Move a window |
| Super+Right drag | Resize a window |
| Three-finger horizontal swipe | Switch workspaces |

**J overlap:** the file registers both `Super + J` for Dwindle `togglesplit`
and `Super + j` for focus-right. These overlap on the J key; choose a distinct
key for one action when customizing. The H/J/K/L directions above reflect the
actual configuration, including J=right and L=down.

Volume keys adjust output by 5%, capped at 100% when raising it. Speaker and
microphone mute keys toggle their default devices. Brightness keys use 5%
steps with `brightnessctl`'s exponential curve and minimum of 2. Media keys
provide previous, next, and play/pause via `playerctl`. These bindings are
enabled while locked; volume and brightness bindings also repeat when held.

## Appearance and input

- **Layout:** Dwindle with split preservation. Master and scrolling settings
  are also present, but Dwindle is the selected layout.
- **Spacing:** inner gaps 3, outer gaps 5, borders 4.
- **Borders:** active orange `#ff851b`; inactive gray `rgba(595959aa)`.
- **Corners:** rounding 10, rounding power 2.
- **Effects:** shadows, blur (size 5, three passes), spring window animations,
  and fading workspace transitions.
- **Opacity:** compositor-level active/inactive opacity is 1.0; Ghostty sets
  its own background transparency.
- **Input:** US keyboard, focus follows mouse, unchanged global sensitivity,
  and touchpad natural scrolling disabled.
- **Cursor:** XCursor and Hyprcursor sizes set to 24.

The `epic-mouse-v1` device block sets sensitivity to `-0.5` only for a matching
device. Replace its name to apply it to your own mouse.

Window rules suppress application maximize requests, prevent focus for a
specific class of empty-title XWayland floating windows, and float/position
`hyprland-run`. The final environment setting disables GTK's
`ext_background_effect_manager_v1` protocol through `GDK_WAYLAND_DISABLE`.

## Wallpapers

`hyprpaper.conf` references images under `~/wallpaper/retro-images/`:

| Output | Image | Fit |
| --- | --- | --- |
| `eDP-1` | `retro-anime-spaceship-schematic-4k.png` | Contain |
| `HDMI-A-1` | `retro-anime-hacker-orange-hand-fixed-4k.png` | Cover |
| Fallback (empty monitor) | `retro-anime-research-station-4k.png` | Cover |

These images are external to this config directory. Supply them at those paths
or change the paths. The Hyprpaper splash is disabled.

## Customize

Edit `terminal`, `fileManager`, and `menu` near the top of `hyprland.lua` to
change default applications. The file is divided into monitor, startup,
appearance, input, keybinding, and window-rule sections. Workspace assignments
live in the loop immediately after the monitor definitions.

References: [Hyprland wiki](https://wiki.hypr.land/) and
[Hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/).
