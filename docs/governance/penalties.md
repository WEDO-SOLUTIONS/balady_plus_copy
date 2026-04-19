# ⚠️ Penalties & Bug Severity

## 📚 Quick Navigation
- [KPIs](../kpi/kpi-overview.md)
- [Workflow](../workflow/engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)
- [Governance](sla.md)

---

## Overview

This document defines the penalty system for violations and the bug severity classification that impacts KPI scoring.

---

## 🚨 Penalty Matrix

| Violation Type | KPI Category Impacted |
| -------------- | --------------------- |
| Architecture violations | Quality |
| Production bugs | Delivery + Quality |
| Workflow violations (branching, commits, linking) | Ownership |
| Poor PR quality | Quality (PR rejected) |
| Untracked technical debt | Ownership |

---

## 🐞 Bug Severity System

| Severity | Impact | KPI Impact |
| -------- | ------ | ---------- |
| **Critical** | Crash / blocking | **-10** |
| **High** | Major feature broken | **-7** |
| **Medium** | Partial issue | **-3** |
| **Low** | Minor / UI | **-1** |

---

## Enforcement

- Penalties are tracked per sprint and aggregated into the final KPI score
- Repeated violations escalate in severity
- See [Traceability](../workflow/traceability.md) for task-linking enforcement rules

---

## 📖 Related Documents

| Document | Purpose |
| -------- | ------- |
| [SLA](sla.md) | Response time requirements |
| [Technical Debt](../standards/technical-debt.md) | Debt tracking policy |
| [Quality KPIs](../kpi/quality-kpis.md) | Quality measurement criteria |
| [Traceability](../workflow/traceability.md) | Linking enforcement rules |
