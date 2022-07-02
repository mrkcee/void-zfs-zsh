#!/bin/zsh -e

echo "Installing mesa drivers..."
packages=(
	mesa-dri
	mesa-dri-32bit
	vulkan-loader
	mesa-vulkan-radeon
	mesa-vaapi
	mesa-vdpau
)

sudo xbps-install -S -y "${packages[@]}"

echo "Omiting gpu drivers in ZBM..."
if ! [[ -e /etc/zfsbootmenu/dracut.conf.d/drivers.conf ]]; then
	sudo tee /etc/zfsbootmenu/dracut.conf.d/drivers.conf > /dev/null <<EOF
omit_drivers+=" amdgpu radeon nvidia nouveau i915 "
EOF
fi

sudo xbps-reconfigure -f zfsbootmenu

echo "mesa drivers installed successfully."
