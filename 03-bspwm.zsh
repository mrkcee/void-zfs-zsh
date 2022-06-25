#!/bin/zsh -e

echo 'Installing bspwm and related packages...'
packages=(
	bspwm
	dunst
	alacritty
	rofi
	feh
	elogind
	gnome-keyring
	xprop
	xorg-minimal
	xsetroot
	picom
)

sudo xbps-install -S -y "${packages[@]}"

echo 'Cloning config files...'
random_guid=$(uuidgen)
mkdir -p /tmp/$random_guid
cd /tmp/$random_guid
git clone --depth 1 https://github.com/mrkcee/bspwm-dotfiles.git
cd bspwm-dotfiles
./install.zsh
rm -rf /tmp/$random_guid

echo 'Updating .xinitrc...'
xinitrc_path=~/.xinitrc
echo "exec bspwm" > $xinitrc_path

echo 'Setting git helper...'
git config --global credential.helper /usr/libexec/git-core/git-credential-libsecret

echo "bspwm has been installed and configured successfully."
cat <<EOF
NOTE:
Add the following in /etc/pam.d/login
=========================================================================
Add after the last auth line:
auth            optional        pam_gnome_keyring.so

Add after last session line:
session         optional        pam_gnome_keyring.so auto_start
=========================================================================
EOF
