# 🔗 Traceability & Task Linking

## 📚 Quick Navigation
- [KPIs](../kpi/kpi-overview.md)
- [Workflow](engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)
- [Governance](../governance/sla.md)

---

## 🎯 Objective

Ensure full traceability between **Tasks (User Stories / CRs / Bugs)** and the actual implementation in code (Branches, Commits, PRs).

This enables:

- Tracking who delivered what
- Measuring bug resolution per developer
- Linking features to code changes
- Enabling future automation for KPIs & reporting

---

## 📋 Task Types Covered

All of the following **MUST** be linked:

- User Stories
- Change Requests (CRs)
- Bugs / Defects

---

## 🧩 Linking Requirements Summary

| Artifact | Must Include |
| -------- | ------------ |
| Branch name | Task ID (e.g., `feature/TFS-1234-login`) |
| Commit message | Task ID reference (e.g., `feat(TFS-1234): ...`) |
| PR title | Task ID (e.g., `[TFS-1234] Implement login`) |
| PR description | Task link, type, summary, screenshots (if UI) |
| TFS task | Linked PR(s), branch name, status updates |

> For full formatting rules, see [Git Workflow](git-workflow.md).

---

## 📊 KPI Tracking Enablement

This linking system enables automatic tracking of:

### Developer Metrics

- Number of completed User Stories
- Number of resolved Bugs
- Number of delivered CRs
- Code contribution per task
- PR count per developer

### Bug Tracking

- Bugs resolved per developer
- Bug-to-feature ratio
- Reopened bugs

### Code Traceability

Ability to answer:

- Which code implemented this feature?
- Which developer fixed this bug?
- Which release contains this change?

---

## ⚠️ Enforcement Rules

| Violation | Consequence |
| --------- | ----------- |
| Branch without Task ID | **REJECTED** |
| PR without linking | **REJECTED** |
| Commit without Task ID reference | **WARNING** (repeat → penalty) |

---

## 🤖 Future Automation (Planned)

This structure allows integration with:

- GitHub / GitLab APIs
- TFS / Azure DevOps
- AI Code Review tools

To automatically calculate:

- KPI scores
- Developer performance reports
- Delivery analytics

---

> 🏁 **Golden Rule:** *"If it's not linked, it didn't happen."*
