---
name: tps
description: Use when orchestrating multi-ticket work with parallel builder agents in git worktrees, in the spirit of the Toyota Production System. Covers station roles and model choice, the shape of a ticket, rules for builders, the merge flow, verification by raw output and a browser check, the status loop, and when to stop and ask the human.
---

# Work system (TPS)

You are the orchestrator. You plan, dispatch, verify, and merge. You do not do station work yourself, except a fix of a few lines that a ticket cannot own.

## Start of a session

Ask me two things in one question, with the defaults shown, so that I can accept them with one answer. Then do not ask again.

1. The target branch: the branch that the finished work goes into. The default is the base branch for pull requests in the project rules (`dev` in an IT4R repo). If the project has no rule, the default is the default branch of the repository.
2. The model for each station. The defaults are in the list below.

## Stations

Use the smallest model that passes the checks.

- PLAN (orchestrator): split the request into tickets.
- SEARCH (default Sonnet): fetch only what a ticket asks for. Return under 600 words with a URL or a file and line for each claim.
- STUDY (default Fable): read code and report. Write nothing.
- BUILD (default Opus at medium effort): receives the ticket only, not the conversation.
- CHECK (orchestrator): run the full check after each merge. For a UI change, look at the result in a browser.

In a tool without these models, map each station to a model tier of that tool: the smallest tier for SEARCH, the strongest tier for STUDY, a middle tier for BUILD.

## A ticket

A ticket has these parts. If one part is missing, do not dispatch the ticket.

1. A goal in one paragraph, with the reason.
2. The files that the ticket owns, and the files that it must not edit.
3. The files to read first.
4. An executable done check. The check must exit with 0 and must show 0 failed tests.
5. A hard time limit of 10 minutes or less. If a ticket needs more, ask me for an exception first.
6. The report format: files changed, commit hash, raw tail of the check, measured numbers, changed tests with the reason, and what needs a browser check (UI changes only).

Size a ticket for one module, one endpoint with its service and repository layer, or one page section.

## Rules for a builder

Write these rules into each ticket.

1. Work only in the worktree that the ticket names.
2. Stage files by name. Never run `git add -A`.
3. Write the check log to a file name of your own. Judge a run by the pass and fail counts, and by the exit code.
4. Never weaken, skip, or rewrite a check to make it pass. If a pinned result changes, stop and report it.
5. If a number in the ticket is an estimate, measure the real value and report it. Do not change the method to reach the number.
6. Commit, but do not push. Add no attribution line to a commit.
7. Put no private path, email address, or secret into a committed file.
8. At the time limit, make the suite green, commit the part that works, and report the part that is missing.

## Flow

1. Parallel work is correct only for tickets that own different files. Tickets that change the same file run one after the other.
2. Create each worktree outside the repository, from the work branch. Remove it after the merge.
3. For a UI change, start one dev server for each ticket on its own port, and give me the address. I look before you merge a visible change.
4. Merge with a cherry-pick onto the work branch. Then run the full check yourself, with your own log file.
5. Jidoka: if a check fails, stop. Start no new ticket on those files until the failure is resolved.
6. Fix at the source. A failure goes back to the builder with the raw error. If the second try fails, plan the work again as smaller tickets.
7. Just-in-time context: a ticket holds only what its builder needs.
8. Muda: build nothing that I did not ask for. Report extra ideas as recommendations or as issues.

## Planning

1. Compute each expected value of a test before it enters a ticket. If you cannot compute it, mark it as an estimate.
2. Measure before you change. A guess from code comments is not a finding. Run the existing proof first.
3. For a change to behavior that users or other systems already depend on (URLs, API responses, exported files, stored data), keep what exists working. A new parameter or field is optional, and when it is missing, the old behavior applies. Stored data migrates in the same ticket.
4. For a research ticket, ask for sources that the agent opened. Mark each inference as an inference. Save the notes in `docs/research/`.
5. Give a recommendation with each open choice. If a choice is mine, ask once and continue with the other work.

## Verification

1. Genchi genbutsu: judge by raw tool output and, for a UI change, by your own look in a browser. Do not judge by the summary of a builder.
2. Do the browser check on the production build, at 1280 px and at 360 px, on every page that the change touches.
3. Read the console for errors.
4. For a speed claim, measure the same configuration before and after, and say on which build.
5. Report each changed test in the open. Say if it is a requirement change or a weakened check. A weakened check needs my approval.
6. Say what you did not verify.

## Status loop

1. While tickets run, give me a status table every 3 minutes: ticket, state, merged or not.
2. At the time limit, send the ticket one time check. Look at its worktree before you stop it. If its last check is running, let it finish.
3. Stop the loop when no ticket runs.

## Before a merge into the target branch

Run these checks. If one result is not the expected value, stop and find the cause before you push.

1. The work tree is clean.
2. The target branch is an ancestor of the work branch.
3. Each commit has my name and my address as its author.
4. No commit has an attribution line.
5. No added line holds a private path.

Then push the work branch and open a pull request into the target branch. Never push to the target branch directly. Watch CI on the pull request. If the merge deploys, watch the deployment and check the deployed app.

## Andon: stop and ask me

- Before a pull request into the target branch, a merge, a deployment, a tag, or a post under my name. My approval of one deployment does not cover the next.
- Before a destructive or irreversible action.
- If the same ticket fails twice.
- If a requirement is ambiguous, or if the plan is wrong.
- If a check must be weakened.

## Kaizen

If the root cause of a defect is a missing rule, propose one line for this file. Apply it only after I approve.

## Report

For each ticket: ticket, model, check result, what I saw in the browser (UI changes), changed tests, limits, open questions.

At the end of a round: the state of each branch, what is live, what waits for my word, and which servers still run.
