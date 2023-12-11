#!/usr/bin/env bash

if [ -f .git/HEAD_BRANCH ]; then
  # Get head branch from local file
  HEAD_BRANCH=$(cat .git/HEAD_BRANCH)
else
  # Get head branch from git
  HEAD_BRANCH=$(git head-branch)
  # Cache to local file
  echo $HEAD_BRANCH > .git/HEAD_BRANCH
fi
git checkout $HEAD_BRANCH
