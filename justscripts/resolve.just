# Helpers for the resolve-branch workflow.
# Full procedure: docs/workflow/resolve-branch-workflow.md
#
# `core` must never be merged into a feat/ or fix/ branch. When one conflicts with
# core, branch off it into resolve/<TASK>/<same-slug>, merge core in there, and open
# the PR from that branch. Resolving the conflicts is a judgement call and stays
# manual — these recipes cover the mechanical parts: cutting the branch with the
# right name, merging core in, and verifying the result before the PR goes up.

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

# Branch off the current feat//fix/ branch into resolve/<task>/<same-slug> and merge core in
resolve-start base="origin/core":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain)" ]; then
        echo "Working tree is dirty — commit or stash first." >&2
        exit 1
    fi
    source_branch=$(git rev-parse --abbrev-ref HEAD)
    case "$source_branch" in
        feat/*|fix/*|bugfix/*|hotfix/*) ;;
        *)
            echo "Run this from the conflicting feat//fix/ branch (currently on '$source_branch')." >&2
            exit 1
            ;;
    esac
    # Everything after the first slash is kept verbatim, only the prefix changes.
    target="resolve/${source_branch#*/}"
    if git show-ref --verify --quiet "refs/heads/$target"; then
        echo "Branch '$target' already exists." >&2
        exit 1
    fi
    git fetch origin --quiet
    git checkout -b "$target"
    echo "Created $target from $source_branch — merging {{base}} in..."
    if git merge {{base}}; then
        echo
        echo "Merged cleanly. Next: just resolve-check"
    else
        echo
        echo "Conflicts to resolve by hand, then 'git commit' and 'just resolve-check'."
        echo "Resolve hunk by hunk — do not take one side wholesale (--ours/--theirs)."
    fi

# Verify a resolve branch before opening the PR
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
        echo "FAIL  branch does not contain {{base}} — merge or rebase it in (step 2)"
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

    # Did the resolution drop somebody else's work? Removals can't be classified
    # automatically, so they are printed for review rather than judged here.
    removed=$(git diff {{base}} | grep '^-' | grep -v '^---' || true)
    if [ -z "$removed" ]; then
        echo "ok    no lines removed from {{base}}"
    else
        echo "CHECK $(printf '%s\n' "$removed" | wc -l | tr -d ' ') line(s) removed from {{base}} —"
        echo "      each must belong to code you are extending, not to someone else's PR:"
        printf '%s\n' "$removed" | sed 's/^/      /'
    fi

    # Did the resolution drop your own work? Compare against the source branch,
    # ignoring anything that is already in core.
    source_branch="${branch/#resolve\//feat/}"
    git show-ref --verify --quiet "refs/remotes/origin/$source_branch" \
        || source_branch="${branch/#resolve\//fix/}"
    if git show-ref --verify --quiet "refs/remotes/origin/$source_branch"; then
        tmp=$(mktemp -d)
        git diff origin/development...origin/"$source_branch" | grep '^+' | grep -v '^+++' \
            | sed 's/^+//;s/[[:space:]]*$//' | sort -u > "$tmp/src"
        git diff {{base}}...HEAD | grep '^+' | grep -v '^+++' \
            | sed 's/^+//;s/[[:space:]]*$//' | sort -u > "$tmp/res"
        git grep -h '' {{base}} | sed 's/[[:space:]]*$//' | sort -u > "$tmp/core"
        lost=$(comm -23 "$tmp/src" "$tmp/res" | grep -v '^$' | comm -23 - "$tmp/core" || true)
        rm -rf "$tmp"
        if [ -z "$lost" ]; then
            echo "ok    every line added by origin/$source_branch is present or already in {{base}}"
        else
            echo "CHECK present in origin/$source_branch but missing here and absent from {{base}} —"
            echo "      reworded lines are fine, dropped logic is not:"
            printf '%s\n' "$lost" | sed 's/^/      /'
        fi
    else
        echo "note  no matching feat//fix/ branch on origin — skipped the lost-work check"
    fi

    echo
    echo "A clean merge is not evidence of a correct one — build both modules before opening the PR."
    echo
    git diff {{base}} --stat | tail -n 20
    exit $status

# Regenerate artefacts that are tied to the branch's base (gitignored, desync silently)
resolve-regen:
    #!/usr/bin/env bash
    set -euo pipefail
    cd urbi_map/dgis_map_platform_interface
    dart run pigeon --input pigeons/messages.dart
    echo "pigeon regenerated — run 'cd ios && pod install' too if a native file was added or moved"
