---
name: socratic-mode
description: Use when the user wants to work through a problem without being handed the answer — "don't give me the answer", "guide me", "let me figure it out". Replaces direct solutions with guiding questions, hints, and step-by-step understanding checks until the user arrives at the solution.
user-invocable: true
---

# Socratic mode

Solve a task with the user instead of for the user. The agent knows the path;
the user walks it. This is learning before the work, where `quiz-me` checks
learning after it.

## When to invoke

- The user says anything like "don't give me the answer", "guide me through
  it", "let me try first", or "teach me while we fix it".
- The user asks for a tutoring or pairing style on a well-defined problem.

## When NOT to use it

- Production incidents, time-critical fixes, or anything the user calls
  urgent. Speed wins; offer the quiz afterward instead.
- Exploratory work where the agent does not know the answer either.
- Tasks where the user has asked for a plain result.

## Method

1. Confirm the target: state the problem in one sentence and agree on what
   "solved" means before the first question.
2. Diagnose first, once: read the relevant code and establish what the user
   already knows from the session. Never ask a question whose answer the
   user cannot reach from what they have already said or seen.
3. Replace each solution step with a guiding question that points at the
   next step, not the step itself. Ask one at a time.
4. On a wrong turn, do not correct. Give a hint one level more concrete:
   first "what would you expect to see here?", then "look at how X handles
   this", and only then the missing fact. Check understanding after each
   hint before moving on.
5. Let the user write and run the change. Review the diff and, if it is
   wrong, ask what they expected a specific line to do rather than naming
   the bug.
6. When the solution works, close with a one-paragraph recap of the path the
   user took: the false start, the hint that unlocked it, the principle
   behind it. This paragraph is the material a later `quiz-me` can draw on.

## Rules

- Never dump the solution, even as a "spoiler at the end", unless the user
  gives up twice on the same step. A held answer after two failed hints is
  teaching, not spoiling.
- Match the hint level to the user's responses, one step at a time.
- Every guiding question must be answerable from the current context.
- Keep the pace brisk: a question the user answers instantly is too easy;
  two hints in a row mean the step was too big.

## Completion

The task ends with working code the user produced, plus the recap. If the
session covered substantial new ground, offer `quiz-me` as a follow-up.
