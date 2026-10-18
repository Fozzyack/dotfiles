# OpenCode

A Ghostty-matched retro interface: charcoal glass, cream text, orange accents,
and teal navigation. Based on [Ghostty's palette](../ghostty/themes/retro-dark).

## Files

| File | Purpose |
| --- | --- |
| `cli.json` | OpenCode V2 terminal appearance and existing shortcuts |
| `retro-dark.json` | Custom theme source, including the light-mode palette |
| `themes/retro-dark.json` | Symlink to the theme source for theme discovery |
| `opencode.json` | Models, agents, tools, and other server settings |

Link this whole directory to `~/.config/opencode` using your dotfiles setup.
The theme symlink must remain intact. Restart OpenCode after installing the
theme; `/themes` lets you select `retro-dark` if needed.

## Appearance

| Element | Dark-mode treatment |
| --- | --- |
| Main canvas | Transparent, revealing Ghostty's `#040607` backdrop |
| Panels / menus | Charcoal `#111819`, `#202829`, and `#2b3e3e` |
| Body / emphasized text | Warm cream `#e8d3a2` / `#fff0c7` |
| Headings / keyboard focus | Orange `#ff851b` |
| Links / functions | Teal `#66b2a5` |
| Selected actions / fields | Teal `#315653` with bright cream text |
| Diffs | Sage additions, terracotta removals, tinted backgrounds |

The CLI locks dark mode, enables interface animations, and lets Ghostty control
the cursor. Ghostty also supplies Terminess Nerd Font Mono, font sizing, blur,
and background opacity. Raised surfaces stay opaque with Ghostty's existing
`background-opacity-cells = false` setting.

Edit `retro-dark.json` to tune colors; its symlink exposes the same file to
OpenCode. Restart the TUI to reload theme-file changes. Valid `cli.json` edits
reload while the TUI is running.

Palette files are independent: changing Ghostty's colors does not automatically
update this theme.

## Primary agent colours

| Agent | Colour |
| --- | --- |
| Build | Orange `#ff851b` |
| Plan | Teal `#66b2a5` |
| Ask | Sage `#8fa878` |
| Chat | Mauve `#b58b95` |
| Orchestrator | Blue `#93bec4` |

Built-in agent colours are set under `agents` in `opencode.json`; custom agent
colours live in the corresponding `agents/*.md` frontmatter. These explicit
colours override the theme's automatic agent palette.

References: [CLI settings](https://opencode.ai/v2/docs/cli/config) and
[custom themes](https://opencode.ai/v2/docs/cli/theme).
