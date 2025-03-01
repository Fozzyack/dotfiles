 
# My dotfiles

Just a collection of the dotfiles I use to personalise my setup / workflow.
All this does is create dotfiles then creates symbolic links for each in the appropriate spots.

## Use 
Once the repo is cloned make sure to run
``` 
./install.sh
```
## Remove
To remove run the 
```
./uninstall.sh
```

### Optionals

#### Figlet
__Figlet__ fonts can be installed using

This just gets the fonts from a github repository and puts them in your figlet font directory
```
./figlet_font_install.sh
```
__Example Command__

Example of adding a red login "Welcome" text using figlet
```
echo -e "\e[31m$(figlet Welcome -f 'ANSI Shadow')\e[0m"
```
