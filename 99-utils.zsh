#!/bin/zsh -e

echo "Utilities Menu"
scripts=(`ls ./common`)
select option in $scripts
do
	if ! (($scripts[(Ie)$option])); then
		echo "Invalid option."
	else
		source ./common/$option
		local filename=$(echo $option | sed "s/.zsh//")
		$filename
	fi
	break
done
