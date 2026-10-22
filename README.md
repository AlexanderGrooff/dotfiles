dotfiles
========

personal configurations for different tools (vim, tmux, etc), scripts.

Agent marketplace configuration:

- `.agents/config.yaml` configures resources for this repository.
- `dot_agents/config.yaml` and `dot_agents/lock.yaml` deploy to
  `~/.agents/config.yaml` and `~/.agents/lock.yaml` through chezmoi.

After changing the user configuration or lock with agent-marketplace, run this
from the repository to capture the changes:

```sh
chezmoi --source "$PWD" re-add ~/.agents/config.yaml ~/.agents/lock.yaml
```
