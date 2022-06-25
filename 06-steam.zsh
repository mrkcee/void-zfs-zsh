#!/bin/zsh -e

echo "Installing steam..."
packages=(
	steam
	libgcc-32bit
	libstdc++-32bit
	libdrm-32bit
	libglvnd-32bit
)

sudo xbps-install -S -y "${packages[@]}"

echo "Steam installed successfully."
