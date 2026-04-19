# 🧱 Technical Debt Policy

## 📚 Quick Navigation
- [KPIs](../kpi/kpi-overview.md)
- [Workflow](../workflow/engineering-workflow.md)
- [Standards](definition-of-done.md)
- [Governance](../governance/sla.md)

---

## Overview

Technical debt must be managed intentionally. Uncontrolled debt degrades code quality, increases bug rates, and slows delivery over time.

---

## 📋 Policy Rules

### Temporary Fixes

All temporary or workaround fixes **must**:

1. **Be documented** — clearly describe what was done and why
2. **Have a follow-up task** — create a TFS item to address the debt properly

### Accountability

| Scenario | Consequence |
| -------- | ----------- |
| Temporary fix with documentation + follow-up task | ✅ Accepted |
| Untracked technical debt | ❌ **KPI penalty** |

---

## Best Practices

- Prefer proper solutions over quick fixes whenever timelines allow
- Tag technical debt tasks with a consistent label (e.g., `tech-debt`) for tracking
- Review accumulated debt during sprint retrospectives
- Prioritize debt reduction alongside feature work

---

## 📖 Related Documents

| Document | Purpose |
| -------- | ------- |
| [Definition of Done](definition-of-done.md) | Ensures proper implementation standards |
| [Penalties](../governance/penalties.md) | Consequences for violations |
| [Ownership KPIs](../kpi/ownership-kpis.md) | Proactiveness and responsibility metrics |
