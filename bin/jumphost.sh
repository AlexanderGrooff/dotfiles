#!/usr/bin/env bash

# Set up socks proxy over port 5000
if [[ $(grep "Arch Linux" /etc/os-release) ]]; then
    eval $(/usr/bin/gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
    autossh -M 0 -D localhost:5000 -N jh
else
    ssh jh -N -D 5000
fi
