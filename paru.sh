#!/bin/bash

clear

### Confirm Start
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION OF 'paru' NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* )
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
sudo pacman -Syyy
cd
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

paru --version
echo "If version is not displayed, please update the system and try the below command."
echo "cd ~/paru && makepkg -si"
