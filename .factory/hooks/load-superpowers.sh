#!/usr/bin/env bash
# SessionStart hook for Factory Droid skills system

set -euo pipefail

# Determine script/skills root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
SKILLS_ROOT="$(cd "${SCRIPT_DIR}/../skills" && pwd)"

# Read using-superpowers content
using_superpowers_content=$(cat "${SKILLS_ROOT}/using-superpowers/SKILL.md" 2>&1 || echo "Error reading using-superpowers skill")

# Escape outputs for JSON using pure bash
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\' ;;
            '"') output+='\"' ;;
            $'\n') output+='\n' ;;
            $'\r') output+='\r' ;;
            $'\t') output+='\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}

using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have skills available.\n\n**Below is the full content of your 'using-superpowers' skill - your introduction to using skills. Skills are located in ~/.factory/skills/:**\n\n${using_superpowers_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

echo "Loaded hook $(date)" >> /tmp/load-superpowers.log;

exit 0
