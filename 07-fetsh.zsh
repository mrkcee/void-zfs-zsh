#!/bin/zsh -e

echo "Downloading fet.sh from github..."
sudo curl -s -o /usr/bin/fet.sh https://raw.githubusercontent.com/6gk/fet.sh/master/fet.sh
sudo chmod +x /usr/bin/fet.sh

echo "fet.sh installed successfully."
