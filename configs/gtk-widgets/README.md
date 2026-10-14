# Retro Widgets

## Standalone widgets

After editing Python or CSS, restart the six enabled widgets with `./restart-widgets.sh`.
The media deck is manual-launch only: it is excluded from autostart and is closed
without relaunching by the restart script. Run `python3 media_player.py` to show it.
You can also launch individual widgets from Waybar's **WIDGETS ▾** dropdown;
see [Waybar setup](../configs/waybar/README.md).
Running widgets retain their command-line options, including the weather city
and units. Use `./restart-widgets.sh --city "Perth"` to set a city explicitly
(if weather was closed, it otherwise starts with an empty city field).
Logs are stored in `~/.local/state/retro-widgets/` (or `$XDG_STATE_HOME/retro-widgets`).

```sh
python3 clock.py
python3 calendar_widget.py
python3 weather.py --city "Manchester"
python3 system_load.py
python3 media_player.py
python3 network.py
python3 pomodoro.py
```

Run each command in a separate terminal, or use Hyprland autostart below.
Each widget is an independent GTK 4 / Wayland desktop-layer surface:

- **Clock:** inset 24-hour hours/minutes display, separate blue seconds readout,
  local date and timezone, and a slim teal meter showing position in the local
  24-hour day (wall-clock time, rather than elapsed duration across DST changes).
- **Calendar:** retro datebook with a large today card, month/year heading,
  Monday-first six-week grid and ISO week numbers. Click a date to inspect its
  weekday, ISO week/year and day-of-year in the detail strip. Orange marks today;
  blue marks the selected date. Month arrows preserve the selected day where
  possible; **[ TODAY ]** resets selection. Updates at midnight.
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

- **Media:** MPRIS media deck with album art, title/artist/album, elapsed time,
  orange progress meter, and previous/play-pause/next controls. Select a player
  from the dropdown (Spotify, VLC, and browsers with MPRIS enabled). The first
  available player is selected initially; your choice is kept until it exits.
  Controls respect each player's advertised capabilities. Missing artwork uses
  a record symbol; streams without a duration show `--:--`. Metadata is polled
  every second over the session D-Bus in a worker thread. Local and HTTP(S)
  artwork is supported, limited to 4 MiB. No extra Python packages or playerctl
  are required. A media application must be running to populate the deck.

- **Network:** orange download and blue upload rates, independently auto-scaled
  30-sample traffic traces, and interface byte totals. Samples once per second
  from `/proc/net/dev`, using actual elapsed time. Units are bytes/s, not bits/s;
  totals are since interface creation/reset, not widget launch. AUTO selects the
  lowest-metric IPv4 default route, falling back to the interface with the most
  accumulated traffic. Use the dropdown for IPv6-only routes, VPNs or another
  interface. Loopback is excluded. Switching interfaces or resetting counters
  clears history. This measures interface traffic, including LAN transfers;
  it does not test internet connectivity or link capacity. No extra dependencies.

- **Pomodoro:** compact focus/break timer with start, pause and reset. Expand
  **DURATIONS / MINUTES** to configure focus, short break and long break (1–180
  minutes each), then **SAVE & RESET**. Defaults are 25/5/15 minutes, with a long
  break after every four completed focus sessions. Each interval ends with a
  desktop notification and waits for START before the next interval. Settings
  persist in `$XDG_CONFIG_HOME/retro-widgets/pomodoro.json` (normally
  `~/.config/retro-widgets/pomodoro.json`). Closing/restarting resets the timer
  and completed-session count. Elapsed time uses a monotonic clock, excluding
  system suspend. The timer starts idle on launch.

Close any widget independently with **[x]**, or Escape after clicking it.
Each has its own application ID, so launching the same
widget again brings its existing window forward.

The charcoal background uses **0.9 opacity**, while text stays fully opaque.
Edit `clock.css` to change colours, fonts, or background alpha.
Panels use compact sizing: 324px default width for clock/calendar/network/Pomodoro and 360px for
the other widgets, with tighter padding and smaller readouts. GTK may grow a
panel to fit its content. Default widths and body spacing are set in `widget.py`.
All widgets use square corners, subtle beveled edges, a teal left border,
muted blue secondary labels, orange readouts, and the pixel-style
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

The media deck sits in a second column, 374px from the left and 80px from the
top when launched manually. The network monitor is anchored 30px from the left
and bottom edges. Pomodoro sits in a second right-hand column, 410px from the
right and 80px from the top, beside weather and system.
Adjust their entries in `POSITIONS` for your monitor size.
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
