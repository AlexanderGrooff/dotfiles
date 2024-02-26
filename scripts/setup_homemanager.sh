#!/usr/bin/env bash

set -e

# if command -v home-manager > /dev/null; then
#   home-manager switch
#   exit 0
# fi

nix run home-manager/master -- switch --flake "#$(hostname)"
