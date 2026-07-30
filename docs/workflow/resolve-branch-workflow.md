# 🧩 Resolve Branch Workflow

## 📚 Quick Navigation
- [Git Workflow](git-workflow.md)
- [Engineering Workflow](engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)

---

## Overview

`core` moves fast. A `feat/` or `fix/` branch that was cut from `development` days ago will often conflict with `core` by the time its PR is ready.

The rule is:

> **`core` must never be merged into a `feat/` or `fix/` branch.** If such a branch conflicts with `core`, branch off it into a `resolve/` branch, bring `core` in *there*, and open the PR from the `resolve/` branch instead.

The `resolve/` branch is the one place where `core` is allowed to land. The original `feat/`/`fix/` branch is never touched again.

---

## 🏷️ Naming

Keep everything after the first `/` identical to the source branch — only the prefix changes:

```
feat/BE-307/smart-switch-under-tunnel   →   resolve/BE-307/smart-switch-under-tunnel
fix/BALADY-3776/car-play-dark-theme     →   resolve/BALADY-3776/car-play-dark-theme
```

```
resolve/<TASK-ID>/<same-slug-as-source>
```

This makes the pairing obvious in the branch list and in review.

---

## 🔁 Algorithm

### 1. Branch off the conflicting branch

```bash
git checkout feat/<TASK>/<slug>
git checkout -b resolve/<TASK>/<slug>
```

Off the feature branch — **not** off `core`. The work is already here; only the base needs to move.

### 2. Bring `core` in

```bash
git fetch origin
git merge origin/core          # or: git rebase origin/core
```

This is the step that actually resolves the conflict. Hand-editing files without it does nothing: git recomputes every merge from `merge-base(ours, theirs)` and never stores "this was resolved", so while the base sits back on `development` the same conflict reappears on every merge attempt.

**`merge` vs `rebase`**

| | `merge origin/core` | `rebase origin/core` |
| --- | --- | --- |
| History | Merge commit, original commits intact | Linear, commits rewritten |
| Conflicts | Resolved once | Possibly once per commit |
| Pushing | Normal push | Needs `--force-with-lease` |
| Use when | Default; branch already pushed | You want a clean linear PR and the branch is yours alone |

Either satisfies the rule — both put `core` in the `resolve/` branch and leave the source branch alone.

### 3. Resolve the conflicts

Git shows both sides here, which is the point of doing it this way.

The goal is **a working version of your feature on top of current `core`** — not "make the conflict go away". If `core` reworked the code your change depended on, adapt your logic to the new shape. That can mean editing files that were never in conflict: a rename in `a.dart` breaks a caller in `b.dart` with no textual conflict at all.

The `resolve/` branch is therefore allowed to differ from the source branch. Compare intent, not lines.

### 4. Rebuild generated code

Generated artefacts are gitignored and tied to the branch's base, so they desync when `core` lands:

```bash
cd urbi_map/dgis_map_platform_interface && dart run pigeon --input pigeons/messages.dart
cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install   # if a native file was added or moved
```

Stale pigeon shows up as Kotlin failing with `'<method>' overrides nothing`.

### 5. Verify

```bash
just resolve-check
```

Three separate things have to hold, and the diff checks only cover two of them:

| Check | Catches |
| --- | --- |
| **Builds** — `:dgis_map:compileDebugKotlin`, `xcodebuild -scheme dgis_map` | contracts that drifted apart across files |
| No foreign lines deleted vs `core` | someone else's work dropped during resolution |
| Your added lines still present vs the source branch | your own work dropped during resolution |

A clean merge is not evidence of a correct one — only the build is.

### 6. Swap the PRs

```bash
gh pr close <old-pr> --comment "Superseded by #<new> from resolve/<TASK>/<slug>."
gh pr create --base core --head resolve/<TASK>/<slug> --title "..." --body-file <file>
```

Close the original PR; do not merge the source branch anywhere. It is still based on `development` and would reintroduce the conflict.

---

## ⚠️ Two things that bite

**Resolving in favour of one side wholesale.** `git checkout --ours/--theirs` on a conflicted file, or `-X ours`, resolves instantly and discards the other side entirely. Same for copying whole files across branches. Merge hunk by hunk instead.

**`core` moving again.** If `core` advances and touches the same files after you branched, the conflict returns and step 2 has to be repeated against the newer `core`. On BE-307 `core` moved twice within a day.

---

## ✅ Review checklist

| Check | Why |
| ----- | --- |
| Branch named `resolve/<TASK>/<same-slug>` | Pairing with the source branch is obvious |
| Branched off the `feat/`/`fix/` branch, `core` merged in | The rule |
| `core` **not** merged into the source branch | The rule |
| Both native modules build | Only real evidence the resolution is correct |
| No foreign deletions in `git diff core...HEAD` | Nobody else's work was dropped |
| Your own added lines all present | Your work was not dropped |
| Generated code regenerated | Pigeon / Pods desync silently |
| Original PR closed | It would reintroduce the conflict |

---

## ❓ Why there is no `feat → resolve → core` PR chain

A stacked chain sounds appealing — the feature PR carries the work, the resolve PR only the adaptation. It does not exist here: `resolve/` is branched **off** the feature branch, so the feature branch is its ancestor and GitHub reports *no commits between* for a `feat → resolve` PR.

The `resolve/ → core` PR is the only reviewable one. Link the original PR from its description and close it.

---

## 📖 Related Documents

- [Git Workflow](git-workflow.md)
- [Engineering Workflow](engineering-workflow.md)
