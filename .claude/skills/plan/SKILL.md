---
name: plan
description: |
  Investigate a GitHub issue and produce a structured implementation plan.
  Fetches issue details, explores the codebase, identifies affected layers
  (UI, BLoC, UseCase, Repository, DataSource), and outputs a step-by-step
  plan with files to modify, testing strategy, and risk assessment. Works
  for bugs, features, and tasks. Invoke with /plan.
author: Claude Code
version: 1.0.0
date: 2026-04-03
user_invocable: true
invocation_hint: /plan
arguments: |
  Required: GitHub issue number or URL, or a description of the task
  Example: /plan 42
  Example: /plan #42
  Example: /plan https://github.com/user/finwise/issues/42
  Example: /plan add recurring transaction support

  If no argument is provided, ask the user which issue to investigate.
---

# Issue Investigation & Planning Skill

## Purpose

Investigate a GitHub issue thoroughly and produce a structured, actionable
implementation plan. The plan follows the project's clean architecture
(UI -> BLoC -> UseCase -> Repository -> DataSource) and includes files to
modify, implementation steps, testing strategy, and risk assessment.

## Workflow

### Phase 1: Fetch Issue

If a GitHub issue number or URL is provided, retrieve the full context:

```bash
# Get issue details
gh issue view <number> --json title,body,comments,labels,state,assignees
```

Determine the issue type from:
- Title prefix: `fix:` = Bug, `feat:` = Feature, `task:` = Task
- Labels (e.g., `bug` label)

Extract key information:
- **Bug**: Steps to reproduce, actual vs expected result, environment, evidence
- **Feature**: Requirements, acceptance criteria, user stories
- **Task**: Description, scope, implementation notes

### Phase 2: Explore Codebase

Search the codebase to understand the relevant code. Approach varies by type.

#### For Bugs
1. Search for keywords from the bug description (error messages, screen names, widget names) using `Grep`
2. Identify the screen/page where the bug manifests using `Glob` on `lib/features/`
3. Trace the code path from UI through BLoC to UseCase to Repository to DataSource
4. Check for related tests using `Glob` on `test/`

#### For Features
1. Search for similar existing features using `Grep` and `Glob`
2. Identify which architectural layers are needed (new BLoC? New repository? New entity?)
3. Check if related models/repositories already exist in `lib/features/` or `lib/core/`
4. Look at the router (`lib/core/navigation/`) for navigation integration

#### For Tasks
1. Search for the specific code area mentioned in the task using `Grep`
2. Understand the current implementation state
3. Check for existing tests that need updating
4. Identify related files that might be affected

### Phase 3: Analyze

#### For Bugs
- Identify the root cause by reading the relevant source files
- Determine which layer(s) contain the bug (UI? BLoC? UseCase? Repository? DataSource?)
- Assess regression risk (what else could break?)
- Check if existing tests should have caught this

#### For Features
- Determine which layers need new code vs modifications
- Design the data flow: DataSource -> Repository -> UseCase -> BLoC -> UI
- Identify new entities, use cases, events, states needed
- Consider integration with existing features (router, theme, existing BLoCs)

#### For Tasks
- Scope the change precisely
- Identify all files that need modification
- Determine if the task has cascading effects

### Phase 4: Plan

Construct the implementation plan following the project's clean architecture.
Always order implementation steps bottom-up:

1. Data layer changes (DataSources, database tables/DAOs in `lib/core/database/`)
2. Domain layer changes (Entities, Repository interfaces, UseCases)
3. Data layer implementations (Repository implementations)
4. Business logic changes (BLoCs in `lib/features/{feature}/presentation/bloc/`)
5. Presentation layer changes (Pages/Widgets)
6. Router changes (if navigation is affected)
7. DI registration (in `lib/core/di/`)
8. Test plan (mirroring the implementation layers)

### Phase 5: Output

Present the plan using the output template below.

## Output Template

```markdown
## Plan: [Issue Title] (#[number])

**Type**: Bug | Feature | Task
**Issue**: [URL or description]
**Complexity**: Low | Medium | High

---

### Issue Summary
[1-2 sentence summary in your own words after investigation]

### [Bug Only] Root Cause
- **Layer**: [UI | BLoC | UseCase | Repository | DataSource]
- **File**: [exact file path with line numbers]
- **Cause**: [clear explanation of why this happens]
- **Evidence**: [code snippet or logic trace]

### [Feature Only] Architecture Design
- **Layers affected**: [which of UI, BLoC, UseCase, Repository, DataSource]
- **Data flow**: [DataSource -> Repository -> UseCase -> BLoC -> UI description]
- **New entities**: [list or "None"]

### Affected Files

| File | Action | Description |
|------|--------|-------------|
| `path/to/file.dart` | Modify / Create / Delete | What changes |

### Implementation Steps

Steps ordered bottom-up (data layer first, UI last):

1. **[Layer]: [Brief description]**
   - File: `path/to/file.dart`
   - Changes: [specific changes]
   - Why: [rationale]

2. ...

### Testing Strategy

| Layer | Test File | What to Test |
|-------|-----------|-------------|
| [Layer] | `test/path/to/test.dart` | [specific test cases] |

### Risks and Considerations
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

```

## Tool Reference

| Need | Tool | Example |
|------|------|---------|
| Fetch issue | `gh issue view` | `gh issue view 42 --json title,body,comments,labels` |
| Find files by name | `Glob` | `Glob("**/*transaction*")` |
| Search code content | `Grep` | `Grep("TransactionBloc")` |
| Read file details | `Read` | `Read("lib/features/transaction/presentation/bloc/transaction_bloc.dart")` |

## Complexity Guidelines

| Complexity | Criteria |
|-----------|----------|
| **Low** | Single layer, 1-3 files, no new entities |
| **Medium** | 2-3 layers, 4-10 files, may need new BLoC events/states |
| **High** | All layers, 10+ files, new entities, new database tables, new DI registrations |

## Architecture Reference

- **Layer order**: UI -> BLoC -> UseCase -> Repository -> DataSource
- **Implementation order**: Bottom-up (DataSource first, UI last)
- **Features**: `lib/features/`
- **Core**: `lib/core/` (database, di, navigation, theme, utils, errors, constants)
- **Tests mirror**: `test/` mirrors `lib/`
- **State management**: BLoC/Cubit exclusively
- **DI**: get_it + injectable
- **Error handling**: fpdart Either<Failure, T>
- **Database**: drift
