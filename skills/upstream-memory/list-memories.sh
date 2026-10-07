#!/usr/bin/env bash
# Print the agent memory index (MEMORY.md) of the current repo, or of every
# repo on this machine with --all, so the upstream-memory skill can sort them.
# Usage: list-memories.sh [--all]
set -euo pipefail

root="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"

if [[ "${1:-}" == "--all" ]]; then
  dirs=("$root"/*/memory)
else
  # Claude Code names the folder after the repo's absolute path, with every
  # non-alphanumeric character replaced by "-".
  repo=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  dirs=("$root/${repo//[^a-zA-Z0-9]/-}/memory")
fi

for dir in "${dirs[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "No memory folder at $dir (in a worktree? try --all)" >&2
    continue
  fi
  count=$(find "$dir" -name '*.md' ! -name MEMORY.md | wc -l | tr -d ' ')
  [[ "$count" == 0 ]] && continue
  echo "## ${dir#"$root"/} ($count memories)"
  if [[ -f "$dir/MEMORY.md" ]]; then cat -- "$dir/MEMORY.md"; fi
  echo
done
