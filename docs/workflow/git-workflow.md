# 🔀 Git Workflow

## 📚 Quick Navigation
- [KPIs](../kpi/kpi-overview.md)
- [Workflow](engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)
- [Governance](../governance/sla.md)

---

## Overview

This document defines the branching, commit, and pull request standards for the mobile team. Strict adherence is mandatory and enforced via [Traceability Rules](traceability.md).

---

## 🌿 Branch Naming Convention

Every branch **MUST** include the Task ID.

### Format

```
type/TFS-ID-short-description
```

### Types

| Type | Usage |
| ---- | ----- |
| `feature` | New functionality |
| `bugfix` | Bug resolution |
| `hotfix` | Critical production fix |
| `refactor` | Code improvement without behavior change |
| `chore` | Tooling, config, or maintenance |

### Examples

```
feature/TFS-1234-login-flow
bugfix/TFS-5678-crash-on-home
hotfix/TFS-9999-payment-failure
```

> ⚠️ Any branch without a Task ID will be **REJECTED**.

---

## 💬 Commit Message Standard

Every commit **MUST** reference the Task ID using [Conventional Commits](https://www.conventionalcommits.org/).

### Format

```
type(TFS-ID): short description
```

### Allowed Types

| Type | Usage |
| ---- | ----- |
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring |
| `chore` | Maintenance or tooling |

### Examples

```
feat(TFS-1234): implement login API integration
fix(TFS-5678): resolve null pointer crash
refactor(TFS-2222): improve bloc structure
```

> ⚠️ Commits without a Task ID reference will receive a **WARNING**. Repeated violations incur a penalty.

---

## 📝 PR Requirements

Each pull request **MUST** meet the following criteria:

### Title Format

```
[TFS-ID] Short description
```

**Example:** `[TFS-1234] Implement login flow`

### Description Must Include

- **Task link** — TFS URL to the parent task
- **Type** — Feature / Bug / CR
- **Summary** — Brief description of changes
- **Screenshots** — Required for UI changes

### Linking

- Every PR must be linked to **ONE** primary task
- The task in TFS must reference the linked PR and branch

> ⚠️ Any PR without proper linking will be **REJECTED**.

---

## 🧩 Conflicts with `core`

`core` must **never** be merged into a `feat/` or `fix/` branch. When such a branch conflicts with `core`, cut a `resolve/<TASK>/<slug>` branch from `core`, re-apply the work there, and open the PR from it instead.

```bash
just resolve-start BE-307 car-play-fixes   # cut the branch + list the conflicting PRs
just resolve-check                         # verify before opening the PR
```

Full procedure, including the failure mode where a resolve branch merges cleanly while deleting someone else's code: [Resolve Branch Workflow](resolve-branch-workflow.md).

---

## 📖 Related Documents

| Document | Purpose |
| -------- | ------- |
| [Traceability](traceability.md) | Full task-to-code linking rules |
| [Engineering Workflow](engineering-workflow.md) | End-to-end development process |
| [Resolve Branch Workflow](resolve-branch-workflow.md) | Resolving `core` conflicts without merging `core` into a feature branch |
| [Ownership KPIs](../kpi/ownership-kpis.md) | Workflow adherence scoring |
