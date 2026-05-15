---
name: chezmoi-dotfiles
description: Use when editing dotfiles, managing shell configs, adding new config files, or debugging chezmoi apply/diff issues in this dotfiles repository
---

# Chezmoi Dotfiles Project

## Overview

This dotfiles repo IS the chezmoi source directory (`~/.local/share/chezmoi` symlinks here). Files use chezmoi naming conventions with OS-conditional templates. There is no separate Python tooling — chezmoi handles all file deployment.

## Source Directory Layout

```
dotfiles/                          # = ~/.local/share/chezmoi (symlink)
├── dot_bash_aliases               # → ~/.bash_aliases
├── dot_bashrc                     # → ~/.bashrc (Linux only, ignored on macOS)
├── dot_gitconfig.tmpl             # → ~/.gitconfig (template: Mac gets hx editor, main branch)
├── dot_gitignore_global           # → ~/.gitignore_global
├── dot_profile                    # → ~/.profile (Linux only)
├── dot_python-version             # → ~/.python-version (macOS only)
├── dot_stignore                   # → ~/.stignore
├── dot_taskrc                     # → ~/.taskrc (Linux only)
├── dot_tmux.conf                  # → ~/.tmux.conf
├── dot_vim/                       # → ~/.vim/
├── dot_vimrc                      # → ~/.vimrc
├── dot_zsh_keys                   # → ~/.zsh_keys
├── dot_zshrc.tmpl                 # → ~/.zshrc (template: Mac=starship, Linux=oh-my-zsh)
├── dot_config/                    # → ~/.config/
│   ├── ghostty/                   # macOS only
│   ├── helix/
│   ├── nvim/
│   ├── starship.toml
│   ├── alacritty/                 # Linux only
│   ├── i3/                        # Linux only (and more WM configs)
│   └── ...
├── dot_local/share/fonts/         # → ~/.local/share/fonts/
├── dot_task/                      # → ~/.task/ (Linux only)
├── bin/                           # → ~/bin/
├── scripts/                       # → ~/scripts/
├── .chezmoi.toml.tmpl             # Generates ~/.config/chezmoi/chezmoi.toml
├── .chezmoidata.yaml              # Template variables (name, email)
├── .chezmoiignore                 # OS-conditional exclude patterns
├── flake.nix                      # Nix flake (NOT deployed, used by run_once)
├── home.nix                       # Home Manager config (NOT deployed, used by run_once)
└── run_once_*.sh.tmpl             # Bootstrap scripts
```

## Naming Conventions

| Prefix | Effect |
|--------|--------|
| `dot_` | Adds leading dot to target (e.g. `dot_bashrc` → `.bashrc`) |
| `dot_config/` | Maps to `~/.config/` |
| `dot_local/` | Maps to `~/.local/` |
| `.tmpl` suffix | File is a Go template, rendered before deployment |

Files WITHOUT `dot_` prefix map directly: `bin/` → `~/bin/`, `scripts/` → `~/scripts/`.

## OS-Conditional Logic

Templates use `.chezmoi.os` (values: `darwin`, `linux`):

```go
{{- if eq .chezmoi.os "darwin" }}
  # macOS-only content
{{- else }}
  # Linux-only content
{{- end }}
```

`.chezmoiignore` also supports templates — Linux-only files (i3, polybar, waybar, .bashrc, .profile, .taskrc) are excluded on macOS, and macOS-only files (.python-version, .config/ghostty) are excluded on Linux.

## Hosts

| Host | OS | Desktop | Shell |
|------|----|---------|-------|
| alex (this Mac) | darwin | N/A | zsh + starship |
| mu | linux | true (KDE/Wayland) | zsh + oh-my-zsh |
| alpha | linux | true | zsh + oh-my-zsh |
| alpha-windows | linux | false | zsh + oh-my-zsh |

## Template Variables

Defined in `.chezmoidata.yaml`, accessible as top-level template keys:

```yaml
email: alexandergrooff@gmail.com
name: Alexander Grooff
```

Usage: `{{ .name }}`, `{{ .email }}` (NOT `.chezmoi.data.name`).

## Common Workflows

### Edit a dotfile
```bash
chezmoi edit dot_zshrc.tmpl    # Opens in $EDITOR, from source dir
```

### Add a new dotfile
```bash
chezmoi add ~/.newconfig       # Adds to source dir with proper naming
```

### Check what would change
```bash
chezmoi diff                    # Shows diff of target vs source state
chezmoi apply --dry-run         # Full dry-run including scripts
```

### Apply changes
```bash
chezmoi apply                   # Deploys all changes to home dir
chezmoi apply --force           # Overwrites existing files without prompting
```

### After editing source files directly
```bash
chezmoi re-add                  # Syncs any modified targets back to source
```

### List managed files
```bash
chezmoi managed                 # All targets chezmoi manages
chezmoi ignored                 # Files excluded by .chezmoiignore
```

### Verify state matches
```bash
chezmoi verify                  # Exits 0 if target matches source
```

## Bootstrap Scripts

| Script | When | Purpose |
|--------|------|---------|
| `run_once_install-nix.sh.tmpl` | First apply on Linux | Installs Nix with Determinate Systems installer |
| `run_once_apply-home-manager.sh.tmpl` | First apply on Linux | Runs `home-manager switch` with flake |
| `run_once_setup-nvim.sh` | First apply | Installs vim-plug + PlugInstall |

Scripts run once per content hash — they re-run only if their content changes. They are guarded by `{{- if eq .chezmoi.os "linux" }}` so Linux-only commands skip on macOS.

## Nix / Home Manager

`flake.nix` and `home.nix` are in the repo but NOT deployed to `~/.` (listed in `.chezmoiignore`). They are invoked by the `run_once_apply-home-manager.sh.tmpl` script which references `{{ .chezmoi.sourceDir }}` to find them.

## 1Password Integration

Configured in `.chezmoi.toml.tmpl` with `[onepassword]` section. Use in templates:

```go
{{ onepasswordRead "op://Vault/Item/Field" }}
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Editing `~/.zshrc` directly | Use `chezmoi edit` or changes will be overwritten on next apply |
| Using `.chezmoi.data.name` | Use `.name` — chezmoidata fields are top-level |
| Inverting OS conditionals (`ne` vs `eq`) | `if eq .chezmoi.os "linux"` = "on Linux do this"; `ne` = "on NOT-Linux do this" |
| Forgetting `.tmpl` suffix | Files needing template logic MUST end in `.tmpl` |
| Adding file to repo that shouldn't deploy | Add target path to `.chezmoiignore` |
| Modifying `~/.config/chezmoi/chezmoi.toml` directly | Edit `.chezmoi.toml.tmpl` in source dir, then `chezmoi init` to regenerate |

## Quick Reference

```bash
chezmoi edit <file>             # Edit source file
chezmoi add <path>              # Add new file to source
chezmoi diff                    # Preview changes
chezmoi apply                   # Deploy to home dir
chezmoi apply --dry-run         # Preview only
chezmoi verify                  # Check if state matches
chezmoi managed                 # List managed targets
chezmoi re-add                  # Sync modified targets back to source
chezmoi cd                      # Shell into source dir
chezmoi data                    # Show all template data
chezmoi execute-template "..." # Test template rendering
chezmoi init                    # Regenerate config from .chezmoi.toml.tmpl
```
