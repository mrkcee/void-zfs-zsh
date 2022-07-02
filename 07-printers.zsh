#!/bin/zsh -e

echo "Installing cups and other related packages..."
packages=(
	avahi
	cups
	cups-filters
	hplip
	nss-mdns
)

sudo xbps-install -S -y "${packages[@]}"

echo "Enabling avahi daemon..."
sudo ln -s /etc/sv/avahi-daemon /var/service

echo "CUPS installed successfully."
