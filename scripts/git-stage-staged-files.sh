#!/usr/bin/env bash

set -euo pipefail

# Ensure we are inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository" >&2
  exit 1
fi

# Collect paths that currently have staged changes
# Use NUL-delimited output to safely handle special characters in file names
mapfile -d '' staged_files < <(git diff --name-only --cached -z)

# Filter out potential empty element when input ends with a trailing NUL
filtered_paths=()
for path in "${staged_files[@]:-}"; do
  if [[ -n "${path:-}" ]]; then
    filtered_paths+=("$path")
  fi
done

if (( ${#filtered_paths[@]} == 0 )); then
  echo "No staged files found."
  exit 0
fi

# Stage remaining changes (additions, modifications, deletions) for only those paths
git add -A -- "${filtered_paths[@]}"

echo "Staged remaining changes for ${#filtered_paths[@]} file(s)."
