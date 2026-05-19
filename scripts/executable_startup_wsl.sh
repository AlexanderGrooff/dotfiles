#!/usr/bin/env bash

set -x

if [ ! -e /etc/wsl.conf ]; then
  echo "You're not running WSL!"
  exit 2
fi

sudo systemctl restart user@1000
sudo systemctl restart tailscaled
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/byte
systemctl restart --user syncthing
