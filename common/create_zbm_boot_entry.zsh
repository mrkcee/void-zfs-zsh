#!/bin/zsh -e

function create_zbm_boot_entry() {
  if ! [[ -f /etc/selected_installation_disk ]]; then
		source list_disks_by_id.zsh
		list_disks_by_id
	fi
	selected_disk=$(cat /etc/selected_installation_disk)
  
	echo "Checking boot EFI entries..."
	modprobe efivarfs
	mountpoint -q /sys/firmware/efi/efivars || mount -t efivarfs efivarfs /sys/firmware/efi/efivars

	if ! efibootmgr | grep ZFSBootMenu; then
		echo "ZFSBootMenu not found."
		echo "Creating boot entries..."
		efibootmgr --disk "$selected_disk" \
			--part 1 \
			--create \
			--label "ZFSBootMenu Backup" \
			--loader "\EFI\ZBM\vmlinuz-backup.efi" \
			--verbose
		efibootmgr --disk "$selected_disk" \
			--part 1 \
			--create \
			--label "ZFSBootMenu" \
			--loader "\EFI\ZBM\vmlinuz.efi" \
			--verbose
		echo "ZBM boot entries creation completed successfully."
	else
		echo "Boot entries are already existing."
	fi

	source cleanup.zsh
	cleanup_tmp
}
