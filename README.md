 
# My Arch Linux Dotfiles

Contains my Hyprland, alacritty, ghostty, tmux and neovim dotfiles.

Just a collection of the dotfiles I use to personalise my setup / workflow. All this does is create dotfiles then
creates symbolic links for each in the appropriate spots.

## Use 

### NEW - DOTMAN

Adds DOTMAN. A little program that helps managing dotfiles. Has a UI for installing and uninstalling certain dotfiles.

Simply:
```bash
cd dotfiles
./dotman

```

#### Organisation for dotman usage

- Folders present in ```configs/``` will be installed to ```$USER/.confg/...```.
- Other files will be moved to ```$USER/...```
    - The installer will put a `.` infront of the file so all files in your ```configs/``` folder SHOULD NOT BE HIDDEN.

### OLD - Script Install

Once the repo is cloned make sure to run

```  bash
git clone https://github.com/Fozzyack/dotfiles.git 
cd dotfiles 
./scripts/install.sh 
```

### Note

You may have to edit 
```bash
~/dotfiles/config/hypr/hyprpaper.conf
```
Might move wallpaper collection to my dotfiles in the future

## Remove

To remove run the 
```bash
./scripts/uninstall.sh 
```

### Optionals

The above scripts will install all dotfiles. You may have to remove some depending on your use cases. For example this
installs both alacritty and ghostty configs.

Also, the uninstall script also removes all the installed plugins from nvim which are stored in
```bash
~/.local/share/nvim
```
