#!/bin/zsh -e

echo "Installing gnome-keyring..."
sudo xbps-install -S -y gnome-keyring

# Set path
pamd_login=/etc/pam.d/login

# Create temp file
echo "Inserting lines to $pamd_login..."
random_guid=$(uuidgen)
temp_file=/tmp/login.tmp-$random_guid
while IFS= read -r line; do
	
	if ! (echo $line | grep -q auth) && (echo $previous_line | grep -q auth); then
		echo "auth		optional	pam_gnome_keyring.so" >> $temp_file
	fi
	previous_line=$line

	echo $line >> $temp_file

done < $pamd_login

echo "session		optional	pam_gnome_keyring.so auto_start" >> $temp_file

# Copy temp file to actual path
sudo cp $temp_file $pamd_login

# Clean up
echo "Cleaning up..."
rm -f $temp_file

echo "GNOME Keyring installed successfully."
