---
name: quiz-me
description: Use when the user wants to check and keep what they learned during the current task — "quiz me", "test my understanding", "what should I remember from this". Runs a short adaptive quiz on the session's concepts, one question at a time, with feedback and a closing list of strengths and gaps.
user-invocable: true
---

# Quiz me

Check the user's understanding of the current task through a short, adaptive
quiz. The conversation is the source material; nothing is prepared in advance.

For a harsher check that defends decisions instead of recalling concepts, use
the `challenge-me` skill.

## When to invoke

- The user asks to be quizzed on the current task.
- The user accepts an offered learning follow-up at the end of a task.

## Method

1. Extract 3-5 topics from the session: concepts, decisions, mechanisms, and
   why things worked or failed. Present the topic list before the first
   question. The user may veto a topic, name a different one, or say "focus
   on my weak spots".
2. Weight the questions toward friction points by default: places where the
   user hesitated, asked a basic question, or got something wrong during the
   task. This weighting is automatic, not an option the user must request.
3. Ask one question at a time. Wait for the answer. Never reveal the answer
   before the user attempts it.
4. Escalate depth only on confident answers, in three tiers:
   - Recall: what / why / when.
   - Teach-back: explain the mechanism in the user's own words.
   - Transfer: predict what happens if a constraint changes, or apply the
     idea to a new scenario.
   Drop a topic once the user clearly has it. Spend remaining questions on
   shaky ones.
5. After each answer, give concise feedback: what was correct, what was
   missing, a short example when useful. Tone: supportive, not exam-like.

## Rules

- At most 5 questions, one per topic.
- Only test concepts the session covered or reasonably implied.
- Test understanding, never code memorization.
- If an answer shows the agent itself explained something wrong earlier in
  the session, correct the record before continuing.
- Skip the quiz when the task held no meaningful learning material.

## Completion

End with: what the user understood well, concepts worth revisiting, and one
suggested next step if useful. No files are written and nothing is stored.
