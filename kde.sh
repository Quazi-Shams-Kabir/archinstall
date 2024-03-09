#!/bin/bash

#read from https://github.com/XxAcielxX/arch-plasma-install?tab=readme-ov-file#xorg--gpu-drivers

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

# if use discover to update apps, packagekit-qt6 is needed
sudo pacman -S --noconfirm xorg plasma konsole dolphin partitionmanager kde-inotify-survey gwenview ark kate kcalc spectacle

sudo systemctl enable sddm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
