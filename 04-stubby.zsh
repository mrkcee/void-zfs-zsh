#!/bin/zsh -e

echo "Installing stubby and dnsmasq..."
packages=(
	stubby
	dnsmasq
)

sudo xbps-install -S -y "${packages[@]}"

echo "Configuring stubby..."
sudo tee -a /etc/stubby/stubby.yml > /dev/null <<EOF
listen_addresses:
  - 127.0.0.1@53000
	- 0::1@53000
EOF

echo "Configuring dnsmasq..."
sudo tee /etc/dnsmasq.conf > /dev/null <<EOF
no-resolv
proxy-dnssec
server=127.0.0.1#53000
server=::1#53000
listen-address=::1,127.0.0.1
EOF

sudo tee /etc/resolv.conf > /dev/null  <<EOF
nameserver 127.0.0.1
nameserver ::1
EOF

sudo chattr +i /etc/resolv.conf

echo "DNS configuration is complete."
echo "NOTE: update stubby.yml with the desired DNS service provider configuration."
