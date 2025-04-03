#!/bin/bash

function head_branch {
    git remote show $(git upstream-name) | awk '/HEAD branch/ {print $NF}'
}

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)

if [ -f $GIT_ROOT_DIR/.git/HEAD_BRANCH ]; then
  # Get head branch from local file
  HEAD_BRANCH=$(cat $GIT_ROOT_DIR/.git/HEAD_BRANCH)
else
  # Get head branch from git
  HEAD_BRANCH=$(head_branch)
  # Cache to local file
  echo $HEAD_BRANCH > $GIT_ROOT_DIR/.git/HEAD_BRANCH
fi
echo $HEAD_BRANCH
