#!/bin/zsh -e

echo "Installing pipewire..."
packages=(
	pipewire
	pulseaudio-utils
	wireplumber
)
sudo xbps-install -S -y "${packages[@]}"

echo "Adding pipewire to .xinitrc..."
random_guid=$(uuidgen)
temp_file=/tmp/xinitrc-$random_guid
xinitrc_file=$HOME/.xinitrc

cat <<EOF > $temp_file
### Added by 04-pipewire.zsh
pipewire &
###
EOF

if [[ -f $xinitrc_file  ]]; then
	cat $xinitrc_file >> $temp_file
	cp -r $temp_file $xinitrc_file
fi

echo "Configuring wireplumber..."
conf_temp_file=/tmp/pipewire.conf-$random_guid
sudo mkdir -p /etc/pipewire
cp /usr/share/pipewire/pipewire.conf $conf_temp_file
sed -i '/^context.exec =.*/a { path = "/usr/bin/wireplumber" args = "" }\n{ path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" }' $conf_temp_file
sed -i '/{ path = "\/usr\/bin\/pipewire-media-session" args.*/d' $conf_temp_file
sudo cp $conf_temp_file /etc/pipewire/pipewire.conf 

echo "Cleaning up..."
rm -f $temp_file
rm -f $conf_temp_file

echo "Pipewire installed successfully."

