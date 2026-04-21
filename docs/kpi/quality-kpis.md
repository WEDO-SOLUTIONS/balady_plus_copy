# 🧪 Quality KPIs (30%)

## 📚 Quick Navigation
- [KPIs](kpi-overview.md)
- [Workflow](../workflow/engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)
- [Governance](../governance/sla.md)

---

## Overview

Quality KPIs measure code correctness, architectural adherence, build stability, and automated review scores.

---

## 📌 5. Bug Rate

**Definition:** Number of bugs discovered after delivery.

| Metric | Target |
| ------ | ------ |
| Bugs per task | ≤ 1 bug per task |

---

## 📌 6. PR Quality

**Definition:** Code quality during the review process.

| Metric | Target |
| ------ | ------ |
| Major comments per PR | ≤ 1 |
| Review cycles per PR | ≤ 2 |

---

## 📌 7. Architecture Compliance

**Definition:** Adherence to Clean Architecture & Bloc pattern.

| Metric | Target |
| ------ | ------ |
| Critical violations in PR | 0 |

---

## 📌 8. CI/CD Stability

**Definition:** Code stability in the build pipeline.

| Metric | Target |
| ------ | ------ |
| Failed builds caused by commits | 0 |

---

## 📌 9. AI Code Review Score

**Definition:** Automated quality evaluation using AI tooling.

| Metric | Measured By |
| ------ | ----------- |
| Score range | 0–100 |

### Score Thresholds

| Score | Result |
| ----- | ------ |
| < 70 | ❌ Rejected |
| 70–85 | ⚠️ Improvement required |
| > 85 | ✅ Accepted |
