---
name: it4r-conventions
description: Use when writing or reviewing code in an EPFL ENAC IT4R project — FastAPI + SQLModel + Alembic backends, Vue + Quasar + TypeScript frontends. Holds the team's architecture invariants (backend is source of truth, route → service → repo, no silent fallbacks, frontend never checks roles), style rules, performance budget, and plan/PR workflow.
user-invocable: true
---

# ENAC IT4R conventions

Read **`AGENTS.md`** — it is the whole ruleset. Apply it to whatever you are
building or reviewing in this project.

Precedence: the consuming project's own rules file wins over `AGENTS.md`, and
code wins over both.

## The short version

- Backend is the single source of truth — never reimplement a formula client-side.
- `route → service → repo`; the commit happens in the route; no SQL in routes.
- No silent fallbacks — `raise`, don't log-and-continue.
- Frontend gates on permission keys, never on roles.
- No backward-compat paths, no type suppressions, no defensive programming.
- Every bug fix ships with a regression test.

`skills/plan-conventions/` covers how issues, plans, and ADRs are filed.
