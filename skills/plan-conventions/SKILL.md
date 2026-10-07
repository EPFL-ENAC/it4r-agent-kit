---
name: plan-conventions
description: Use when opening or writing a GitHub issue, starting work on an issue, writing or updating an implementation plan or ADR, or judging whether a doc in the repo can be trusted. Covers the ENAC IT4R issue title and TL;DR convention, the source-of-truth hierarchy, plan file naming and frontmatter (status/issue/last_updated/summary), where plans and review notes live, and when a plan must be backfilled.
---

# Plan and doc conventions

Every issue ends with a plan file. No exceptions — small fixes get a short one,
backfilled at worst. A missing plan is its own failure mode: the next agent has
no way to know what shipped or why.

## Where things live

| Artifact                   | Location                                     |
| -------------------------- | -------------------------------------------- |
| Implementation plans       | `docs/src/implementation-plans/`              |
| Closed plans (rejected, withdrawn, superseded) | `docs/src/implementation-plans/archive/` |
| ADRs                       | `docs/src/architecture-decision-records/`     |
| Bot-review / code-review notes | `docs/code-review/`                       |

Plans live inside the docs site so they render with everything else. Do not
propose moving them out.

## File shape

Name: `<issue-id>-<kebab-slug>.md`. Frontmatter on every plan:

```yaml
---
status: draft | accepted | in-progress | delivered | deferred | rejected | withdrawn | superseded
issue: 310b # GitHub issue or sub-issue id
last_updated: 2026-05-05
summary: one-line abstract
supersedes: 2101-old-approach.md    # optional: plans this one replaces
superseded_by: 2950-new-approach.md # required when status is superseded
---
```

The lifecycle follows Python PEPs and Kubernetes KEPs.

- **Open**
  - `draft` — being written, not agreed. Don't cite it as a decision: presence
    in the tree implies nothing.
  - `accepted` — agreed approach; work not started.
  - `in-progress` — being implemented; partly shipped.
  - `deferred` — agreed but parked. Say why, and what would resume it.
- **Done:** `delivered` — shipped; matches the main-branch code at
  `last_updated`.
- **Closed** (move to `archive/`)
  - `rejected` — we decided not to do it. Record why.
  - `withdrawn` — dropped before a decision, or no longer needed.
  - `superseded` — replaced by another plan, named in `superseded_by:`.

Links go both ways, like the RFC `Obsoletes` / `Obsoleted by` headers: a plan
marked `superseded` names its successor, and the successor lists it in
`supersedes:`. Docs generators must know all eight statuses; an unknown value
breaks the index.

ADRs use `Proposed` / `Accepted` / `Deprecated` / `Superseded`, with the same
two links.

Treat any plan still `draft`, `accepted` or `in-progress` after ~6 months as
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

## Issues

Issues are read by product owners, not just developers: lead with intent.

- **Title:** `[PREFIX](Scope) Short plain description`. Prefix is `[BUG]`,
  `[FEAT]`, `[PERF]`, `[SPECS]` (a decision or spec is needed before code) or
  `[TASK]` (standalone chore: refactor, CI, cleanup). Scope is the module or
  tool (`Results`, `CI`, `Deployment`). Don't append `(#N)` by hand; a
  workflow does it where one exists.
- **Body opens with a TL;DR**, then `---`:
  ```
  **TL;DR**
  - **What:** …
  - **Why:** …
  - **User impact:** …
  - **Effort:** small | medium   (or **Blocked by:** #N / **Decision needed:** …)
  ```
- **Then, in order:** what users experience → why it matters → what we propose
  (refactor first, then behaviour) → decisions needed → done when (checklist) →
  technical notes. File paths and symbols go last.
- **Labels** must already exist (`gh issue create` fails on a missing one); the
  type label sets the branch prefix (`bug` → `fix/`, `refactor` → `refactor/`).

## Source-of-truth hierarchy

Spec → ADRs → plans → code. Lower tiers refine higher tiers, never override
them. Where docs and code disagree, code wins — fix the doc and say so.
