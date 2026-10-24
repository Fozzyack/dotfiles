# Pi — retro-dark

A native Pi configuration matching [OpenCode](../opencode/README.md) and
[Ghostty](../ghostty/config): warm cream text, orange focus/headings, teal
navigation, charcoal surfaces, sage additions and terracotta removals.
No third-party extensions or fixed provider/model are required.

## Install

From the repository root, run `./temperz`:

1. Choose **5 — Setup VM** and select **pi** and **fish**, or install all.
2. Choose **6 — Install VM deps** to install Pi using Bun if needed.
3. Open a new Fish session, then start `pi`.

Temperz links this directory to `~/.config/pi`, just like OpenCode. The VM's
`fish/conf.d/pi.fish` exports `PI_CODING_AGENT_DIR` to tell Pi to use it instead
of `~/.pi/agent`. No separate setup script or home-directory config link is
required. Temperz skips existing destinations; back up conflicting configs and
move them aside before retrying. If your Fish config was skipped, this environment
setting will not be installed either.

The conventional directory is **`.config`**, not `.configs`. Fish respects
`XDG_CONFIG_HOME` when set; ensure its `pi` directory points to this config if
you use a nonstandard location, since Temperz's documented target is `~/.config`.
Explicit `PI_CODING_AGENT_DIR` and `PI_CODING_AGENT_SESSION_DIR` overrides are
preserved.

For Bash/Zsh or another launcher, export the equivalent environment yourself:

```sh
export PI_CODING_AGENT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pi"
export PI_CODING_AGENT_SESSION_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/pi/sessions"
```

### Private state and migration

Pi uses its agent directory for **both config and private state**. With this
layout, `auth.json`, models, installed packages and other runtime files may be
written through `~/.config/pi` into this repository's working tree. The local
`.gitignore` allows only shared settings, keybindings, this README and the theme;
it excludes credentials and all other files by default. Never force-add private
files or share/archive this directory wholesale after logging in.

Session transcripts are kept separately under `~/.local/state/pi/sessions`
(or `$XDG_STATE_HOME/pi/sessions`) by the Fish environment setting.
Existing `~/.pi/agent` data is left untouched. Run `/login` again after switching
locations, or carefully copy your existing private auth/model/MCP files to the
new agent directory yourself. To resume old sessions, temporarily set
`PI_CODING_AGENT_SESSION_DIR` to the old session directory. Stop old Pi processes
before migrating; `/reload` cannot switch a running process's agent directory.

Start `pi`, use `/login` to authenticate, then select a model with `Ctrl+F`
or `/model`. No account-specific model or credentials are stored here.
Restart Pi or use `/reload` after installation. `/hotkeys` shows active bindings.

## Appearance and behaviour

- Fullscreen UI with a hidden scrollbar, matching OpenCode's uncluttered layout.
- The main canvas uses the terminal background; explicit charcoal/tool panels
  stay opaque under Ghostty's `background-opacity-cells = false` setting.
- Ghostty controls the hardware cursor, font, opacity and blur.
- Thinking text is hidden by default; `Ctrl+T` expands it. This does **not**
  disable model reasoning. The initial thinking level is medium.
- Automatic compaction keeps 20,000 recent tokens and reserves 16,384 tokens.
- Neovim is the external prompt editor; project trust remains set to `ask`.
- Optional install telemetry and analytics are disabled.

Palette values are independent copies of OpenCode/Ghostty's palette. Edit
`themes/retro-dark.json` to tune Pi; the active user theme hot-reloads.
Pi's `/settings` and model-saving commands can modify the linked settings file,
so review `git diff` before committing personal preference changes.

## Keybindings

Pi's native bindings are single shortcuts, not OpenCode's `Ctrl+F` leader
sequences. `Ctrl+F` opens the model picker instead. Plain Tab still completes
input; Shift+Tab cycles reasoning effort because Pi has no built-in agent picker.

| Shortcut | Action |
| --- | --- |
| `Ctrl+F` / `Ctrl+L` | Model picker |
| `Ctrl+P` / `Ctrl+Shift+P` | Next / previous scoped model (Pi defaults) |
| `Ctrl+N` | New session |
| `Ctrl+R` | Resume session picker |
| `Escape`, twice with empty input | Session tree |
| `Ctrl+G` | Edit prompt in Neovim |
| `Enter` | Send prompt |
| `Shift+Enter` / `Ctrl+J` | Newline in the editor |
| `Ctrl+J` / `Ctrl+K` | Down / up in selection lists |
| `Ctrl+Q` | Queue a follow-up while Pi is working |
| `Shift+Tab` | Cycle thinking level |
| `Ctrl+T` / `Ctrl+O` | Toggle thinking / tool output |
| `PageUp` / `PageDown` | Scroll transcript |
| `Ctrl+Home` / `Ctrl+End` | Top / bottom of transcript |
| `Escape` | Interrupt |

Other editing shortcuts retain Pi's defaults. `Ctrl+F` no longer moves the
editor cursor right; use the right arrow. In session pickers, contextual Pi
bindings (for example `Ctrl+R` to rename) still apply.

### VM terminal caveats

- `Alt+Enter` belongs to i3/Ghostty, so follow-up uses `Ctrl+Q` instead.
- Alt+H/J/K/L belong to i3; these are deliberately not used for Pi navigation.
- `Ctrl+S` belongs to Ghostty's leader and `Ctrl+B` to tmux. Neither is repurposed.
  To save model/thinking defaults with Pi's contextual `Ctrl+S`, press
  **Ctrl+S, release, Ctrl+S** so Ghostty sends a literal Ctrl+S.
- Ghostty currently maps Shift+Enter to a raw linefeed, which Pi interprets as
  Ctrl+J. Newlines work either way; this config does not change Ghostty globally.

## Permissions

This is an appearance/interaction profile, **not** an OpenCode permission-policy
port. Pi's project-trust prompt governs loading project resources; it does not
ask permission for each tool call or enforce OpenCode's `.env`/shell deny rules.
Use an audited guard extension or OS/container sandbox if you need those controls.

References: [Pi settings](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/settings.md),
[keybindings](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/keybindings.md)
and [themes](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/themes.md).
