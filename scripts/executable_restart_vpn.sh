#!/usr/bin/env bash
# This file is managed by chezmoi. Do not edit directly.

set -x

sudo pkill openvpn
/home/alex/bin/vpn.sh tbvpn &
sleep 3
systemctl restart --user hnproxy.service
