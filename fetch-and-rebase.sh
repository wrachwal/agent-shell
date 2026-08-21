#!/usr/bin/env bash
set -euo pipefail

branch="$(git branch --show-current)"
if [[ "$branch" != "cursor-create-plan-handler" ]]; then
  echo "Expected branch cursor-create-plan-handler, got: $branch" >&2
  exit 1
fi

git fetch origin

if ! git rev-parse main origin/main >/dev/null 2>&1; then
  echo "main or origin/main not found" >&2
  exit 1
fi

if [[ "$(git rev-parse main)" == "$(git rev-parse origin/main)" ]]; then
  echo "main is already up to date with origin/main"
  exit 0
fi

git fetch origin main:main

git rebase main

package="${1:-agent-shell}"
emacs --batch -l ~/.emacs.d/init.el --eval "
(progn
  (straight--transaction-finalize)
  (straight-rebuild-package \"${package}\"))"

ls -l ~/.emacs.d/straight/build/agent-shell/
