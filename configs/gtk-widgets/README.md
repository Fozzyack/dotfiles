# Retro Widgets

## Standalone widgets

After editing Python or CSS, restart all four with `./restart-widgets.sh`.
Running widgets retain their command-line options, including the weather city
and units. Use `./restart-widgets.sh --city "Perth"` to set a city explicitly
(if weather was closed, it otherwise starts with an empty city field).
Logs are stored in `~/.local/state/retro-widgets/` (or `$XDG_STATE_HOME/retro-widgets`).

```sh
python3 clock.py
python3 calendar_widget.py
python3 weather.py --city "Manchester"
python3 system_load.py
```

Run each command in a separate terminal, or use Hyprland autostart below.
Each widget is an independent GTK 4 / Wayland desktop-layer surface:

- **Clock:** live 24-hour time with seconds and local date.
- **Calendar:** Monday-first month view, orange today highlight, previous/next
  month arrows and a Today button. Updates at midnight.
- **Weather:** current temperature, conditions, feels-like temperature, humidity
  and wind from Open-Meteo (no API key). Large temperature readout, ASCII weather
  illustration, and three separate metric columns. Enter a city and press Enter
  or **[FETCH]**.
  Searches use the first matching location; the resolved region/country is shown.
  Refreshes every ten minutes, with network requests in a background thread.
  Defaults to °C and km/h; add `--fahrenheit` for °F and mph. Without `--city`,
  starts with an empty city field. Use `--city` in autostart to keep your preferred
  location across launches. Requires internet access; failures can be retried.
- **System:** CPU utilization sampled every two seconds, used/total RAM (based
  on Linux MemAvailable), segmented utilization meters, a rolling 60-second CPU
  trace, and 1/5/15-minute load averages. Load averages are task
  counts, not percentages; the logical CPU count is shown for context.

Close any widget independently with **[x]**, or Escape after clicking it.
Each has its own application ID, so launching the same
widget again brings its existing window forward.

The charcoal background uses **0.9 opacity**, while text stays fully opaque.
Edit `clock.css` to change colours, fonts, or background alpha.
All widgets use square corners, a teal left border, and the pixel-style
**Terminess Nerd Font Mono** (installed locally), falling back to IosevkaTerm
and system monospace. Desktop-layer surfaces have no compositor window decorations.
Restart the widgets after styling changes; reload Hyprland after rule changes.

### Hyprland

Hyprland 0.55+ uses Lua configuration (including the installed 0.56.2).
Add this to `~/.config/hypr/hyprland.lua`, adjusting the path if you move the project:

```lua
dofile("/home/fozzyack/code/gtk-widgets/hyprland-widgets.lua")
```

Set `city` and `directory` at the top of `hyprland-widgets.lua`. Reload with
`hyprctl reload`, then launch the widgets manually the first time. The
`hl.on("hyprland.start", ...)` handler autostarts them on the next login, not on
configuration reload.

The clock and calendar are anchored to the left edge; weather and system are
anchored to the right. All use the **bottom layer**, above wallpaper but below
normal windows and terminals, on every workspace of their output. They reserve
no screen space. Click an exposed widget to interact with it; the weather entry
can take keyboard focus on demand. Normal window move/resize bindings do not
apply. Adjust `POSITIONS` in `widget.py` and restart the widgets to change spacing.
The compositor chooses the output when no monitor is explicitly selected.

Background opacity is controlled by CSS. Your Hyprland configuration is not
changed automatically.

The older `hyprland-clock.conf` describes the previous floating-window version
and is no longer needed for these desktop-layer widgets.

On Arch Linux, dependencies are:

```sh
sudo pacman -S python-gobject gtk4 gtk4-layer-shell
```

The desktop widgets require GTK4 Layer Shell and its `Gtk4LayerShell-1.0`
introspection typelib (already installed locally). On Debian/Ubuntu releases
that package it, install `gir1.2-gtk4layershell-1.0` as well as the dependencies
below. The original demo does not require Layer Shell.

## Original widget demo

A simple Python / GTK 4 desktop app using the supplied retro-dark palette.
Includes a name entry, greeting button, and counter with add/reset controls.
Press Enter in the name field to update the greeting.

## Run

On Ubuntu/Debian, install the dependencies:

```sh
sudo apt install python3-gi gir1.2-gtk-4.0
```

From this directory:

```sh
python3 app.py
```

Run from a graphical desktop session. No pip dependencies are needed.
The palette and widget styles are in the `CSS` constant in `app.py`.
