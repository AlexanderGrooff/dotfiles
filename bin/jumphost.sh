#!/usr/bin/env bash

if [[ $(grep "Arch Linux" /etc/os-release) ]]; then
    ssh jh -N -D 5000
else
    ssh jh -N -D 5000
fi
