#!/usr/bin/env bash

if [[ $(grep "Arch Linux" /etc/os-release) ]]; then
    if [ $(command -v gnome-keyring-daemon) ]; then
        eval $(/usr/bin/gnome-keyring-daemon --start)
    fi
    export SSH_AUTH_SOCK
    autossh -M 0 -D localhost:5000 -N jh
else
    ssh jh -N -D 5000
fi
