#!/bin/zsh -e

if ! [[ $UID == 0 || $EUID == 0 ]]; then echo 'Root access is required to run this script.'; exit 1; fi

# Check if 00-configure.zsh has been completed
if ! [[ -e /tmp/00-configure-complete ]]; then
	echo "Configuration not completed. Please run 00-configure.zsh."
	exit 1
fi

# Select disk
source ./common/list_disks_by_id.zsh
list_disks_by_id
selected_disk=$(cat /tmp/selected_installation_disk)
efi_partition="$selected_disk-part1"

# Root dataset
root_dataset=$(cat /tmp/root_dataset)

# Set mirror and architecture
preferred_repo="https://void.webconverger.org/current"
xbps_arch="X86_64"

# Copy keys
echo "Copying XBPS keys"
mkdir -p /mnt/var/db/xbps/keys
cp /var/xbps/keys/* /mnt/var/db/xbps/keys/

### Install base system and additional packages
echo "Installing Void Linux - base system..."
export XBPS_ARCH=$xbps_arch
xbps-install -y -s -r /mnt -R $preferred_repo base-system
echo "Base-system installed."

echo "Installing packages..."
packages=(
	zfs
	zfsbootmenu
	efitbootmgr
	gummiboot
	chrony
	snooze
	acpid
	socklog-void
	NetworkManager
	openresolve
	git
	neovim
	zsh
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-completions
	curl
	u2f-hidraw-policy
)

xbps-install -y -S -r /mnt "${packages[@]}"
echo "Additional packages installed."

# Disable gummiboot post install hooks, only installs for generate-zbm
echo "GUMMIBOOT_DISABLE=1" > /mnt/etc/default/gummiboot

# Init chroot
echo "Pre-chroot initialization..."
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc

# Set hostname
echo "Setting hostname..."
vared -p "Enter hostname: " -c hostname
echo $hostname > /mnt/etc/hostname

# Configure zfs
echo 'Copying ZFS files to /mnt...'
cp /etc/hostid /mnt/etc/hostid
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache
# add cp key file here if pool is encrypted

# Configure DNS (from live)
echo 'Copying resolv.conf to /mnt...'
cp /etc/resolv.conf /mnt/etc/

# Prepare locales and keymap
echo 'Setting up locales and keymap in /mnt...'
echo 'KEYMAP=us' > /mnt/etc/vconsole.conf
echo 'en_US.UTF-8 UTF-8' > /mnt/etc/default/libc-locales
echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

# Configure system
echo 'Configuring rc.conf in /mnt...'
cat <<EOF > /mnt/etc/rc.conf
KEYMAP="us"
TIMEZONE="Asia/Manila"
EOF

# Configure dracut
echo 'Configuring dracut in /mnt...'
cat <<EOF > /mnt/etc/dracut.conf.d/zol.conf
hostonly="yes"
nofsck="yes"
add_dracutmodules+=" zfs "
omit_dracutmodules+=" btrfs resume "
EOF

### Configure username
echo 'Setting username...'
vared -p "Enter username: " -c user

### Chroot
echo 'Performing chroot to /mnt to configure service...'
cat <<EOF | chroot /mnt/ /bin/bash -e
  # Configure DNS
  resolvconf -u
  # Configure services
  ln -s /etc/sv/chronyd /etc/runit/runsvdir/default/
  ln -s /etc/sv/dbus /etc/runit/runsvdir/default/
  ln -s /etc/sv/acpid /etc/runit/runsvdir/default/
  ln -s /etc/sv/socklog-unix /etc/runit/runsvdir/default/
  ln -s /etc/sv/nanoklogd /etc/runit/runsvdir/default/
  ln -s /etc/sv/NetworkManager /etc/runit/runsvdir/default/
  # Generates locales
  xbps-reconfigure -f glibc-locales
  # Add user
  useradd -m $user -G network,wheel,socklog,video,audio,input
  # Configure fstab
  grep efi /proc/mounts > /etc/fstab
EOF

### Configure fstab
echo 'Configuring fstab in /mnt...'
cat <<EOF > /mnt/etc/fstab
$efi_partition /efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro 0 0
efivarfs  /sys/firmware/efi/efivars  efivarfs  rw,nosuid,nodev,noexec,relatime 0 0
tmpfs     /dev/shm                   tmpfs     rw,nosuid,nodev,noexec,inode64  0 0
tmpfs     /tmp                       tmpfs     defaults,nosuid,nodev           0 0
EOF

# Set root passwd
echo 'Setting root password...'
chroot /mnt /bin/passwd

# Set user passwd
printf 'Setting %s password...\n' $user
chroot /mnt /bin/passwd $user

# Configuring sudo
echo 'Configuring sudo in /mnt...'
cat <<EOF > /mnt/etc/sudoers
root ALL=(ALL) ALL
$user ALL=(ALL) ALL
Defaults rootpw
EOF

### Configure ZFSBootMenu
# Create dirs
mkdir -p /mnt/efi/EFI/ZBM /etc/zfsbootmenu/dracut.conf.d

# Generate ZFSBootMenu efi
echo 'Configuring ZFSBootMenu...'
cat <<EOF > /mnt/etc/zfsbootmenu/config.yaml
Global:
  ManageImages: true
  BootMountPoint: /efi
  DracutConfDir: /etc/zfsbootmenu/dracut.conf.d
Components:
  Enabled: false
EFI:
  ImageDir: /efi/EFI/ZBM
  Versions: false
  Enabled: true
Kernel:
  CommandLine: ro quiet loglevel=0 zbm.import_policy=hostid
  Prefix: vmlinuz
EOF

# Set cmdline
zfs set org.zfsbootmenu:commandline="ro quiet nowatchdog loglevel=0" zroot/ROOT/"$root_dataset"

echo 'Generating ZFSBootMenu...'
cat <<EOF | chroot /mnt/ /bin/bash -e
export LANG="en_US.UTF-8"
xbps-reconfigure -fa
EOF

source ./common/create_zbm_boot_entry.zsh
create_zbm_boot_entry

# Umount all partitions
echo 'Unmount partitions used during chroot...'
umount /mnt/efi
umount -l /mnt/{dev,proc,sys}
zfs umount -a

# Export zpool
echo 'Exporting zpool...'
zpool export zroot

# Clean up
echo "Cleaning up..."
source ./common/cleanup.zsh
cleanup

echo "Installation complete."
