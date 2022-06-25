#!/bin/zsh -e

echo "Adding SG mirror to xbps..."
if ! [[ -d /etc/xbps.d ]]; then
	sudo mkdir -p /etc/xbps.d
	echo "Created /etc/xbps.d directory"
fi
sudo tee /etc/xbps.d/00-repository-main.conf > /dev/null <<EOF
repository=https://void.webconverger.org/current
repository=https://void.webconverger.org/current/nonfree
repository=https://void.webconverger.org/current/multilib
repository=https://void.webconverger.org/current/multilib/nonfree
EOF

sudo xbps-install -S

echo "Added SG mirror successfully."
