#!/bin/bash
# This script will call the github API to get the latest release
# version of fd then will download the binary (deb package) and
# install it.
set -e

api='https://api.github.com/repos/sharkdp/fd/releases/latest'
regex='.*amd64.deb'

package=$(curl --silent $api | python scripts/latest-github-release.py "$regex")
echo found package URL: $package

cd /tmp
wget "$package"

filename=$(basename $package)
echo filename: $filename

echo Installing fd:
sudo dpkg -i /tmp/$filename
