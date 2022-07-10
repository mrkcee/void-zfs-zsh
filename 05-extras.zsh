#!/bin/zsh -e

packages=(
	firefox
	papirus-icon-theme
	papirus-folders
	font-firacode
	noto-fonts-cjk
	noto-fonts-emoji
	freefont-ttf
	fonts-roboto-ttf
	nerd-fonts-ttf
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
