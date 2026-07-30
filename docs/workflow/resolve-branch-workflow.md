# 🧩 Resolve Branch Workflow

## 📚 Quick Navigation
- [Git Workflow](git-workflow.md)
- [Engineering Workflow](engineering-workflow.md)
- [Standards](../standards/definition-of-done.md)

---

## Overview

`core` moves fast. A `feat/` or `fix/` branch that was cut from `development` days ago will often conflict with `core` by the time its PR is ready.

The rule is:

> **`core` must never be merged into a `feat/` or `fix/` branch.** If such a branch conflicts with `core`, create a `resolve/` branch and merge *that* into `core`.

This document explains how to do that correctly, and — just as importantly — the failure mode that makes a resolve branch look green while silently deleting somebody else's work.

---

## 🧠 The one thing to understand first

A merge is **not** a function of branch contents. It is a function of three points:

```
merge(base, ours, theirs)     where base = merge-base(ours, theirs)
```

Git never stores "this conflict was resolved". Every merge recomputes the result from the base. So:

- **Hand-fixing files on a branch that does not contain `core` does nothing.** The base stays back on `development`, git recomputes, the same conflict reappears.
- **Branching from `core` moves the base forward.** Your change then looks one-sided, and git applies it without asking.

That second point is the trap: git stops asking *precisely* when you take responsibility for merging others' work by hand.

### Proof

Two branches with byte-identical file contents, differing only in where they were cut from:

```bash
# development: line is "SHARED"; core changed it to "SHARED-core";
# feat (from development) changed it to "SHARED-feat".
# Both resolve branches below contain the identical resolved line.

git merge-tree --write-tree core resolve-from-development   # exit 1  → CONFLICT
git merge-tree --write-tree core resolve-from-core          # exit 0  → clean
```

---

## ⚠️ The silent-overwrite trap

Because a `core`-based branch makes your change one-sided, this merges **cleanly**:

```bash
git checkout -b resolve/BE-307/foo origin/core
git checkout my-feat-branch -- path/to/File.swift   # ← copying whole files
```

…and it **deletes every change `core` made to that file**. No conflict, no warning, PR shows a green *Mergeable*.

> 🚫 **Never copy whole files from the feature branch into a `core`-based resolve branch.**
> ✅ **Re-apply your edits on top of the `core` version of each file.**

Copying a whole file is only safe for files `core` has not touched since your last iteration — verify per file, do not assume:

```bash
git diff --quiet <core-sha-you-last-worked-on> origin/core -- <file> && echo SAFE || echo "RE-APPLY BY HAND"
```

---

## 🔁 Algorithm

### 0. Prerequisites

Your `feat/`/`fix/` branch is pushed and its PR conflicts with `core`. Do not touch that branch from here on.

### 1. Cut the resolve branch from the newest `core`

```bash
git fetch origin
git checkout -b resolve/<TASK>/<slug> origin/core
```

`core` can move within a day — always re-fetch.

### 2. Find out what in `core` caused the conflict

For every conflicting file:

```bash
git log --oneline origin/development..origin/core -- <file>
```

Note the PRs. They go in the resolve PR description so the reviewer sees what you re-applied on top of.

### 3. Classify each file

```bash
git diff --quiet <old-core-sha> origin/core -- <file>
```

- **unchanged in `core`** → the version from your previous iteration can be reused as-is;
- **changed in `core`** → re-apply your edits by hand onto the `core` version.

### 4. Re-apply the work

New files can be taken directly. Modified files get your edits applied on top of `core`'s content — never the other way round.

### 5. Verify (all four must pass)

```bash
git diff origin/core --stat     # same shape as the feature branch's own diff
git diff origin/core --check    # empty — no whitespace churn
git diff origin/core | grep '^-' | grep -v '^---'   # no foreign lines deleted
git merge-tree --write-tree origin/core HEAD ; echo $?   # 0
```

The third command is the one that catches the silent-overwrite trap. Every deleted line must belong to code *you* are extending. A quick sanity check on landmark symbols from the conflicting PRs also helps:

```bash
git grep -c <symbol> origin/core -- <dir>
git grep -c <symbol> HEAD -- <dir>      # counts must match
```

### 6. Rebuild generated code

Generated artefacts are gitignored and are tied to the branch's base. Switching between a `development` base and a `core` base **will** desync them:

```bash
cd urbi_map/dgis_map_platform_interface && dart run pigeon --input pigeons/messages.dart
cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install    # only if a native file was added/moved
```

Symptom of a stale pigeon: Kotlin fails with `'<method>' overrides nothing`.

### 7. Compile before opening the PR

```bash
cd android && ./gradlew :dgis_map:compileDebugKotlin
xcodebuild -workspace ios/Runner.xcworkspace -scheme dgis_map -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build
```

### 8. Swap the PRs

```bash
gh pr close <old-pr> --comment "Superseded by #<new> from resolve/<TASK>/<slug>."
gh pr create --base core --head resolve/<TASK>/<slug> --title "..." --body-file <file>
```

---

## ✅ Review checklist

| Check | Why |
| ----- | --- |
| Resolve branch cut from `origin/core` | Otherwise the resolution is recomputed away |
| `core` **not** merged into the `feat/`/`fix/` branch | Team rule |
| Diff vs `core` contains no foreign deletions | Green *Mergeable* does not prove correctness |
| Diff shape matches the feature branch | Catches work lost while re-applying |
| Conflicting PRs listed in the description | Reviewer sees what it was re-applied over |
| Generated code regenerated for the new base | Pigeon / Pods desync silently |

---

## ❓ Why there is no `feat → resolve → core` PR chain

A stacked chain sounds appealing — the reviewer reads the work in the `feat/` PR, and the resolve PR only carries the adaptation. It cannot be built under this rule:

- For `resolve/` to merge into `core`, it must contain the **whole** feature.
- If `resolve/` contains the whole feature and was branched off `feat/`, then `feat/` is an ancestor of `resolve/` — GitHub reports *no commits between* and refuses the PR.
- If instead `resolve/` is cut from `core` (as required), then `feat/` and `resolve/` share only an old `development` ancestor. A `feat → resolve` PR is then two divergent copies of the same work: it conflicts, and its diff shows unrelated `core` code as if it were new.
- Making `feat/` a descendant of `resolve/` would pull `core` into `feat/` — exactly what the rule forbids.

**Conclusion:** the `resolve/ → core` PR is the only reviewable one. Reference the original PR from its description and close the original.

---

## 📖 Related Documents

- [Git Workflow](git-workflow.md)
- [Engineering Workflow](engineering-workflow.md)
