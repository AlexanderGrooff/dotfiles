#!/usr/bin/env python3

# Use the dotfiles in this dir over the configs from Nix.
# This is easy for rapid development instead of having to rebuild
# Nix every change.

import subprocess

FILES = [
    ".bash_aliases",
    ".zshrc",
    ".config/waybar",
]

for file in FILES:
    print(f"Replacing {file}")
    subprocess.check_output(f"rm -rf ~/{file}.old", shell=True)
    subprocess.check_output(f"mv ~/{file} ~/{file}.old", shell=True)
    subprocess.check_output(f"ln -s ~/code/dotfiles/{file} ~/{file}", shell=True)
