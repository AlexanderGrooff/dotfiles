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
function mkd {
    mkdir "$1"
    cd "$1"
}

function log() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

# git aliases
alias gsp='git stash pop'
alias gcm='git checkout master'
alias gp='git pull'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gdf='git diff'
alias gpb='git checkout -'
alias grh='git reset --hard'
alias gph='git push -u origin HEAD'
alias doit='ga .; gca --no-edit; gpf'
function gch {
    local target="$@"  # All arguments. Don't checkout '-b' of `gch -b target-branch`
    # Check if target is a github url
    if [[ $target == *"github.com"* ]]; then
        local local_repo=$(git remote get-url origin | cut -d: -f2 | sed 's/.git//g')
        if [[ $target == *"$local_repo"* ]]; then
            local pr_nr=$(echo $target | sed -r 's/.*\/pull\/([0-9]+)/\1/g')
            gh pr checkout $pr_nr
        else
            echo "Tried checkout but target repo does not match $local_repo"
        fi
    else
        # Echo multiple args
        git checkout $(echo $target)
    fi
}
function gpr {
    local tmpfile=$(mktemp)
    trap "rm $tmpfile" EXIT
    local initial_title=$(git log --pretty=format:%s HEAD~1..HEAD)
    local initial_body=$(git log --pretty=format:%b HEAD~1..HEAD | tr '\n' ' ' | sed 's/^ //g')

    echo $initial_title > $tmpfile
    echo "" >> $tmpfile
    echo $initial_body >> $tmpfile
    $EDITOR $tmpfile
    local title=$(cat $tmpfile | head -n1)
    local body=$(cat $tmpfile | tail -n+3)

    local url=$(gh pr create --title "$title" --body "$body" | tail -n1)
    echo "$url $title"
}
function rmcommit {
    commits=`git log $1..HEAD --pretty=format:%H`
    echo "Stashing changes"
    git stash
    echo "\nSetting HEAD to just before commit $1"
    git reset --hard $1~1
    echo "\nApplying inbetween commits: $commits"
    git cherry-pick $commits
    echo "\nPopping stash"
    git stash pop
}

# Kubernetes aliases
alias k='kubectl'

# docker aliases
alias drmc='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias drmi='docker rmi $(docker images -a --filter=dangling=true -q)'
alias drmv='docker volume ls -qf dangling=true | xargs -r docker volume rm'
alias dc='docker-compose'
function katt {
    dc kill $1
    dc rm -f $1
    dc up --force-recreate -d $1
}

# Web development
alias wpb='./node_modules/.bin/webpack --progress --config webpack.config.js --colors'

# Commonly used repos
alias dotf='cd /home/alex/code/dotfiles'

# Systemctl aliases
alias susy='sudo systemctl'

# Pip stuff
alias pir='pip install -r requirements/development.txt'

alias s='ssh -o stricthostkeychecking=no -o userknownhostsfile=/dev/null'

# Venv stuff
alias de='cd ~; deactivate'
# Create venv in current dir
function mkv {
    local venv_name=$(basename $(pwd))
    if [ -z $VIRTUAL_ENV ]; then
        mkvirtualenv -a . -p python3 $venv_name $1
    else
        echo "Virtualenv $(basename $VIRTUAL_ENV) already active, not making new one"
    fi
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
    if [ -f requirements/development.txt ]; then
        pip install -r requirements/development.txt
    fi
    if [[ `command -v pre-commit` ]]; then
        pre-commit install --allow-missing-config
    fi

}
alias rt='$(cat $VIRTUAL_ENV/$VIRTUALENVWRAPPER_PROJECT_FILENAME)/runtests.sh -1'

# On Buster, fd is installed under fdfind
if [ -x /usr/bin/fdfind ]; then
    alias fd='fdfind'
fi

# Utilities
alias sum='python -c "import sys; print(sum(int(l) for l in sys.stdin))"'
