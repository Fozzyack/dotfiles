#!/bin/bash


echo "adding links"

ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

echo "Setup Complete"
