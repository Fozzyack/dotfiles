# Retro WezTerm

WezTerm configuration in `.wezterm.lua`, with a dark charcoal, orange, and teal aesthetic and an always-visible bottom tab bar.

## Leader shortcuts

Press **Ctrl+s**, release it, then press a command key within **two seconds**. The status bar shows `LEADER` while waiting for your command.

| Key after Ctrl+B | Action |
| --- | --- |
| `c` | Create a tab in the current pane's domain |
| `n` / `p` | Next / previous tab |
| `1`–`8` | Select tab 1–8 |
| `9` | Select the last tab |
| `%` | Split into top and bottom panes |
| `"` | Split into left and right panes |
| `h` / `j` / `k` / `l` | Focus the pane to the left / down / up / right |
| `z` | Toggle zoom for the current pane |
| `x` | Close the current pane, with confirmation |
| `r` | Enter pane-resizing mode |
| **Ctrl+B** | Send a literal Ctrl+B to the terminal application |

For example, **Ctrl+B**, then `c` creates a tab. **Ctrl+B**, then **Ctrl+B** passes Ctrl+B through to applications such as tmux.

## Pane-resizing mode

Enter with **Ctrl+B**, then `r`. The status bar shows `RESIZE [HJKL / ESC]`.

- Press `h`, `j`, `k`, or `l` to adjust the pane left, down, up, or right by one cell.
- Arrow keys also work. Repeat keys as needed; no modifier is required.
- Press **Esc** or **Enter** to exit resizing mode.

## Existing shortcuts

These remain available without the leader key:

| Shortcut | Action |
| --- | --- |
| **Ctrl+Shift+T** | New tab |
| **Ctrl+Shift+W** | Close the current tab, with confirmation |
| **Ctrl+Tab** / **Ctrl+Shift+Tab** | Next / previous tab |
| **Ctrl+PageDown** / **Ctrl+PageUp** | Next / previous tab |
| **Ctrl+Shift+1–8** | Select tab 1–8 |
| **Ctrl+Shift+9** | Select the last tab |
| **Ctrl+Shift+PageUp** / **Ctrl+Shift+PageDown** | Move the tab left / right |
| **Ctrl+Shift+N** | New window |
| **Ctrl+Shift+D** | Split into left and right panes |
| **Ctrl+Shift+E** | Split into top and bottom panes |
| **Ctrl+Shift+H/J/K/L** | Focus the pane to the left / down / up / right |
| **Ctrl+Shift+Z** | Toggle pane zoom |
| **Alt+Enter** | Toggle fullscreen |
| **Ctrl+Shift+R** | Reload the configuration |

Other WezTerm defaults remain enabled unless overridden by `.wezterm.lua`.

## Appearance and reloading

- Active tabs are orange; inactive tabs are teal.
- Tabs use numbered labels such as `[1]`, with `*` marking the active tab.
- The tab bar stays visible even with only one tab open.
- WezTerm normally reloads configuration changes automatically. Use **Ctrl+Shift+R** if needed.

The current configuration starts WSL through `wsl.exe` and uses **Terminess Nerd Font**. If you move it to another machine, install that font and adjust the startup command as needed. Keep the configuration at `C:\Users\<your-user>\.wezterm.lua` for a standard Windows installation; this README can live anywhere.
