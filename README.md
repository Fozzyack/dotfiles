<div align="center">

# ~/dotfiles

**My Arch Linux Configuration!**

A keyboard-first home for my desktop, terminals, and development tools.

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-171C20?style=for-the-badge&logo=archlinux&logoColor=73B7B0)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-171C20?style=for-the-badge&logo=hyprland&logoColor=73B7B0)](https://hyprland.org/)
[![Neovim](https://img.shields.io/badge/Neovim-171C20?style=for-the-badge&logo=neovim&logoColor=73B7B0)](https://neovim.io/)
[![Managed with Temperz](https://img.shields.io/badge/Managed_with-Temperz-C87941?style=for-the-badge)](https://github.com/Fozzyack/temperz)

[The stack](#the-stack) · [Quick start](#quick-start) · [Temperz](#temperz) · [Setup notes](#setup-notes) · [Extra tools](#extra-tools)

</div>

---

Personal dotfiles for an Arch Linux workflow built around Hyprland, Neovim, and the terminal. Configurations stay in this repository, with symlinks putting them where they belong.

## The stack

| Layer | Tools |
| :--- | :--- |
| **Desktop** | Hyprland · Hyprpaper · Waybar · Rofi |
| **Terminals** | Ghostty · Alacritty · WezTerm |
| **Shell & sessions** | Fish · Starship · tmux |
| **Editor** | Neovim |
| **System info** | btop · Fastfetch · Neofetch |
| **Dotfile manager** | [Temperz](https://github.com/Fozzyack/temperz) |

## Quick start

Clone it. Open the control panel. Pick your configs.

```bash
git clone https://github.com/Fozzyack/dotfiles.git ~/dotfiles
cd ~/dotfiles
mkdir -p ~/.config
./temperz
```

> [!IMPORTANT]
> These configs are tailored to my setup. Review them and back up your existing configurations first. Keep this repository in place after installation: the symlinks point to its files.

## Temperz

[Temperz](https://github.com/Fozzyack/temperz) is a small Zig CLI for managing dotfiles and development tools. A Linux x86-64 executable is included as `./temperz`; run it from this repository's root so it can find `configs/`.

```text
  [ temperz ]  DEV ENVIRONMENT / CONTROL PANEL
  Your tools. Your dotfiles. One place.

  +--------------------------------------------------+

  [1]  Install configs       Link your dotfiles
  [2]  Remove configs        Unlink your dotfiles
  [3]  Install dependencies  Set up your dev tools
  [4]  Pull updates          Sync this repository
  [5]  Exit

  +--------------------------------------------------+
  READY >
```

| Action | What happens |
| :--- | :--- |
| **Install configs** | Link individual configs or all of them. Existing destination paths are skipped. |
| **Remove configs** | Remove corresponding home-directory paths; keep repository sources. Missing paths are skipped. |
| **Install dependencies** | Run one or all commands from `configs/install.config`. Batch installation stops at the first failure. |
| **Pull updates** | Run `git pull` in the current repository. |

Type a menu number and press Enter. Empty input exits the main menu or processes all items in a config/dependency submenu. Set `NO_COLOR=1` to disable colors.

> [!WARNING]
> Temperz does not check whether a matching destination is a symlink before removing it. Review the selected paths carefully, especially if installation skipped an existing file.

### Repository layout

```text
~/dotfiles/
├── configs/
│   ├── configs/       → ~/.config/
│   ├── home/          → ~/
│   ├── windows/         Windows dotfiles for manual setup
│   └── install.config   Dependency commands, one per line
├── other-configs/      Extra configs for manual setup
├── ff/                 Fuzzy file finder
├── dfile/              File information tool
├── scripts/            Legacy install / uninstall scripts
└── temperz             Dotfile control panel
```

Temperz preserves entry names; it does **not** add a leading dot. For example, `configs/home/wezterm.lua` becomes `~/wezterm.lua`, while `configs/configs/nvim/` becomes `~/.config/nvim/`.

The dependency commands currently use `paru`, which must already be installed. Review `configs/install.config` before running it, and only use trusted commands.

<details>
<summary><strong>Build Temperz from source</strong></summary>

If the bundled executable is unsuitable for your system, build it from the [Temperz repository](https://github.com/Fozzyack/temperz) with Zig:

```bash
git clone https://github.com/Fozzyack/temperz.git ~/temperz
cd ~/temperz
zig build
cd ~/dotfiles
~/temperz/zig-out/bin/temperz
```

</details>

## Setup notes

### Windows dotfiles

Windows-specific dotfiles are available in [`configs/windows/`](configs/windows/), including `.glzr/`, `alacritty/`, and `.wezterm.lua`. These are **not installed by Temperz** and require manual setup on Windows.

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

<details>
<summary><strong>Earlier managers and scripts</strong></summary>

- **DOTMAN:** The previous dotfile manager is available in the [dotfile-manager repository](https://github.com/Fozzyack/dotfile-manager). It is not bundled here; use Temperz for the current repository layout.
- **Shell scripts:** `scripts/install.sh` and `scripts/uninstall.sh` are retained for reference. The installer still uses the old `~/dotfiles/configs/<app>` paths and is not compatible with the current layout without edits.

> **Legacy uninstall warning:** `scripts/uninstall.sh` also deletes `~/.local/share/nvim`, including installed Neovim plugins and other data. Prefer Temperz for managing the current configs.

</details>

---

<div align="center">

<sub>Personal configs. A work in progress. Make yourself at <code>~/</code>.</sub>

[Back to top](#dotfiles)

</div>
