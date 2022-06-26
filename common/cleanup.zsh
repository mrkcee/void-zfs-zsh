#!/bin/zsh -e

function cleanup() {
	rm -f /tmp/selected_installation_disk
	rm -f /tmp/00-configure-completed
	rm -f /tmp/rootfs_dataset
	
	echo "Deleted temporary files."
}
