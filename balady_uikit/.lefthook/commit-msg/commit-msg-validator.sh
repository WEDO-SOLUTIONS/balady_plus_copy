#!/bin/bash

# first argument is the commit message file

# check if no staged files in mapness folder
# if [[ -z $(git diff --name-only --diff-filter=d --cached -- mapness/) ]]; then
#   exit 0
# fi

commit_msg=$(head -n 1 "$1")
valid_commit_msg="^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-zA-Z0-9 _-]*\))?:[[:space:]].*$"

# check if commit message follows convention
if [[ $commit_msg =~ $valid_commit_msg ]]; then
  exit 0
else
  echo "Commit message must follow convention: <type>(scope?): message"
  echo "allowed types: build chore ci docs feat fix perf refactor revert style test"
  echo "Your commit message: $commit_msg"
  exit 1
fi