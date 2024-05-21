#!/bin/bash

remote="$1"
url="$2"
branch="$(git rev-parse --abbrev-ref HEAD)"


# feature is for adding, refactoring or removing a feature
# bugfix is for fixing a bug
# hotfix is for changing code with a temporary solution and/or without following the usual process (usually because of an emergency)
# test is for experimenting outside of an issue/ticket
branch_validation_regex='^\(feat\|bugfix\|hotfix\|test\)\(\/BSA-\d\+\)\?\/[a-zA-Z_-]\{3,\}$' 


# if urbi team repo, force branch name to follow convention
if [[ $url =~ "github.com" && $url =~ "urbi-ae/baladi" ]]; then
    if echo $branch | grep -q "$branch_validation_regex"; then
        exit 0
    fi
    echo "Branch name does not follow the convention"
    echo "Branch name should be in the format: <type>/BSA-<number>/branch-name_here"
    echo "available types: feat, bugfix, hotfix, test"
    echo "branch name should be at least 3 characters long"
    echo
    echo """feature is for adding, refactoring or removing a feature
bugfix is for fixing a bug
hotfix is for changing code with a temporary solution and/or without following the usual process (usually because of an emergency)
test is for experimenting outside of an issue/ticket"""
    exit 1
fi