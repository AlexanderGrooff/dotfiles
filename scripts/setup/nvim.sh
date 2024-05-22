#!/usr/bin/env bash

set -e
set -x

mkdir -p ~/.config/nvim
pushd ~/.config/nvim
# Check if AstroNvim is already present
if ! git remote -v | grep -qi astronvim; then
    # Remove local state
    rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim || true
    popd
    # Install AstroNvim
    git clone --depth 1 https://github.com/AlexanderGrooff/astronvim ~/.config/nvim
    pushd ~/.config/nvim
fi
git pull
popd

# Setup initial AstroNvim config
nvim  --headless -c 'quitall'
