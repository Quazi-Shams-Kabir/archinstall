# ARCH BTW installation

## Initial setup

### Configure network

```bash
$ iwctl
```

```bash
$ station wlan0 connect SSID # followed by entering password then exit
```

### Update gpg keys
```bash
$ pacman-key --init
$ pacman-key --populate archlinux
$ pacman -Syy
```

### Disk partition
```bash
$ lsblk
$ gdisk /dev/sda # or partition name you want to install arch on
```

```bash
o # empty partition table of the selected disk
p # print partion table
n # new partition
# select default partion no.
# select default first sector
+100M # in last sector
ef00 # in partion type
n
# keep choosing default till last sector
# this will create 100mb efi partition and remaining disk space for fs
```

### Download this repo
```bash
$ pacman -S git
$ git clone https://github.com/Quazi-Shams-Kabir/archinstall
```

### Start installation
```bash
$ cd archinstall
$ ./baseInstall.sh
```

```bash
# when prompt to ask for partition name
$ sda1 # or other efi partition name
$ sda2 # root partition name
```


#### Now just wait and follow along...

User intervention will be required 7 times
1. pacstrap
2. genfstab confirmation
3. pacman config
4. enable os-prober
5. btrfs module in mkinitcpio
6. root password, user password, add user to wheel group
7. exit
