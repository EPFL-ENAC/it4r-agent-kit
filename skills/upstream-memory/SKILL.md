---
name: upstream-memory
description: Use when the user wants to promote lessons from an AI agent's per-repo memory into it4r-agent-kit — "update the kit from memory", "what did the agents learn that the team should know", "harvest memories" — or after a session that saved several feedback memories. Sorts each memory into team rule, project rule, personal preference or state, drafts AGENTS.md and skill edits on a kit branch with one cost line per rule, and never pushes without the user's go.
---

# Upstream agent memory into the kit

Agents keep per-repo memory (Claude Code: `~/.claude/projects/<repo-path-slug>/memory/`,
indexed by `MEMORY.md`). A lesson that holds for every IT4R repo is wasted
there: only one agent, in one repo, sees it. This skill moves those lessons
into the kit, where every agent and every teammate gets them.

## 1. Collect

- Run `bash ${CLAUDE_PLUGIN_ROOT}/skills/upstream-memory/list-memories.sh` for
  the current repo, or with `--all` for every repo on this machine. Read the
  memory files behind the index lines, not just the index.
- Pull a fresh kit clone (`git pull --ff-only` on `main`) and read `AGENTS.md`
  and `skills/` from it, not from a plugin cache.

## 2. Sort each memory

| Kind                                         | Goes to                                     |
| -------------------------------------------- | ------------------------------------------- |
| Team rule: true for any IT4R repo            | `AGENTS.md` (always-on) or a kit skill      |
| Project rule                                 | That repo's local rules file                |
| Personal preference across repos             | The user's `~/.claude/CLAUDE.md`            |
| State, incidents, handovers, tool quirks     | Stays in memory                             |

A team rule earns its place only if all three hold (README, "Contributing"):

- it is true for any IT4R project;
- it cost something concrete, which you can say in one line;
- it isn't already covered: grep `AGENTS.md` and the skills first.

The same lesson in several repos' memories is the strongest signal.

## 3. Check conflicts against code

When a memory says "the kit says X, but repo Y breaks on it", read Y's code,
then decide which side changes. The kit is the default; often the consumer's
generator or CI should adapt. Never silently switch the kit to one consumer's
vocabulary: list it as a decision for the team.

## 4. Write

- One line per rule, merged into an existing bullet where possible.
  `AGENTS.md` is imported into every session of every consumer, so each line
  costs tokens forever.
- The kit is public: no hostnames, credentials, bucket or database names,
  people's names or handles, quotes, or incident details. State the rule.
- Rules, not history: "Never commit a credential…", not "On 2026-08-30 an
  agent…".
- Every cost line must be supported by the memory text. Don't embellish.
- Bump `.claude-plugin/plugin.json` (minor for new rules) so plugin installs
  pick the change up.

## 5. Propose, don't ship

- Work on a branch. Don't push or open the PR until the user says so.
- PR body: one generic cost line per rule, plus a separate "Decisions for the
  team" section for anything that changes policy or vocabulary.
- After merge, every vendoring repo runs `make sync-agent-rules` (README).
- Offer, don't do: delete the memories the kit now covers, so the two copies
  can't drift.
