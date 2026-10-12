# Retro console Waybar

Terminess lettering, charcoal glass, orange keys, teal indicators, and cream
readouts, matching Ghostty, WezTerm, and Starship. Colors live in `var.css`.

## Controls

| Module | Controls |
| --- | --- |
| `❯ SYS` | Click for Rofi; right-click for Ghostty |
| Workspaces | Click to switch; follows your Hyprland monitor assignments |
| CPU / RAM | Click for btop in Ghostty |
| Clock | Perth time; click to switch date format; hover for calendar; scroll to browse; right-click for month/year view |
| Coffee icon | Toggle keeping the session awake (idle inhibition) |
| Bluetooth | Click for Blueman, or bluetoothctl in Ghostty if unavailable |
| Network | Click for the connection editor; hover for address and traffic |
| Audio | Click for pavucontrol, or alsamixer in Ghostty; right-click to mute; scroll for volume |
| Brightness | Scroll in 5% steps |
| Battery | Click to switch percentage / remaining time |

Uptime reads `/proc/uptime` directly. The system tray hosts application icons.
Hardware modules depend on the devices present; no battery or backlight name is
hard-coded. CPU/RAM and battery alerts use static color changes.

## Apply

With this directory linked to `~/.config/waybar`, reload a running Waybar:

```sh
pkill -SIGUSR2 -x waybar
```

Or launch explicitly from the repository root:

```sh
waybar -c configs/waybar/config.jsonc -s configs/waybar/style.css
```

Subsequent CSS edits reload automatically. Install **Terminess Nerd Font Mono**
for the intended lettering and icons. Click actions use `rofi`, `ghostty`,
`btop`, `nm-connection-editor`, `pactl`, and `brightnessctl`; the fallback
Bluetooth/audio interfaces use `bluetoothctl` and `alsamixer`.

References: [configuration](https://github.com/Alexays/Waybar/wiki/Configuration),
[GTK styling](https://github.com/Alexays/Waybar/wiki/Styling), and
[module documentation](https://github.com/Alexays/Waybar/wiki/Modules).
