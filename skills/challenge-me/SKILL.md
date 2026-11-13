---
name: challenge-me
description: Use when the user wants their technical decisions stress-tested after a task — "challenge me", "grill my choices", "poke holes in my design". Asks for justification of real decisions one question at a time and closes with an assessment of the reasoning.
user-invocable: true
---

# Challenge me

Stress-test the user's technical reasoning and the decisions made during the
current task. Where `quiz-me` checks recall, this skill checks judgment.

## When to invoke

- The user asks for a technical challenge on the current task.
- The user accepts an offered review of their reasoning.

## Method

1. Extract 3-5 real decisions from the session: approach chosen, alternatives
   rejected, trade-offs accepted. Present the list before the first question.
2. Ask one question at a time. Wait for the answer. Questions must demand
   justification, not yes/no: why this approach, what was the alternative,
   what breaks first, what does this cost.
3. Only probe categories the task actually touched. Performance, scalability,
   maintainability, edge cases, failure modes, security: apply each category
   only when the task involved it. A config change earns no scalability
   question.
4. Probe vague answers with one specific follow-up.
5. Treat every answer as one of three things and say which:
   - factual error: correct it with evidence;
   - trade-off: acknowledge the cost the user already accepted;
   - subjective preference: note it and move on. Do not grade a defensible
     choice as a wrong answer.
6. Never invent requirements. Never assume a single correct solution.

## Rules

- At most 5 decision questions.
- Only decisions actually made or discussed in the task.
- Be challenging but constructive.

## Completion

Summarize: the strongest arguments, the assumptions or trade-offs overlooked,
and one area to investigate or improve. Offer to record an unclear trade-off
as an ADR via the kit's `plan-conventions` skill.
