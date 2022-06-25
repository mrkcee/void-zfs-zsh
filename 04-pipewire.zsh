#!/bin/zsh -e

echo "Installing pipewire..."
packages=(
	pipewire
	pulseaudio-utils
)
sudo xbps-install -S -y "${packages[@]}"

echo "Adding pipewire to .xinitrc..."
random_guid=$(uuidgen)
temp_file=/tmp/xinitrc-$random_guid
xinitrc_file=$HOME/.xinitrc

cat <<EOF > $temp_file
### Added by 04-pipewire.zsh
pipewire &
pipewire-pulse &
###
EOF

if [[ -f $xinitrc_file  ]]; then
	cat $xinitrc_file >> $temp_file
	cp -r $temp_file $xinitrc_file
fi

echo "Cleaning up..."
rm -f $temp_file

echo "Pipewire installed successfully."

