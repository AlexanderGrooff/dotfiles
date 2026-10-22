dotfiles
========

personal configurations for different tools (vim, tmux, etc), scripts.

Agent marketplace configuration:

- `.agents/config.yaml` configures resources for this repository.
- `dot_agents/config.yaml.tmpl` and `dot_agents/lock.yaml` deploy to
  `~/.agents/config.yaml` and `~/.agents/lock.yaml` through chezmoi.
- When the untracked `~/.agents/config.private.yaml` exists (work laptop), the
  config includes it and takes its `harnesses`, and `~/.agents/lock.yaml` is
  left machine-local because it records the private sources.

The config is a template, so `chezmoi re-add` skips it: put shared changes in
`dot_agents/config.yaml.tmpl` and private ones in
`~/.agents/config.private.yaml`. On machines without the private fragment,
capture a changed lock with:

```sh
chezmoi --source "$PWD" re-add ~/.agents/lock.yaml
```
