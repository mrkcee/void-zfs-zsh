#!/bin/zsh -e

function list_disks_by_id() {
	# Manually created menu instead of using select-loop to allow formatting
	echo "List of available disks: "
	disks_found=$(find /dev/disk/by-id/ -type l ! -iwholename "*-part*" ! -iwholename "*wwn*" -printf "%f ")
	disks_found=(`echo ${disks_found}`)

	disk_count=${#disks_found[@]}
	for i in $(seq 1 $disk_count)
	do
		# color, index, color, disk, color
		echo "($i) $disks_found[$i]"
	done

	vared -p "Select the disk you want to install to: " -c selected_option
	if [[ $selected_option -ge 1 && $selected_option -le $disk_count ]]; then
		selected_disk="/dev/disk/by-id/$disks_found[$selected_option]"
	else
		echo "Invalid option. Exiting..."
		exit 1
	fi

	echo "Selected disk: $selected_disk"
	echo $selected_disk > /tmp/selected_installation_disk
}
