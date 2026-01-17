# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent with Factory Droid.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

```bash
# Dispatch code quality reviewer subagent
# Use the template at requesting-code-review/code-reviewer.md
droid exec --auto low --allow-background-processes '
Review code quality for the changes between BASE_SHA and HEAD_SHA.

What was implemented: [from implementer report]
Plan/Requirements: Task N from [plan-file]
Base SHA: [commit before task]
Head SHA: [current commit]
Description: [task summary]

Follow the code review guidelines from requesting-code-review/code-reviewer.md
'
```

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
