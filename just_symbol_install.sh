#!/bin/bash


echo "INSTALLING NODE VERSION MANAGER"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
mkdir ~/.config

echo "ADDING SYMBOLIC LINKS"
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

echo "FINISHED"
