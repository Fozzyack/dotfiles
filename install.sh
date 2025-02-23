#!/bin/bash


echo "UPDATING SYSTEM and making sure build-essentials are installed"
sudo apt update && sudo apt upgrade --yes
sudo apt install build-essential cmake

echo "INSTALLING NODE VERSION MANAGER"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
mkdir ~/.config

echo "ADDING SYMBOLIC LINKS"
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

echo "FINISHED"
