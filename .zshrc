# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
export ZSH_THEME="agnoster"
export EDITOR=vim
export CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  taskwarrior
)

export PATH=$PATH:$HOME/.local/bin:$HOME/scripts:/sbin:$HOME/.cargo/bin:$HOME/npm/bin

source $ZSH/oh-my-zsh.sh

# Load SSH key into keychain
export SSH_KEY_PATH=`find $HOME/.ssh/ -name 'id_*' | egrep -v ".*pub"`
if which keychain > /dev/null; then
    eval $(keychain -q --eval $SSH_KEY_PATH)
else
    ssh-add -K $SSH_KEY_PATH
fi


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ZSH bindkeys
if [ -f ~/.zsh_keys ]; then
    . ~/.zsh_keys
fi

# Activate virtualenvwrapper
VEW_SCRIPT=$(dpkg -L virtualenvwrapper | egrep 'virtualenvwrapper.sh$')
source $VEW_SCRIPT

# Set keyboard rate and delay
if [[ `command -v xset` ]]; then
    xset r rate 175 45
fi

# Use fd for fzf
if [ -x /usr/bin/fdfind ]; then
    export FZF_DEFAULT_COMMAND='fdfind --hidden --exclude ".git" .';
else
    export FZF_DEFAULT_COMMAND='fd --hidden --exclude ".git" .';
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [[ `command -v doctl` ]]; then source <(doctl completion zsh); fi
if [[ `command -v kubectl` ]]; then source <(kubectl completion zsh); fi
if [[ `command -v flux` ]]; then source <(flux completion zsh); fi

if [ -f $HOME/kubeconfig ]; then
    export KUBECONFIG=$HOME/kubeconfig
elif [ -f $HOME/.kube/config ]; then
    export KUBECONFIG=$HOME/.kube/config
fi

NIX_HOME="/nix/var/nix/profiles/per-user/$(whoami)"
NIX_PROFILE="$NIX_HOME/profile/etc/profile.d/nix.sh"
if [ -f $NIX_PROFILE ]; then
    NIX_BIN="$NIX_HOME/profile/bin"
    export PATH=$PATH:$NIX_BIN
    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
    source $NIX_PROFILE
fi
eval "$(direnv hook zsh)"
source /etc/bash_completion.d/complete_alias
