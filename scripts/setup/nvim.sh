#!/usr/bin/env bash

set -e
set -x

# Check if AstroNvim is already present
pushd ~/.config/nvim || /bin/true
if ! git remote -v | grep -q Astro; then
    # Remove local state
    rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim || /bin/true
    cd
    # Install AstroNvim
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
fi
popd

# Setup initial AstroNvim config
nvim  --headless -c 'quitall'
