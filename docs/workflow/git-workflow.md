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

## 📖 Related Documents

| Document | Purpose |
| -------- | ------- |
| [Traceability](traceability.md) | Full task-to-code linking rules |
| [Engineering Workflow](engineering-workflow.md) | End-to-end development process |
| [Ownership KPIs](../kpi/ownership-kpis.md) | Workflow adherence scoring |
