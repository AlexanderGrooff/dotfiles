---
name: bead-delegation
description: Use when you have multiple beads/issues to work on and want to delegate them to parallel subagents. Creates tmux sessions with droid agents that work on beads and report completion.
---

# Bead-Driven Delegation

## Overview

This skill enables a main agent to delegate beads (issues) to parallel subagents, track their progress, and collect results. It builds on the beads issue tracking system to provide structured task delegation.

## When to Use

- You have 2+ open beads that can be worked on independently
- Tasks don't have shared state or sequential dependencies
- You want to parallelize work across multiple droid instances
- You want structured tracking of delegated work

## The Workflow

### 1. List Available Work

```bash
# See all open beads ready for work
bd ready --json

# Or list all open beads
bd list --status open --json
```

### 2. Dispatch Subagents for Beads

For each bead, create a tmux session with a droid agent:

```bash
# Pattern: tmux new-session -d -s <session-name> 'droid exec --auto low --allow-background-processes "<task-prompt>"'

# Example: Dispatch agent for bead gdbms-1x8
tmux new-session -d -s bead-gdbms-1x8 'droid exec --auto low --allow-background-processes "
Work on bead gdbms-1x8: Fix SET clause execution.

Instructions:
1. Run: bd show gdbms-1x8 --json to see full details
2. Use TDD - understand failing tests first, then fix
3. Run tests to verify: go test ./test/tck/... -run TestTCK_Set -v
4. When complete, close the bead: bd close gdbms-1x8 --reason \"<summary of what was fixed>\"
5. Commit and push changes

Do NOT work on other beads. Focus only on this task.
"'
```

### 3. Monitor Progress

```bash
# List all active tmux sessions
tmux ls

# View a specific agent's progress
tmux attach -t bead-gdbms-1x8

# Capture recent output without attaching
tmux capture-pane -t bead-gdbms-1x8 -p -S -50 | tail -20

# Check which beads are still open (not yet completed by subagents)
bd list --status open
```

### 4. Check Completion

```bash
# Check bead status - if closed, subagent completed it
bd show gdbms-1x8 --json | jq '.status'

# View completion log
cat ~/.factory/subagent-completions.log | tail -10

# Check bead work log
cat ~/.factory/bead-work.log | tail -10
```

### 5. Collect Results

After subagents complete:

```bash
# Check git status for uncommitted changes
git status

# View recent commits from subagents
git log --oneline -10

# Run full test suite to verify integration
go test ./... -count=1

# List any beads that are still open
bd list --status open
```

## Task Prompt Template

When dispatching a subagent for a bead, use this template:

```
Work on bead <BEAD-ID>: <BEAD-TITLE>

Context:
<Brief description of what needs to be done>

Instructions:
1. Run: bd show <BEAD-ID> --json to see full bead details
2. <Specific steps for this task>
3. Run tests: <test command>
4. When complete: bd close <BEAD-ID> --reason "<summary>"
5. Commit changes with message including (<BEAD-ID>)

Constraints:
- Focus ONLY on this bead
- Do NOT modify unrelated code
- <Any other constraints>
```

## Batch Dispatch Helper

For dispatching multiple beads at once:

```bash
# Get all open P1 beads and dispatch agents
for bead in $(bd list --status open --json | jq -r '.[] | select(.priority == 1) | .id'); do
    title=$(bd show "$bead" --json | jq -r '.title')
    session_name="bead-${bead}"
    
    echo "Dispatching agent for $bead: $title"
    
    tmux new-session -d -s "$session_name" "droid exec --auto low --allow-background-processes \"
Work on bead ${bead}: ${title}

1. Run: bd show ${bead} --json for full details
2. Use TDD approach
3. Close bead when done: bd close ${bead} --reason '<summary>'
4. Commit with (${bead}) in message
\""
done
```

## Monitoring Dashboard

Quick status check for all dispatched work:

```bash
# Show active tmux sessions and open beads side by side
echo "=== Active Subagent Sessions ===" && tmux ls 2>/dev/null || echo "No sessions"
echo ""
echo "=== Open Beads ===" && bd list --status open
echo ""
echo "=== Recent Completions ===" && tail -5 ~/.factory/subagent-completions.log 2>/dev/null || echo "No completions yet"
```

## Integration with Hooks

The `SubagentStop` hook (`~/.factory/hooks/subagent-completion-notify.sh`) provides:
- macOS desktop notifications when subagents complete
- Logging to `~/.factory/subagent-completions.log`
- Bead status tracking in `~/.factory/bead-work.log`

## Best Practices

1. **One bead per agent** - Don't overload agents with multiple beads
2. **Clear constraints** - Tell agents what NOT to touch
3. **Include test commands** - Agents should verify their work
4. **Require bead closure** - Agents should close beads with summaries
5. **Use commit conventions** - Include bead ID in commit messages for traceability

## Troubleshooting

**Agent didn't close the bead:**
```bash
# Check if work was done
git log --oneline -5
# Manually close if needed
bd close <bead-id> --reason "Completed by subagent - manual close"
```

**Agents conflicted on same files:**
```bash
# Check for conflicts
git status
# Review changes
git diff
# Resolve manually or re-run one agent
```

**Agent session crashed:**
```bash
# Check if session exists
tmux ls
# Re-dispatch if needed
tmux new-session -d -s <session-name> '...'
```
