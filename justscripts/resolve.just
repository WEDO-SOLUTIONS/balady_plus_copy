# Helpers for the resolve-branch workflow.
# Full procedure: docs/workflow/resolve-branch-workflow.md
#
# `core` must never be merged into a feat/ or fix/ branch. When one conflicts with
# core, a resolve/ branch is cut from core, the work is re-applied there, and the PR
# is opened from it. Re-applying the work is a judgement call and stays manual —
# these recipes cover the mechanical parts around it: cutting the branch, finding
# what conflicts and why, and verifying the result before the PR goes up.

# List the files on the current branch that conflict with core, and the commits behind them
resolve-conflicts base="origin/core":
    #!/usr/bin/env bash
    set -euo pipefail
    git fetch origin --quiet
    files=$(git merge-tree --write-tree {{base}} HEAD 2>&1 | sed -n 's/^CONFLICT ([^)]*): Merge conflict in //p' || true)
    if [ -z "$files" ]; then
        echo "No conflicts with {{base}}."
        exit 0
    fi
    echo "Conflicts with {{base}}:"
    echo
    while IFS= read -r f; do
        echo "  $f"
        git log --oneline origin/development..{{base}} -- "$f" | sed 's/^/      /'
        echo
    done <<< "$files"
    echo "Re-apply your edits on top of the {{base}} version of these files — never copy whole files over."

# Cut resolve/<task>/<slug> from the newest core, after reporting what conflicts
resolve-start task slug base="origin/core":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain)" ]; then
        echo "Working tree is dirty — commit or stash first." >&2
        exit 1
    fi
    source_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Source branch: $source_branch"
    just resolve-conflicts {{base}} || true
    echo "----"
    git fetch origin --quiet
    git checkout -b "resolve/{{task}}/{{slug}}" {{base}}
    echo
    echo "On resolve/{{task}}/{{slug}} (cut from {{base}})."
    echo "Re-apply the work from $source_branch, then run: just resolve-check"

# Verify a resolve branch before opening the PR. Fails on anything that would land broken.
resolve-check base="origin/core":
    #!/usr/bin/env bash
    set -euo pipefail
    git fetch origin --quiet
    branch=$(git rev-parse --abbrev-ref HEAD)
    case "$branch" in
        resolve/*) ;;
        *) echo "WARNING: '$branch' is not a resolve/ branch." ;;
    esac
    status=0

    if git merge-base --is-ancestor {{base}} HEAD; then
        echo "ok    branch contains {{base}}"
    else
        echo "FAIL  branch does not contain {{base}} — the resolution will be recomputed away on merge"
        echo "      cut the branch from {{base}} instead"
        status=1
    fi

    if git merge-tree --write-tree {{base}} HEAD >/dev/null 2>&1; then
        echo "ok    merges into {{base}} without conflicts"
    else
        echo "FAIL  still conflicts with {{base}}"
        status=1
    fi

    if [ -z "$(git diff {{base}} --check)" ]; then
        echo "ok    no whitespace churn"
    else
        echo "FAIL  whitespace churn (breaks later merges):"
        git diff {{base}} --check | sed 's/^/      /'
        status=1
    fi

    # The important one: a core-based branch merges cleanly even when it deletes
    # someone else's code, so removals have to be eyeballed rather than trusted.
    removed=$(git diff {{base}} | grep '^-' | grep -v '^---' || true)
    if [ -z "$removed" ]; then
        echo "ok    no lines removed from {{base}}"
    else
        echo "CHECK $(printf '%s\n' "$removed" | wc -l | tr -d ' ') line(s) removed from {{base}} —"
        echo "      every one must belong to code you are extending, not to someone else's PR:"
        printf '%s\n' "$removed" | sed 's/^/      /'
    fi

    echo
    echo "Diff vs {{base}} (should match the shape of the original branch's diff):"
    git diff {{base}} --stat | tail -n 20
    exit $status

# Regenerate artefacts that are tied to the branch's base (gitignored, desync silently)
resolve-regen:
    #!/usr/bin/env bash
    set -euo pipefail
    cd urbi_map/dgis_map_platform_interface
    dart run pigeon --input pigeons/messages.dart
    echo "pigeon regenerated — run 'cd ios && pod install' too if a native file was added or moved"
