# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [[ `command -v zsh` ]]; then
    if `test $SHELL = $(which zsh)`; then
        echo "Loading zshrc"
        source $HOME/.zshrc
    fi
else
    echo "ZSH not found, loading bashrc"
    # if running bash
    if [ -n "$BASH_VERSION" ]; then
        # include .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$HOME/.cargo/bin:$PATH"

if [ -e /etc/wsl.conf ]; then
    bash -x /home/alex/scripts/startup_wsl.sh
fi
if [ -e /home/alex/.nix-profile/etc/profile.d/nix.sh ]; then . /home/alex/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
