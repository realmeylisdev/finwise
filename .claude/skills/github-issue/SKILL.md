---
name: github-issue
description: |
  Create well-structured GitHub issues following the Epic > Feature > Task/Bug
  hierarchy. Uses GitHub issue types and relationships to connect related issues.
  Invoke with /github-issue.
author: Claude Code
version: 1.0.0
date: 2026-04-03
user_invocable: true
invocation_hint: /github-issue
arguments: |
  Required: Description of the issue to create
  Example: /github-issue budget calculation rounding error
  Example: /github-issue add recurring transaction feature

  If no argument is provided, ask the user what issue they want to create.
---

# GitHub Issue Creation Skill

## Purpose
Help create well-structured GitHub issues that follow a consistent hierarchy
and conventions.

## Issue Hierarchy

```
Epic (large initiative, multiple features)
  └── Feature (user-facing capability, multiple tasks)
        └── Task (single unit of work)
        └── Bug (defect to fix)
```

### When to Use Each Type

| Type | Title Prefix | Use When |
|------|--------------|----------|
| **Epic** | `epic: ` | Large initiative spanning weeks/months |
| **Feature** | `feat: ` | New user-facing capability |
| **Task** | `task: ` | Single unit of implementation work |
| **Bug** | `fix: ` | Something is broken/not working as expected |

## Issue Templates

### Bug Template

**Title format:** `fix: <description>`

```markdown
## Summary
[One sentence about what's broken]

## Environment
- App version: [e.g., 1.0.0]
- Device: [e.g., iPhone 14 Pro, iOS 17.1]
- Network: [WiFi / Cellular / Offline]

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Actual Result
[What actually happened]

## Expected Result
[What you expected to happen]

## Regression?
[Yes / No / Unknown - Did this work in a previous version?]

## Evidence
[Screenshots, screen recordings, logs, crash reports]
```

### Feature Template

**Title format:** `feat: <description>`

```markdown
## What would you like?
[Describe the feature or improvement]

## How would this be useful for you?
[What problem does this solve or what does it make easier?]

## When would you use this?
[Describe a situation where you'd need this feature]

## Anything else?
[Screenshots, mockups, examples from other apps]
```

### Task Template

**Title format:** `task: <description>`

```markdown
## Description
[Clear description of what needs to be done]

## Context
[Why this task is needed]

## Implementation Notes
[Technical approach, files to modify, considerations]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Testing
[How to verify this task is complete]
```

### Epic Template

**Title format:** `epic: <description>`

```markdown
## Overview
[High-level description of the initiative]

## Goals
- [ ] Goal 1
- [ ] Goal 2

## Features
- [ ] #XXX Feature name
- [ ] #YYY Feature name

## Success Criteria
[How we know this epic is complete]

## Notes
[Additional context, constraints, or considerations]
```

## Workflow

1. **Gather Information**: Ask clarifying questions to understand the issue
2. **Determine Type**: Based on scope, choose Epic/Feature/Task/Bug
3. **Search for Parent**: Search for related Features/Epics and ask user which to link
4. **Draft Issue**: Use the appropriate template
5. **Review with User**: Show the draft before creating
6. **Create Issue**: Use gh CLI

## Creating Issues

```bash
gh issue create \
  --title "fix:|feat:|task:|epic: Description" \
  --body "..."
```

### Search for Parent Issues
Before creating a Task or Bug, search for related Features/Epics:
```bash
gh issue list --search "related keywords" --limit 10
```

## Best Practices

1. **Use correct title prefix**: `fix:`, `feat:`, `task:`, `epic:`
2. **One issue, one concern**: Don't combine multiple bugs or features
3. **Include context**: Explain why, not just what
4. **Be specific**: Include file paths, error messages, steps to reproduce

## Example: Creating a Bug

```bash
gh issue create \
  --title "fix: Budget total doesn't update after deleting a transaction" \
  --body "$(cat <<'EOF'
## Summary
Budget remaining amount shows stale value after a transaction is deleted from the budget category.

## Environment
- App version: Latest
- Device: All
- Network: N/A (local database)

## Steps to Reproduce
1. Open a budget category with transactions
2. Delete a transaction
3. Go back to budget overview
4. Budget remaining amount still includes the deleted transaction

## Actual Result
Budget total is not recalculated after transaction deletion.

## Expected Result
Budget remaining should immediately reflect the deleted transaction.

## Regression?
Unknown
EOF
)"
```
