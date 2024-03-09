#!/bin/bash

read -p "Enter a comment for the snapshot: " c
sudo timeshift --create --comments "$c"
sudo timeshift --list
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "\e[1;32mDONE. Snapshot $c created!\e[0m"
