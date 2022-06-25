#!/bin/zsh -e

echo "Installing nvidia drivers..."
packages=(
	nvidia
	nvidia-libs-32bit
)

sudo xbps-install -S -y "${packages[@]}"

echo "Nvidia drivers installed successfully."
