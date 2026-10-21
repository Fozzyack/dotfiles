# Retro tmux

Matches [Ghostty's retro-dark palette](../../configs/ghostty/themes/retro-dark):
charcoal glass, warm cream text, teal dividers, and orange active-window tabs.
The square status labels suit Ghostty's Terminess Nerd Font Mono.

```text
 [ main ]   > 1 : fish*    2 : nvim-              workstation / 14 Oct  21:08
```

- The status bar shows the session, windows, and a 24-hour clock.
- `KEY`, `COPY`, and `[ZOOM]` indicate prefix, copy mode, and zoom state.
- Hostname and date disappear in narrower terminals to leave room for windows.
- Pane backgrounds and the status bar's gaps use the terminal's transparency.
- Copy mode, menus, popups, and the large clock (`Ctrl+s t`) share the palette.
- The default cursor is an orange blinking bar, matching WezTerm and Ghostty.
  Fish's companion `../fish/conf.d/cursor.fish` restores the bar after commands.

## Apply

From the repository root, reload into the running tmux server:

```sh
tmux source-file "$PWD/configs/configs/tmux/tmux.conf"
```

For automatic loading, deploy this directory to `~/.config/tmux` using your
dotfiles setup. Keep `theme.conf` beside `tmux.conf`; the import resolves relative
to the loaded config, not the working directory. If using `~/.tmux.conf` instead,
place `theme.conf` at `~/theme.conf`. New sessions use `tmux-256color`.

## Plugins and controls

TPM, resurrect, sensible defaults, and logging are retained. Native tmux styling
replaces tmux-power; the unused CPU and battery plugins are no longer declared.
The theme also works without TPM. Installed plugins are loaded through the XDG
TPM path when present, otherwise `~/.tmux/plugins/tpm`.

- `Ctrl+s` is the prefix; `h/j/k/l` select panes, with mouse support enabled.
- `Ctrl+s I` installs plugins; `Ctrl+s U` updates them.
- After deploying the config, `Ctrl+s Alt+u` removes unused plugin checkouts.

All tmux appearance settings live in `theme.conf`, imported after plugins load.
`tmux.conf` keeps terminal capabilities, controls, plugins, and session behavior.
Ghostty and tmux palettes are maintained separately.
