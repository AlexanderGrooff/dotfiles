#!/usr/bin/env bash

if [[ $(uname -r) == *"arch"* ]]; then
    autossh -M 0 jh -N -D 5000
else
    autossh jh -N -D 5000
fi
