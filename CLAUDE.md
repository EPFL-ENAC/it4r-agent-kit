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
  be vendored into `.claude/skills/<name>/` (see `README.md`; no submodules).
- There is no build and no tests. The deliverables are markdown and five bash
  scripts: three under `skills/`, two under `hooks/`.
- `hooks/` registers a **PreToolUse credential guard** with every plugin
  install (`hooks/hooks.json`). `credential-guard.sh` speaks the Claude Code
  hook protocol (JSON on stdin, a `permissionDecision` back on stdout);
  `check-secrets.sh` is the tool-neutral scanner both the guard and
  downstream lefthook configs run. See README "Credential guard".
