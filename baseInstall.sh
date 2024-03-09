#!/bin/bash

clear

### Enter partition names
lsblk
read -p "EFI partition: " sda1
read -p "ROOT partition: " sda2

### Sync time and timezone
timedatectl set-ntp true
timedatectl set-timezone Asia/Kolkata
timedatectl

### Format partitions
mkfs.fat -F 32 /dev/$sda1;
mkfs.btrfs -f /dev/$sda2

### Mount points for btrfs
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@log
umount /mnt

mount -o compress=zstd,noatime,ssd,space_cache=v2,discard=async,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd,noatime,ssd,space_cache=v2,discard=async,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd,noatime,ssd,space_cache=v2,discard=async,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount -o compress=zstd,noatime,ssd,space_cache=v2,discard=async,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd,noatime,ssd,space_cache=v2,discard=async,subvol=@log /dev/$sda2 /mnt/var/log
mount /dev/$sda1 /mnt/boot/efi

### Install base packages
pacstrap -K /mnt base base-devel git linux linux-firmware linux-zen linux-headers linux-zen-headers neovim intel-ucode mtools dosfstools btrfs-progs

### Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
read -p "Is the fstab correct? (y/n) " fstab
if [ $fstab == "n" ]; then
    nvim /mnt/etc/fstab
fi

### Copy configuration scripts
mkdir /mnt/archinstall
cp baseConfiguration.sh /mnt/archinstall/
cp zram.sh /mnt/archinstall/
cp paru.sh /mnt/archinstall/
cp yay.sh /mnt/archinstall/
cp timeshift.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/
# cp 6-preload.sh /mnt/archinstall/

### Chroot to installed sytem and run configuration script
arch-chroot /mnt ./archinstall/baseConfiguration.sh
