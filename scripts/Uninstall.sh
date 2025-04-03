#!/bin/bash

echo "DELETING DOTFILES"
rm ~/.config/nvim
rm ~/.config/rofi
rm ~/.config/ghostty
rm ~/.config/hypr
rm ~/.config/waybar
rm ~/.config/alacritty
rm ~/.tmux.conf
rm -rf ~/.local/share/nvim

echo "SUCCESSFULLY DELETED"
