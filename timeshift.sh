#!/bin/bash

clear

### Confirm Start
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
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
paru --noconfirm -Syu timeshift timeshift-autosnap

echo "\e[1;32mDONE!\e[0m"
echo "You can create snapshots and update the GRUB Bootloader with ./snapshot.sh or gui if you prefer."
echo "It'll also create snapshots automatically with timeshift-autosnap, when packages are updated."
