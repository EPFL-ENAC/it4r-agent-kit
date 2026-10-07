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
  - `upstream-memory` — promote lessons from an agent's per-repo memory into
    this kit, as a branch and a PR draft.

No build, no tests, no dependencies. Markdown and two bash scripts.

## Install

**As a Claude Code plugin (recommended — every skill, every repo, auto-updating):**

From a shell:

```bash
claude plugin marketplace add EPFL-ENAC/it4r-agent-kit
claude plugin install it4r-agent-kit
```

Or the same two commands inside a Claude Code session, as `/plugin marketplace
add …` and `/plugin install …`. Check what landed with `claude plugin details
it4r-agent-kit` — you should see four skills; their descriptions are the
always-on cost.

**Vendored into one project** — committed, so the whole team gets the rules on
clone with no install step, and a contributor who never touches plugins can't
silently end up without them. This is what
[`co2-calculator`](https://github.com/EPFL-ENAC/co2-calculator) does; copy it:

1. Copy `AGENTS.md` into the project's docs (e.g.
   `docs/src/contributing/it4r-rules.md`) with a header naming the commit it
   came from, and add a `make sync-agent-rules` target that re-pulls it (see
   [below](#keeping-the-copy-in-sync-make-sync-agent-rules)). `git diff` is
   then your drift signal, and nobody has to remember to update a pin.
2. **`CLAUDE.md`** — add `@docs/src/contributing/it4r-rules.md` above the
   project's own rules. The ruleset is then always-on, like any other import.
3. **Copilot / VS Code** — symlink
   `.github/instructions/it4r-agent-kit-rules.md.instructions.md` at the
   vendored file. Instructions files don't follow `@import`, so without this
   Copilot sees only the local rules. Copilot only picks up an
   `.instructions.md` file when it carries `applyTo:` frontmatter — an
   unscoped file is silently ignored. Since `AGENTS.md` stays tool-neutral
   (no Copilot-specific frontmatter baked in here), stamp it on in your local
   `sync-agent-rules` target instead, *before* the vendoring header comment
   (frontmatter has to be the first bytes in the file):
   ```
   ---
   applyTo: "**"
   ---

   <!-- Vendored from ... -->
   ```
4. **The project's own rules file** — keep it, shrink it to what is genuinely
   its own, link here for the rest, and symlink it the same way in step 3 —
   it needs the same `applyTo:` frontmatter to be honored by Copilot too.

Never edit the vendored copy: change `AGENTS.md` here, then re-sync downstream.

### Keeping the copy in sync: `make sync-agent-rules`

The target resolves the kit's current `main` commit once, writes the Copilot
frontmatter and a header naming that commit, then appends `AGENTS.md` fetched
at exactly that commit, so header and body can't disagree. Run it when the kit
changes (a `plugin.json` version bump is the cue), review the `git diff`, and
commit it. Needs an authenticated `gh` and `curl`.

```make
AGENT_RULES := docs/src/contributing/it4r-rules.md

.PHONY: sync-agent-rules
sync-agent-rules: ## Re-vendor the shared ENAC IT4R rules from it4r-agent-kit
	@sha=$$(gh api repos/EPFL-ENAC/it4r-agent-kit/commits/main --jq .sha); \
	{ echo "---"; \
	  echo "applyTo: \"**\""; \
	  echo "---"; \
	  echo; \
	  echo "<!-- Vendored from https://github.com/EPFL-ENAC/it4r-agent-kit @ $$(printf %.7s "$$sha")"; \
	  echo "     Do not edit here — edit AGENTS.md upstream, then run \`make sync-agent-rules\`. -->"; \
	  echo; \
	  curl -fsSL https://raw.githubusercontent.com/EPFL-ENAC/it4r-agent-kit/$$sha/AGENTS.md; \
	} > $(AGENT_RULES)
	@git diff --stat -- $(AGENT_RULES)
```

This is the target co2-calculator runs. Point `AGENT_RULES` at your own path.

*No submodules.* A submodule adds a checkout step that every contributor and
CI job can skip; the vendored file plus a sync target keeps every property that
matters. Vendoring the whole kit under `.claude/skills/<name>/` instead
registers the root `SKILL.md` as an invocable skill (on-invoke rather than
always-on); don't combine that with the plugin or you get two copies of
`it4r-conventions`.

**Rules are vendored; skills are not.** Rules have to apply whether or not
someone opted in, so they belong in the consuming repo. The task skills are
invoked deliberately — the plugin is the right delivery, and a second in-repo
copy is just drift.

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
