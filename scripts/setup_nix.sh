#!/usr/bin/env bash

function install_nix() {
  sudo rm -rf /etc/nix
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  sudo rm -rf /etc/nix/nix.conf
  sudo mkdir -p /etc/nix
  sudo ln -s /home/alex/.config/nix/nix.conf /etc/nix/nix.conf
}

if [ ! -e /nix ]; then
  echo "Nix not found, starting installation..."
  install_nix
  exit 0
fi

if [ -e /nix/receipt.json ]; then
  echo "Found existing zero-to-nix installation, nothing to do..."
  exit 0
fi

read -p "Old installation found that's unstable, do you wanna purge nix? (y/n)" -r
echo

if [[ $REPLY =~ ^[Yy\n\r]$ ]]; then
  echo "Attempting to fix installation"
  set -x
  set -e
  sudo rm -rf /nix || /bin/true
  sudo rm -rf /etc/nix || /bin/true
  sudo groupdel nixbld || /bin/true
  sudo mkdir /etc/nix
  install_nix
else
  echo "Not fixing old installation"
  exit 2
fi
