#!/bin/bash


git clone https://github.com/xero/figlet-fonts.git fonts/
sudo mv fonts/* /usr/share/figlet/
rm -rf fonts
