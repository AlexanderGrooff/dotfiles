# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Show all services listening to ports
alias lsofp='lsof -Pnl +M -i4'

# some more ls aliases
alias ll='ls -hlAF'

# mkdir goes to created dir
function createAndMoveToDir { 
    mkdir "$1"
    cd "$1"
}
alias mkd='createAndMoveToDir'

# git aliases
alias gsp='git stash pop'
alias gcm='git checkout master'
alias gp='git pull'
alias gc='git commit'
alias gca='git commit --amend'

# docker aliases
alias drmc='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias drmi='docker rmi $(docker images -a --filter=dangling=true -q)'
alias drmv='docker volume ls -qf dangling=true | xargs -r docker volume rm'
alias dc='docker-compose'
alias katt='dc kill && dc rm -f && dc up -d'

# Commonly used repos
alias ap='cd /home/alex/code/byte/hypernode-api; workon hypernode-api'
alias bdb='cd /home/alex/code/byte/bytedb-python; workon bytedb'
alias biab='cd /home/alex/code/byte/byte-in-a-box; workon byte-in-a-box'
alias cl='cd /home/alex/code/byte/hypernode-control; workon hypernode-control'
alias de='cd ~; deactivate'
alias ka='cd /home/alex/code/byte/hypernode-kamikaze'
alias kaa='cd /home/alex/code/byte/hypernode-kamikaze3; workon hypernode-kamikaze3'
alias pi='cd /home/alex/code/byte/pino; workon pino'
alias qs='deactivate 2> /dev/null; cd /home/alex/code/byte/quickscan'
alias sp='cd /home/alex/code/byte/servicepanel-python; workon servicepanel-python'
alias ma='cd /home/alex/code/byte/magereport; workon magereport'

# Systemctl aliases
alias susy='sudo systemctl'

# Pip stuff
alias pir='pip install -r requirements/development.txt'

# Create venv in current dir
alias mkv='mkvirtualenv -a . -p python3 $(basename $(pwd))'

# On Buster, fd is installed under fdfind
if [ -x /usr/bin/fdfind ]; then
    alias fd='fdfind'
fi
