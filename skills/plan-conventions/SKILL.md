---
name: plan-conventions
description: Use when starting an issue, writing or updating an implementation plan or ADR, or judging whether a doc in the repo can be trusted. Covers the ENAC IT4R source-of-truth hierarchy, plan file naming and frontmatter (status/issue/last_updated/summary), where plans and review notes live, and when a plan must be backfilled.
---

# Plan and doc conventions

Every issue ends with a plan file. No exceptions — small fixes get a short one,
backfilled at worst. A missing plan is its own failure mode: the next agent has
no way to know what shipped or why.

## Where things live

| Artifact                   | Location                                     |
| -------------------------- | -------------------------------------------- |
| Implementation plans       | `docs/src/implementation-plans/`              |
| Abandoned plans            | `docs/src/implementation-plans/archive/`      |
| ADRs                       | `docs/src/architecture-decision-records/`     |
| Bot-review / code-review notes | `docs/code-review/`                       |

Plans live inside the docs site so they render with everything else. Do not
propose moving them out.

## File shape

Name: `<issue-id>-<kebab-slug>.md`. Frontmatter on every plan and ADR:

```yaml
---
status: draft | accepted | delivered | superseded
issue: 310b # GitHub issue or sub-issue id
last_updated: 2026-05-05
summary: one-line abstract
---
```

- `draft` — speculative; do not cite as a decision. Draft plans do land in the
  repo, so presence in the tree implies nothing.
- `accepted` — agreed approach; implementation may be partial.
- `delivered` — shipped; matches the main-branch code at `last_updated`.
- `superseded` — history only; follow the link to the successor.

Treat any plan older than ~6 months without `delivered` or `superseded` as
suspect and verify against code.

## Rules

- **Read the plan before you code.** Grep the plans directory for the issue
  number or module name. Highest-leverage habit in the repo.
- **No plan for your issue? Write one before touching code.**
- **If the PR diverges from its plan, update the plan in the same PR.** A stale
  plan is worse than none — the next Tier-N PR builds on the delivered shape.
- **Plans are canonical and append-only; review notes are transient.** Keep
  `*-copilot-feedback-*` files out of the plans directory: they capture bot
  feedback on a PR, not the design.
- Dates are absolute (`2026-05-05`), never "last week".

## Source-of-truth hierarchy

Spec → ADRs → plans → code. Lower tiers refine higher tiers, never override
them. Where docs and code disagree, code wins — fix the doc and say so.
