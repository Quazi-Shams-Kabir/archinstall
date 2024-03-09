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

### Install zram
sudo pacman --noconfirm -Syu zram-generator

### Check config and start zram
if [ -f "/etc/systemd/zram-generator2.conf" ]; then
    echo "/etc/systemd/zram-generator.conf already exists!"
else
	sudo touch /etc/systemd/zram-generator.conf
	sudo bash -c 'echo "[zram0]" >> /etc/systemd/zram-generator.conf'
	sudo bash -c 'echo "zram-size = ram" >> /etc/systemd/zram-generator.conf'
    sudo systemctl daemon-reload
    sudo systemctl start /dev/zram0
fi

echo "DONE! Reboot now and check with free -h the ZRAM installation."
