#!/bin/bash

echo "LINKING DOTFILES"
ln -sf ~/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/config/rofi ~/.config/rofi
ln -sf ~/dotfiles/config/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/config/hypr ~/.config/hypr
ln -sf ~/dotfiles/config/waybar ~/.config/waybar
ln -sf ~/dotfiles/config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/config/tmux/tmux.conf ~/.tmux.conf

echo "SUCCESSFULLY INSTALLED!"
echo "INPUTS DOTFILES FOR ALACRITTY AND GHOSTY"
echo "Delete one or the other from .config"
