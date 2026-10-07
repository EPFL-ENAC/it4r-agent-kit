---
name: sync-agent-rules
description: Use when the user wants to install, vendor, update or re-sync the shared ENAC IT4R rules (it4r-agent-kit's AGENTS.md) in the current repo — "sync agent rules", "update the IT4R rules", "vendor the kit" — after a kit release, or when a repo has no IT4R rules file yet. Pins the copy to the kit's current main commit, wires CLAUDE.md and Copilot on first setup, and summarizes what changed upstream.
---

# Sync the IT4R rules into this repo

The rules are vendored: a committed copy of the kit's `AGENTS.md`, so every
contributor and every tool gets them without installing anything. This skill
creates that copy or refreshes it.

## 1. Find the current state

```
grep -rl "Vendored from https://github.com/EPFL-ENAC/it4r-agent-kit" --include='*.md' .
```

Found a copy: refresh it (step 2). None: set it up (step 3).

## 2. Refresh

- If the repo has a `sync-agent-rules` Make target, run `make sync-agent-rules`.
  Otherwise, run the script from this skill's directory
  (`${CLAUDE_PLUGIN_ROOT}/skills/sync-agent-rules/` under a plugin install,
  otherwise the directory this `SKILL.md` was read from):
  ```
  bash "<this skill dir>/sync-agent-rules.sh" <path-of-the-copy>
  ```
  Both write the same file: Copilot frontmatter, a header pinning the kit
  commit, then `AGENTS.md` at that commit.
- Read the `git diff` of the copy and tell the user, in a few bullets, which
  rules were added, changed or removed upstream. Then go to step 4.

## 3. First setup

This follows the README's "Vendored into one project" steps.

1. **Pick the path:** `docs/src/contributing/it4r-rules.md` if the repo has an
   MkDocs `docs/src/`; otherwise ask. Run the script with that path.
2. **`CLAUDE.md`:** add `@<path>` above the project's own rules. Create the
   file if it's missing.
3. **Copilot:** link the copy as
   `.github/instructions/it4r-agent-kit-rules.md.instructions.md` with a
   relative symlink. The copy already carries `applyTo: "**"`.
4. **`Makefile`** (if there is one): add the `sync-agent-rules` target from the
   kit README, with `AGENT_RULES` pointing at the path, so teammates without
   the plugin can refresh too.
5. **The project's own rules file:** tell the user which of its lines the kit
   now covers. Don't delete them yourself.

## 4. Finish

- Never edit the vendored copy by hand. A fix goes upstream; see the
  `sync-memory-upstream` skill.
- Don't commit unless asked. Suggested message:
  `docs: sync IT4R agent rules to <sha>`.
