#!/bin/bash

echo "LINKING DOTFILES"
ln -sf ~/dotfiles/configs/nvim ~/.config/nvim
ln -sf ~/dotfiles/configs/rofi ~/.config/rofi
ln -sf ~/dotfiles/configs/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/configs/hypr ~/.config/hypr
ln -sf ~/dotfiles/configs/waybar ~/.config/waybar
ln -sf ~/dotfiles/configs/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/configs/tmux/tmux.conf ~/.tmux.conf

echo "SUCCESSFULLY INSTALLED!"
echo "INPUTS DOTFILES FOR ALACRITTY AND GHOSTY"
echo "Delete one or the other from .config"
