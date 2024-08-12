#!/bin/bash

clear
zoneinfo="Asia/Kolkata"
hostname="archbtw"
username="shams"
fullname="Quazi Shams Kabir"

### Time and Timezone
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

### Localization
echo "en_IN UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" >> /etc/locale.conf

# Set hostname and localhost
echo "$hostname" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

### Configure pacman
echo "Uncomment Color, VerbosePkgLists, ParallelDownloads and add ILoveCandy"
echo "Don't uncomment ParallelDownloads if internet is slow or unstable, it'll break whole installation"
read -p "Press any key to continue"
nvim /etc/pacman.conf

### Synchronize pacman
pacman -Syy

### Install Packages
# copied from https://gitlab.com/eflinux/arch-basic/-/blob/master/base-uefi.sh?ref_type=heads
# if installing on a laptop, also install tlp
# will see if I need these avahi nss-mdns
pacman --noconfirm -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync man-db htop fastfetch pacman-contrib grub-btrfs xdg-user-dirs xdg-utils duf inxi eza xwaylandvideobridge gnome-disk-utility firewalld os-prober ntfs-3g intel-media-driver libva-mesa-driver ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts sof-firmware inetutils curl wget

### Enable Services
systemctl enable NetworkManager
systemctl enable fstrim.timer # for ssd
systemctl enable firewalld
# systemctl enable avahi-daemon
# systemctl enable tlp # my current laptop battery is dead

### Grub installation
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

echo "enable os-prober in grub"
echo "Uncmment GRUB_DISABLE_OS_PROBER=false"
read -p "Press any key to continue"
nvim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

### Add btrfs to mkinitcpio
echo "add btrfs to mkinitcpio module"
echo "Before: MODULES=()"
echo "After:  MODULES=(btrfs)"
read -p "Press any key to continue"
nvim /etc/mkinitcpio.conf
mkinitcpio -p linux

### Set Root Password
echo "Set root password"
passwd

### Add User
useradd -mG wheel $username
passwd $username
usermod -c "$fullname" $username

### Add user to wheel
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=nvim sudo -E visudo
usermod -aG wheel $username

### Firewall config
firewall-cmd --add-port=1025-65535/tcp --permanent
firewall-cmd --add-port=1025-65535/udp --permanent
firewall-cmd --reload

### Move all the scripts to home dir
mv /archinstall/zram.sh /home/$username
mv /archinstall/paru.sh /home/$username
mv /archinstall/yay.sh /home/$username
mv /archinstall/timeshift.sh /home/$username
mv /archinstall/snapshot.sh /home/$username
mv /archinstall/preload.sh /home/$username

clear
printf "\e[1;32mDone! Type exit if prompt is '[root@archiso /]' instead of 'root@archiso ~', umount -R /mnt and reboot.\e[0m"
