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
read -p "Press any key to continue"
nvim /etc/pacman.conf

### Synchronize pacman
pacman -Syy

### Install Packages
# copied from https://gitlab.com/eflinux/arch-basic/-/blob/master/base-uefi.sh?ref_type=heads
# if installing on a laptop, also install tlp and acpi_call
pacman --noconfirm -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant avahi inetutils dnsutils cups alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi dnsmasq openbsd-netcat ipset firewalld sof-firmware nss-mdns os-prober ntfs-3g man-db htop fastfetch xf86-video-amdgpu xf86-video-intel pacman-contrib grub-btrfs xdg-user-dirs xdg-utils duf inxi

### Enable Services
systemctl enable NetworkManager
systemctl enable fstrim.timer # for ssd
systemctl enable firewalld

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
mkinitcpio -p linux-zen

### Set Root Password
echo "Set root password"
passwd

### Add User
echo "Add user $username"
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

### Move all the scripts to home dir
mv /archinstall/zram.sh /home/$username
mv /archinstall/paru.sh /home/$username
mv /archinstall/yay.sh /home/$username
mv /archinstall/timeshift.sh /home/$username
mv /archinstall/snapshot.sh /home/$username

clear
printf "\e[1;32mDone! Type exit if prompt is '[root@archiso /]' instead of 'root@archiso ~', umount -R /mnt and reboot.\e[0m"
