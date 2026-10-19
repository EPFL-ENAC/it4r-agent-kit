#!/usr/bin/env bash
# PreToolUse guard: refuse to write or stage a credential inside a git repo.
#
# Why this exists, and why it is not only a lefthook step: on 2026-08-30 a live
# dev-database DSN was written into a test script and pushed to a public repo.
# A git hook would not have caught it, because `git commit --no-verify` skips
# lefthook entirely and the model can pass that flag. This runs one level up,
# inside the harness, where the flag has no effect.
#
# Two moments are guarded:
#   Write/Edit  the content is inspected before it reaches disk, which is the
#               actual root cause — no self-check ran between generating file
#               content and staging it.
#   Bash        `git add` / `git commit` are refused while anything uncommitted
#               still carries a secret.
#
# A path git will never track cannot leak, so gitignored files and anything
# outside a repository are skipped: writing a real secret to `backend/.env` is
# the correct thing to do and must stay frictionless.

set -uo pipefail

# jq is a hard dependency: without it the guard cannot read tool input and
# would be silently blind. Stay fail-open (a guard must not break every tool
# call) but say so on every invocation — a disabled guard must be visible.
if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' '{"systemMessage":"credential-guard: jq is not installed — the credential guard is DISABLED and secrets are not being checked. Install jq (apt/brew) to restore it."}'
  exit 0
fi
INPUT=$(cat)
TOOL=$(jq -r '.tool_name // empty' <<<"$INPUT")

# Every repo question is asked of the *target's* directory, never the shell's:
# a Write into repo B while the session sits in repo A must get B's ignore
# rules and B's visibility, or the guard reports on the wrong repository.
repo_dir() {
  local dir=$1
  while [ -n "$dir" ] && [ ! -d "$dir" ]; do dir=$(dirname "$dir"); done
  printf '%s\n' "${dir:-.}"
}

# The repo's own copy is authoritative where it exists, so the rules a team
# reviews are the rules that run; otherwise fall back to the copy bundled
# next to this script, so the guard is self-contained and works in any repo
# with no manual install step.
resolve_scanner() {
  local repo self_dir
  repo=$(git -C "$1" rev-parse --show-toplevel 2>/dev/null) || return 1
  if [ -f "$repo/scripts/check-secrets.sh" ]; then
    printf '%s\n' "$repo/scripts/check-secrets.sh"
  else
    self_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    printf '%s\n' "$self_dir/check-secrets.sh"
  fi
}

# Only consulted when something already matched, so its cost never lands on a
# clean path.
repo_exposure() {
  local dir=$1 remote visibility
  remote=$(git -C "$dir" remote get-url origin 2>/dev/null) ||
    { echo "a local-only repository"; return; }
  visibility=$(cd "$dir" && gh repo view --json visibility -q .visibility 2>/dev/null)
  case "$visibility" in
    PUBLIC) echo "a PUBLIC repository ($remote) — committing publishes the secret" ;;
    PRIVATE|INTERNAL) echo "a $visibility repository ($remote)" ;;
    *) echo "$remote" ;;
  esac
}

deny() {
  local findings=$1 action=$2 dir=$3 reason
  reason="Blocked: this looks like a live credential.

$findings

Target is $(repo_exposure "$dir").

A force-push does not unpublish a committed secret — GitHub keeps serving the
blob by SHA — so rotation is the only remediation. Read the value from the
environment instead of writing it into a tracked file, e.g.
    : \"\${DEV_URL:?set DEV_URL to the remote DSN (do not commit it)}\"

Do not retry $action with the secret still in place, and do not reach for
--no-verify: this guard runs above git and the flag will not lift it. If the
match is genuinely not a credential, mark that line \`pragma: allowlist secret\`
so the exception is visible in review."
  jq -n --arg r "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $r
    },
    systemMessage: $r
  }'
  exit 0
}

scan_content() {
  local path=$1 content=$2 dir scanner findings
  [ -n "$content" ] || exit 0
  dir=$(repo_dir "$(dirname "$path")")
  scanner=$(resolve_scanner "$dir") || exit 0   # not in a repo: nothing to leak into
  git -C "$dir" check-ignore -q "$path" 2>/dev/null && exit 0  # never committed
  findings=$(printf '%s\n' "$content" | bash "$scanner" --stdin "$path" 2>&1 >/dev/null |
             grep -E ':[0-9]+: ')
  [ -n "$findings" ] && deny "$findings" "this write" "$dir"
  exit 0
}

case "$TOOL" in
  Write)
    scan_content "$(jq -r '.tool_input.file_path // "<new file>"' <<<"$INPUT")" \
                 "$(jq -r '.tool_input.content // empty' <<<"$INPUT")"
    ;;
  Edit)
    scan_content "$(jq -r '.tool_input.file_path // "<file>"' <<<"$INPUT")" \
                 "$(jq -r '.tool_input.new_string // empty' <<<"$INPUT")"
    ;;
  NotebookEdit)
    scan_content "$(jq -r '.tool_input.notebook_path // "<notebook>"' <<<"$INPUT")" \
                 "$(jq -r '.tool_input.new_source // empty' <<<"$INPUT")"
    ;;
  Bash)
    cmd=$(jq -r '.tool_input.command // empty' <<<"$INPUT")
    # Matches `git add`, `git commit`, and the rtk-wrapped and &&-chained forms.
    grep -qE '(^|[;&|(]|[[:space:]])git[[:space:]]+(add|commit)([[:space:]]|$)' <<<"$cmd" || exit 0
    # A `git add` acts on the shell's repo, so here the cwd is the right frame.
    scanner=$(resolve_scanner .) || exit 0
    findings=$(bash "$scanner" --pending 2>&1 >/dev/null | grep -E ':[0-9]+: ')
    [ -n "$findings" ] && deny "$findings" "the commit" "."
    ;;
esac
exit 0
