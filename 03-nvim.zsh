#!/bin/zsh

echo 'Installing fzf and ripegrep...'
sudo xbps-install -S -y fzf ripegrep xtool

echo 'Installing vim-plug...'
if ! [[ -d $HOME/.local/share/nvim/site/autoload ]]; then
	mkdir -p $HOME/.local/share/nvim/site/autoload
fi
curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Vim-plug for nvim has been installed."
