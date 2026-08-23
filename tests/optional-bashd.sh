#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
test_home="$(mktemp -d)"
trap 'rm -rf -- "$test_home"' EXIT

render() {
    HOME="$test_home" chezmoi \
        --source "$repo_root" \
        --no-tty \
        execute-template < "$repo_root/$1"
}

assert_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" != *"$needle"* ]]; then
        printf 'expected output to contain: %s\n' "$needle" >&2
        exit 1
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" == *"$needle"* ]]; then
        printf 'expected output not to contain: %s\n' "$needle" >&2
        exit 1
    fi
}

# A personal workstation must be able to render the source without the private
# company-specific bash.d repository.
dispatcher_without_bashd="$(render dot_config/bead-dispatcher/config.yaml.tmpl)"
[[ -z "$dispatcher_without_bashd" ]]

externals_without_bashd="$(render .chezmoiexternal.toml)"
assert_not_contains "$externals_without_bashd" '[".bash.d"]'

ignore_without_bashd="$(render .chezmoiignore)"
assert_contains "$ignore_without_bashd" '.config/bead-dispatcher/config.yaml'

HOME="$test_home" chezmoi \
    --source "$repo_root" \
    --destination "$test_home" \
    --no-tty \
    status >/dev/null

# Existing work machines retain the current external and generated config.
mkdir -p "$test_home/.bash.d"
printf '%s\n' \
    'marker: bashd-present' \
    'source: "{{ .chezmoi.sourceFile }}"' \
    > "$test_home/.bash.d/bead-dispatcher-config.yaml"

dispatcher_with_bashd="$(render dot_config/bead-dispatcher/config.yaml.tmpl)"
assert_contains "$dispatcher_with_bashd" 'marker: bashd-present'
assert_not_contains "$dispatcher_with_bashd" '{{ .chezmoi.sourceFile }}'

externals_with_bashd="$(render .chezmoiexternal.toml)"
assert_contains "$externals_with_bashd" '[".bash.d"]'

ignore_with_bashd="$(render .chezmoiignore)"
assert_not_contains "$ignore_with_bashd" '.config/bead-dispatcher/config.yaml'
