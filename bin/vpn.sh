#!/usr/bin/env bash
# This file is managed by chezmoi. Do not edit directly.

set -e

TARGET=$1

if [ -z $TARGET ]; then
    echo "Choose a target from: $(ls ~/vpn)"
    exit 1
fi

cd ~/vpn/$TARGET
sudo openvpn *.ovpn
