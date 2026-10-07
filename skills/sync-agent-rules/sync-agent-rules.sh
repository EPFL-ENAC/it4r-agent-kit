#!/usr/bin/env bash
# Vendor the kit's AGENTS.md into the current repo, pinned to the kit's current
# main commit, with the frontmatter Copilot needs to honour the file.
# Writes the same bytes as the `make sync-agent-rules` target in the kit README.
# Usage: sync-agent-rules.sh [path]   (default: docs/src/contributing/it4r-rules.md)
set -euo pipefail

kit=https://github.com/EPFL-ENAC/it4r-agent-kit
out="${1:-docs/src/contributing/it4r-rules.md}"

# Resolve main once and fetch at that commit, so header and body can't disagree.
sha=$(git ls-remote "$kit.git" refs/heads/main | cut -f1)
if [[ -z "$sha" ]]; then
  echo "Could not resolve $kit main" >&2
  exit 1
fi
body=$(curl -fsSL "https://raw.githubusercontent.com/EPFL-ENAC/it4r-agent-kit/$sha/AGENTS.md")

mkdir -p "$(dirname "$out")"
{
  echo "---"
  echo 'applyTo: "**"'
  echo "---"
  echo
  echo "<!-- Vendored from $kit @ ${sha:0:7}"
  echo "     Do not edit here — edit AGENTS.md upstream, then run \`make sync-agent-rules\`. -->"
  echo
  printf '%s\n' "$body"
} > "$out"

git diff --stat -- "$out" 2>/dev/null || true
echo "VENDORED=$out@${sha:0:7}"
