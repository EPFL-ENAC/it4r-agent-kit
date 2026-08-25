@AGENTS.md

# Claude Code notes

The rules live in **`AGENTS.md`** (imported above) so every tool — Claude Code,
OpenCode, Cursor, Codex — shares one source of truth. Don't duplicate rules
here; edit `AGENTS.md`.

Claude-Code-specific:

- This repo is a **plugin marketplace**: `skills/` ships the skills,
  `.claude-plugin/` declares them. Install with
  `/plugin marketplace add EPFL-ENAC/it4r-agent-kit`.
- It is **also** a single skill: `SKILL.md` at the root means the whole repo can
  be dropped into `.claude/skills/<name>/` as a git submodule (see `README.md`).
- There is no build and no tests. The deliverables are markdown and one bash
  script.
