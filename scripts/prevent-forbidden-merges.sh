#!/bin/bash

# List of forbidden branches
FORBIDDEN_BRANCHES=("dev")

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get the list of parent branches if this is a merge commit
merge_parents=$(git show -s --pretty=%P)

# Exit if this is not a merge commit (only one parent)
if [ $(echo "$merge_parents" | wc -w) -lt 2 ]; then
    exit 0
fi

# Loop over forbidden branches to see if any were merged
for branch in "${FORBIDDEN_BRANCHES[@]}"; do
    if git merge-base --is-ancestor "origin/$branch" HEAD; then
        echo "❌ ERROR: Merging from forbidden branch '$branch' is not allowed."
        echo "Please remove the merge or use cherry-pick instead."
        exit 1
    fi
done

exit 0
