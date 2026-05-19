#!/usr/bin/env bash

set -x

sudo pkill openvpn
/home/alex/bin/vpn.sh tbvpn &
sleep 3
systemctl restart --user hnproxy.service
