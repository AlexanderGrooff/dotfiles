# This file is managed by chezmoi. Do not edit directly.
# Quiet baseline environment for login, interactive, and non-interactive shells.
# Keep prompts, completions, aliases, and direnv hooks in shell rc files.

if [ -n "${ALEX_SHELL_ENV_LOADED:-}" ]; then
  return
fi
export ALEX_SHELL_ENV_LOADED=1

path_add() {
  [ -d "$1" ] || return
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_add "$HOME/bin"
path_add "$HOME/.local/bin"
path_add "$HOME/scripts"
path_add "$HOME/.cargo/bin"
path_add "$HOME/npm/bin"
path_add "/usr/local/go/bin"
path_add "$HOME/go/bin"
path_add "$HOME/.pub-cache/bin"
path_add "$HOME/.bun/bin"
path_add "$HOME/Library/Python/3.12/bin"
path_add "$HOME/Library/Python/3.13/bin"
path_add "$HOME/Library/Python/3.14/bin"
path_add "/sbin"

# Homebrew keg-only opt bins (add new packages here, one per line)
_brew_prefix=""
[ -d /opt/homebrew/opt ] && _brew_prefix=/opt/homebrew
[ -z "$_brew_prefix" ] && [ -d /usr/local/opt ] && _brew_prefix=/usr/local
if [ -n "$_brew_prefix" ]; then
  for brew_pkg in node@22; do
    path_add "$_brew_prefix/opt/$brew_pkg/bin"
  done
fi
unset _brew_prefix

export PATH

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
elif [ -e "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"
elif [ -e "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
  . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
fi
