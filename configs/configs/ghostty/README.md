# Ghostty

A retro terminal with charcoal glass, warm cream text, orange accents, and teal
pane separators. Shares its palette and Terminess font with
[WezTerm](../wezterm.lua), [Starship](../../backups/starship.toml), and
[Waybar](../waybar/README.md).

## Files

| File | Purpose |
| --- | --- |
| `config` | Active appearance, shell integration, and keybinding settings |
| `themes/retro-dark` | Custom palette, cursor, selection, and split colors |
| `retro.css` | Retro GTK tabs, menus, dialogs, controls, and overlays |
| `config.5f8122a0.bak` | Saved older configuration; not loaded by `config` |

## Setup

Install Ghostty and **Terminess Nerd Font Mono**. The GTK stylesheet requires
GTK 4.16+ and libadwaita 1.6+ (validated with Ghostty 1.3.1). Use the repository's `dotman`
to link this directory to `~/.config/ghostty`, or, if that destination does not
already exist, run from the repository root:

```sh
mkdir -p ~/.config
ln -s "$PWD/configs/configs/ghostty" ~/.config/ghostty
```

Link the whole directory so Ghostty can discover `themes/retro-dark` and
`retro.css`. The CSS path resolves relative to `config`.
Check that the font resolves correctly:

```sh
fc-match 'Terminess Nerd Font Mono'
```

The config enables **Fish shell integration**. It does not choose the shell
executable; use Fish as your login shell or configure Ghostty's `command`
separately if needed.

## Appearance

| Setting | Current value |
| --- | --- |
| Background / foreground | `#090d0e` / `#e8d3a2` |
| Cursor | Orange `#ff851b`, blinking bar |
| Selection | Teal `#315653` with cream `#fff0c7` text |
| Split divider | Teal `#66b2a5` |
| Background opacity | `0.80` |
| Explicit cell backgrounds | Opaque (`background-opacity-cells = false`) |
| Unfocused split opacity | `0.85` |
| Padding | Balanced, 4 on each axis |
| Title bar | Hidden GTK title bar; `ghostty` window theme |
| Tabs | Bottom, original text size and padding; blue inactive labels, orange top marker, subtle bevels |
| GTK interface | Terminess font, charcoal panels, cream labels, orange focus and blue secondary accents |

`minimum-contrast = 1` preserves the theme colors without contrast adjustment.
The mouse hides while typing, and the resize overlay is disabled. Font size and
cell-height overrides are currently commented out.

Blur is requested in Ghostty; the final effect depends on compositor support.
The companion [Hyprland config](../hypr/README.md) also enables window blur.

`retro.css` styles the tab bar, menus, command palette, dialogs, search and
leader-key overlays, tooltips, notifications, and scrollbars. It is loaded only
by Ghostty. GTK panels stay opaque for legibility over the translucent terminal.
Buttons have subtle beveled edges that appear pressed when active. Notifications
use squared orange borders, and focused search fields have teal accents.

## Controls and reload

- **Shift+Enter** sends a literal newline (`\n`). How it is handled depends on
  the shell or application receiving it.
- **Ctrl+Shift+,** reloads the config on Linux (Ghostty's default binding).
- Other shortcuts use Ghostty defaults; inspect them with
  `ghostty +list-keybinds`.

After editing, validate the installed configuration:

```sh
ghostty +validate-config
```

Reload in Ghostty, or open a new window for settings that apply at creation.
After first enabling the GTK stylesheet, restart Ghostty for a full refresh.

## Customize

- Change colors in `themes/retro-dark`; the theme includes all 16 ANSI colors.
- Keep the matching GTK colors in `retro.css` in sync when changing the palette.
- Adjust `background-opacity` in `config` for more or less transparency.
- Uncomment `font-size` or `adjust-cell-height` to tune text sizing.
- Set `cursor-style-blink = false` for a steady cursor.

The terminal, prompt, and bar palettes are separate files; changing this theme
does not update the others automatically.

Reference: [Ghostty configuration](https://ghostty.org/docs/config) and
[option reference](https://ghostty.org/docs/config/reference).
