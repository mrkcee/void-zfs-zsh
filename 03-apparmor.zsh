#!/bin/zsh -e

echo "Installing apparmor..."
sudo xbps-install -S -y apparmor

echo "Adding apparmor to kernel commandline..."
current_commandline=$(zfs get -H -o value org.zfsbootmenu:commandline zroot/ROOT/void)
new_commandline="$current_commandline apparmor=1 security=apparmor"
sudo zfs set org.zfsbootmenu:commandline="$new_commandline" zroot/ROOT/void

echo "Apparmor installation complete."
