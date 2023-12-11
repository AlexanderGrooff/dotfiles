#!/usr/bin/env bash

if [ ! -e /etc/wsl ]; then
  echo "You're not running WSL!"
  exit 2
fi

sudo systemctl restart user@1000
sudo systemctl restart tailscaled
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/byte
