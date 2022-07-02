#!/bin/zsh -e

echo 'Installing bspwm and related packages...'
packages=(
	bspwm
	dunst
	alacritty
	rofi
	feh
	xprop
	xorg-minimal
	xsetroot
	xf86-video-amdgpu
	picom
	scrot
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

echo "Updating .xserverrc..."
cat <<EOF > $HOME/.xserverrc
#!/bin/sh

exec /usr/bin/Xorg -nolisten tcp "$@" vt$XDG_VTNR
EOF

echo 'Setting git helper...'
git config --global credential.helper /usr/libexec/git-core/git-credential-libsecret

echo "bspwm has been installed and configured successfully."
