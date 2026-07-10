#!/usr/bin/env bash
# This file is managed by chezmoi. Do not edit directly.

set -euo pipefail

# Ensure we are inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository" >&2
  exit 1
fi

# Collect paths that currently have staged changes
# Use NUL-delimited output to safely handle special characters in file names
staged_files=()
while IFS= read -r -d '' path; do
  staged_files+=("$path")
done < <(git diff --name-only --cached -z)

if (( ${#staged_files[@]} == 0 )); then
  echo "No staged files found."
  exit 0
fi

# Stage remaining changes (additions, modifications, deletions) for only those paths
# pushd/popd so that we can run this from nested dirs
ROOT_DIR=$(git rev-parse --show-toplevel)
pushd $ROOT_DIR
git add -A -- "${staged_files[@]}"
popd

echo "Staged remaining changes for ${#staged_files[@]} file(s)."
