# 🛠️ Engineering Workflow

## 📚 Quick Navigation
- [KPIs](../kpi/kpi-overview.md)
- [Workflow](engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)
- [Governance](../governance/sla.md)

---

## Overview

This document defines the standard engineering workflow from task initiation through delivery. All team members must follow these processes to ensure consistency and traceability.

---

## 1. Task Initiation

Before starting any work:

- **Understand requirements fully** — read the PRD and acceptance criteria
- **Ask questions early** — clarify ambiguities before writing code
- **Break down tasks** — decompose large tasks into smaller, deliverable units

---

## 2. Task Management (TFS)

During active development:

- **Update task status daily** — keep the board accurate and current
- **Link PR to task ID** — every pull request must reference its parent task

---

## 3. Development Process

1. Create a branch following [Git Workflow](git-workflow.md) conventions
2. Implement the feature/fix following Clean Architecture & Bloc pattern
3. Self-review code before creating a PR
4. Create a PR following [PR requirements](git-workflow.md#pr-requirements)
5. Address review feedback promptly
6. Ensure all [Definition of Done](../standards/definition-of-done.md) criteria are met

---

## 🤖 AI Code Review

All PRs must be evaluated using AI-assisted review.

### Evaluation Criteria

- Architecture compliance
- Code quality
- Maintainability
- Performance risks

> See [Quality KPIs — AI Code Review Score](../kpi/quality-kpis.md#-9-ai-code-review-score) for scoring thresholds.

---

## 📖 Related Documents

| Document | Purpose |
| -------- | ------- |
| [Git Workflow](git-workflow.md) | Branching, commits, and PR standards |
| [Traceability](traceability.md) | Task-to-code linking requirements |
| [Definition of Done](../standards/definition-of-done.md) | Task completion criteria |
| [Definition of Ready](../standards/definition-of-ready.md) | Task readiness criteria |
