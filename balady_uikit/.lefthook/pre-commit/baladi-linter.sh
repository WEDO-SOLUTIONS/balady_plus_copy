#!/bin/env bash

set -euo pipefail

files=$(git diff --cached --name-only |  grep '.*\.dart' || true)

# Filter out files that do not exist on disk

existing_files=""
for file in $files; do
    if [ -f "$file" ]; then
        existing_files="$existing_files $file"
    fi
done

if [ -z "$existing_files" ]; then
    exit 0
fi

fvm flutter analyze $existing_files
# riverpod specific 
# fvm flutter pub run custom_lint $existing_files
