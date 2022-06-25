#!/bin/zsh -e

echo "Downloading ungoogled-chromium from github..."
github_url="https://github.com/DAINRA/ungoogled-chromium-void/releases"

http_get_response=$(curl -Is "$github_url/latest" | grep "location: https")

# Get latest version from location value in the response header
IFS='/' read -rA latest_version_t <<< "$http_get_response"
latest_version=$(echo ${latest_version_t[-1]} | sed "s/v//g" | sed 's/\r$//')

# Get redirect url from initial download url
echo "Getting download url..."
download_url="$github_url/download/v$latest_version"
filename="ungoogled-chromium-$latest_version.x86_64.xbps"
download_url=$(curl -v -Is "$download_url/$filename" | grep "location: https:" | sed "s/location: //g" | sed 's/\r$//')

echo "Downloading file..."
download_dir=$HOME/void-repository
mkdir -p $download_dir
cd $download_dir
curl -L -o $filename "$download_url"

echo "Ungoogled-chromium downloaded to $download_dir successfully." 
