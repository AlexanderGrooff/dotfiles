#!/usr/bin/env bash
# SubagentStop hook - notifies when a subagent completes work
# Reads input JSON from stdin with subagent completion data

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract relevant fields using jq
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TASK=$(echo "$INPUT" | jq -r '.task // "unknown task"')
STATUS=$(echo "$INPUT" | jq -r '.status // "completed"')
DURATION=$(echo "$INPUT" | jq -r '.duration_seconds // 0')

# Log the completion
LOG_FILE="${HOME}/.factory/subagent-completions.log"
mkdir -p "$(dirname "$LOG_FILE")"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session: ${SESSION_ID} | Status: ${STATUS} | Duration: ${DURATION}s | Task: ${TASK}" >> "$LOG_FILE"

# macOS notification (if available)
if command -v osascript &> /dev/null; then
    osascript -e "display notification \"${TASK:0:100}\" with title \"Subagent ${STATUS^}\" subtitle \"Duration: ${DURATION}s\""
fi

# Also check if this subagent was working on a bead and update it
# Look for bead ID pattern in task description (e.g., gdbms-1x8, bd-abc)
BEAD_ID=$(echo "$TASK" | grep -oE '\b[a-zA-Z]+-[a-zA-Z0-9]+\b' | head -1 || true)

if [[ -n "$BEAD_ID" ]] && command -v bd &> /dev/null; then
    # Check if bead exists and is still open
    BEAD_STATUS=$(bd show "$BEAD_ID" --json 2>/dev/null | jq -r '.status // "unknown"' || echo "unknown")
    
    if [[ "$BEAD_STATUS" == "open" || "$BEAD_STATUS" == "in_progress" ]]; then
        # Add a note to the bead about subagent completion
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        # Note: bd doesn't have --notes append, so we just log this
        echo "[${TIMESTAMP}] Subagent completed work on ${BEAD_ID}, status: ${STATUS}" >> "${HOME}/.factory/bead-work.log"
    fi
fi

# Output success (hooks should return valid JSON)
echo '{"status": "notified"}'
exit 0
