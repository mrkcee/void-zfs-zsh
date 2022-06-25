#!/bin/zsh -e

packages=(
	papirus-icon-theme
	papirus-folders
	font-firacode
	noto-fonts-cjk
	noto-fonts-emoji
	freefont-ttf
	fonts-roboto-ttf
	libreoffice-writer
	libreoffice-calc
	libreoffice-fonts
	vlc
	ghex
	keepassxc
	nextcloud-client
	neofetch
	pfetch
	htop
	ranger
	pcmanfm
	evince
	textlive
	textlive-LuaTeX
	textlive-XeTex
	texlive-bin
)

sudo xbps-install -S -y "${packages[@]}"

echo "Extra packages installed successfully."
