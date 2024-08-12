#!/bin/bash

clear

### Confirm Start
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION OF 'preload' NOW? (Yy/Nn): " yn
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

### Install timeshift and timeshift-autosnap
paru --noconfirm -Syu preload
sudo systemctl enable preload
sudo systemctl start preload

echo "\e[1;32mDONE!\e[0m"
echo "Preload is installed and started."
