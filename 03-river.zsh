#!/bin/zsh -e

echo "Installing river and related packages..."
packages=(
	foot
	fuzzel
	grim
	mako
	river
	slurp
	wbg
	wl-clipboard
	yambar
)

sudo xbps-install -S -y "${packages[@]}"

echo "river installed successfully."
