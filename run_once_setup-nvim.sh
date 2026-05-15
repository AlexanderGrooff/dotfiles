#!/usr/bin/env bash
# Run once: set up Neovim plugins
set -e

VIM_PLUG="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$VIM_PLUG" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$VIM_PLUG" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v nvim >/dev/null 2>&1; then
  nvim --headless +PlugInstall +qa
fi
