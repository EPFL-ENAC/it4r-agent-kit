# IT4R agent kit

The **ENAC IT4R** team's engineering rules and reusable skills for AI coding
agents (Claude Code, OpenCode, Cursor, Codex, …).

Two things live here:

- **`AGENTS.md`** — the tool-neutral ruleset: architecture invariants, style
  rules, performance budget, workflow. Distilled from what we found
  load-bearing on our FastAPI + SQLModel + Alembic / Vue + Quasar + TypeScript
  projects.
- **`skills/`** — task skills that aren't tied to one project:
  - `plan-conventions` — how issues, plans, and ADRs are filed and trusted.
  - `review-copilot-comments` — triage bot review on the current branch's PR
    into a verified, prioritized checklist.

No build, no tests, no dependencies. Markdown and one bash script.

## Install

This repo is **private** — you need read access to the `EPFL-ENAC` org, and
your `gh`/git credentials are what the installer uses.

**As a Claude Code plugin (recommended — every skill, every repo, auto-updating):**

From a shell:

```bash
claude plugin marketplace add EPFL-ENAC/it4r-agent-kit
claude plugin install it4r-agent-kit
```

Or the same two commands inside a Claude Code session, as `/plugin marketplace
add …` and `/plugin install …`. Check what landed with `claude plugin details
it4r-agent-kit` — you should see three skills and ~380 always-on tokens.

**As a pinned submodule in one project** (committed, so the whole team gets it
on clone — read by Claude Code and OpenCode):

```bash
git submodule add git@github.com:EPFL-ENAC/it4r-agent-kit.git .claude/skills/it4r-conventions
git submodule update --remote   # later, to pull updates
```

This registers the root `SKILL.md`, which routes to `AGENTS.md`. The bundled
skills under `skills/` are not auto-discovered this way — symlink the ones you
want into `.claude/skills/`, or use the plugin.

**Any tool that reads `AGENTS.md`** (Codex, Gemini CLI, Windsurf, Zed, …) gets
the rules for free once the repo is vendored. Claude Code reads `CLAUDE.md`,
which imports `AGENTS.md`.

## Using it in a project

The consuming repo keeps a **short local rules file** for what is genuinely its
own — commands, branch exceptions, perf numbers, module patterns, anything
situational — and links here for the rest. Don't copy the ruleset: two
rulebooks drift, which is the failure this repo exists to prevent.

## Related

- [`epfl-design-skill`](https://github.com/EPFL-ENAC/epfl-design-skill) — EPFL
  brand and design system as a skill. Use it for any EPFL UI work.
- [`it4r-mcp`](https://github.com/EPFL-ENAC/it4r-mcp) — MCP server for when an
  agent needs to *call* something live. Conventions belong here; tools belong
  there.
- [`agamm/claude-code-owasp`](https://github.com/agamm/claude-code-owasp) — the
  `owasp-security` skill several of our repos vendor. Upstream, MIT; install it
  from there rather than copying, so you get the updates.

## Contributing

Small PRs. A rule earns its place by having cost us something concrete — say
what, in one line, in the PR. If a rule is true for exactly one project, it
belongs in that project's local rules file, not here.
