# My Arch Linux Dotfiles

My personal Arch Linux setup, with dotfiles for Hyprland, Alacritty, Ghostty, WezTerm, tmux, Neovim, Fish, and more.

Configurations live in this repository and are symlinked into your home directory. Review them before installing: these are tailored to my setup and workflow.

## Getting started

```bash
git clone https://github.com/Fozzyack/dotfiles.git ~/dotfiles
cd ~/dotfiles
mkdir -p ~/.config
./temperz
```

Back up your existing configurations first. Keep this repository in place after installation, since the symlinks point to its files.

## Temperz

[Temperz](https://github.com/Fozzyack/temperz) is a small Zig CLI for managing dotfiles and development tools. A Linux x86-64 executable is included as `./temperz`; run it from this repository's root so it can find `configs/`.

Its interactive terminal menu supports:

- **Install configs:** Select individual configs or install all of them. Existing destination paths are skipped rather than overwritten.
- **Remove configs:** Remove corresponding paths from your home directory without deleting the repository sources. Missing paths are skipped.
- **Install dependencies:** Run individual commands or all commands from `configs/install.config`. Batch installation stops at the first failure.
- **Pull updates:** Run `git pull` in the current repository.

Type a menu number and press Enter. Empty input exits the main menu or processes all items in a config/dependency submenu. Set `NO_COLOR=1` to disable colors.

> **Removal warning:** Temperz does not check whether a matching destination is a symlink before removing it. Review the selected paths carefully, especially if installation skipped an existing file.

### Repository layout

| Location | Purpose |
| --- | --- |
| `configs/configs/` | Files and directories linked into `~/.config/` |
| `configs/home/` | Files and directories linked into `~/` |
| `configs/install.config` | Dependency installation commands, one shell command per line |
| `other-configs/` | Extra configurations for manual setup |

Temperz preserves entry names; it does **not** add a leading dot. For example, `configs/home/wezterm.lua` becomes `~/wezterm.lua`, while `configs/configs/nvim/` becomes `~/.config/nvim/`.

The dependency commands currently use `paru`, which must already be installed. Review `configs/install.config` before running it, and only use trusted commands.

### Building Temperz from source

If the bundled executable is unsuitable for your system, build it from the [Temperz repository](https://github.com/Fozzyack/temperz) with Zig:

```bash
git clone https://github.com/Fozzyack/temperz.git ~/temperz
cd ~/temperz
zig build
cd ~/dotfiles
~/temperz/zig-out/bin/temperz
```

## Setup notes

### tmux

Install the tmux Plugin Manager (TPM):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Hyprland wallpapers

Edit `configs/configs/hypr/hyprpaper.conf` to match your monitor names and wallpaper paths. The referenced wallpapers under `~/wallpaper/` are not included in this repository.

### Neovim

You may need to install language servers for the languages you use. In Neovim, run `:help lspconfig-all` for configuration guidance.

## Extra tools

### FF

A fuzzy finder for files and directories. There is no automated installation method yet; run the included executable directly:

```bash
cd ~/dotfiles/ff
./ffcli -s
```

Shell wrappers are available in `ff/ff.sh` and `ff/ff.fish`.

### DFILE

A small tool for displaying file or directory information. There is no automated installation method yet:

```bash
cd ~/dotfiles/dfile
./dfile /path/to/file/or/directory
```

## Legacy tools

- **DOTMAN:** The previous dotfile manager is available in the [dotfile-manager repository](https://github.com/Fozzyack/dotfile-manager). It is not bundled here; use Temperz for the current repository layout.
- **Shell scripts:** `scripts/install.sh` and `scripts/uninstall.sh` are retained for reference. The installer still uses the old `~/dotfiles/configs/<app>` paths and is not compatible with the current layout without edits.

> **Legacy uninstall warning:** `scripts/uninstall.sh` also deletes `~/.local/share/nvim`, including installed Neovim plugins and other data. Prefer Temperz for managing the current configs.
