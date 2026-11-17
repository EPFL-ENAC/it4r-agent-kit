---
name: doc-conventions
description: Use when writing, rewriting or reviewing documentation in an ENAC IT4R project (README, how-to, runbook, ADR, troubleshooting note, proposal, docs-site page). Covers the 10-minute rule and ASD-STE100 Simplified Technical English (short sentences, active voice, one word one meaning). Also covers structure, length targets by document type, warnings, formatter and documentation-site rules, and the steps to do before the commit.
---

# Documentation conventions

Write each document so that a reader understands it in one sitting of
10 minutes. Write the prose in ASD-STE100 Simplified Technical English
(STE). STE is the controlled language that aerospace uses for
maintenance manuals. These rules apply to each README, how-to, runbook,
ADR, troubleshooting note, and proposal.

STE always wins. If the rules of a project disagree with STE, obey STE.

For the file name and the frontmatter of a plan or an ADR, read the
`plan-conventions` skill.

## Language: Simplified Technical English

STE gives each word one meaning. As a result, a reader who is not a
native speaker understands the text on the first read.

If you have the `simple-english` skill, invoke it before you write
(`/simple-english:simple-english` in Claude Code). Name ASD-STE100 in
the request, so that the skill uses its strict mode. If you do not have
the skill, obey this digest:

- Procedural text tells the reader what to do. Use the imperative mood
  and one instruction in each sentence. The limit is 20 words in each
  sentence.
- Descriptive text explains. The limit is 25 words in each sentence and
  six sentences in each paragraph. Write about one topic in each
  paragraph.
- Use the active voice and simple tenses. Name the actor: "You start
  the migration."
- Put the condition before the command: "If the build fails, read the
  log."
- Use only the modals "can", "will", and "must".
- Use one word for one meaning in the full document. Keep the
  capitalization of each term the same.
- Define a concept term at its first use, in less than ten words. Do
  not define product names or standard names.
- Do not write in telegraph style. Keep the articles. Do not use
  contractions, semicolons, or em-dashes.
- Delete words that carry no fact, for example filler adverbs.
- Do not use bold text for emphasis or as a lead-in. Do not use emoji.
- Use American spelling.
- Do not change code, identifiers, commands, file paths, quoted errors,
  or product names.

STE is for facts and instructions. Do not apply it to marketing text.
No tool guarantees compliance with ASD-STE100. The official dictionary
is a free download at asd-ste100.org.

## Structure

- Write a title of less than 60 characters. Start it with a capital
  letter. Do not put punctuation at the end.
- Start with a paragraph that tells what the document covers and why
  the reader needs it. Explain what and why, not only how.
- Put each command and each snippet in a fenced code block. Put an
  example after the concept that it shows.
- Use a numbered list for steps in sequence. Use a bullet list for
  three or more parallel items.
- Add a heading every two or three paragraphs. Each section must have
  three sentences or more.
- Add a table, a list, or a code block at intervals of approximately
  20 lines.
- Wrap the prose at approximately 72 characters. A longer line is
  permitted in an operational runbook.
- If the document is long, add a summary at the top or a summary for
  each section.
- End the document with the subsequent action for the reader.
- Make sure that a reader understands the document without other
  documents.
- Do not copy content from a different `.md` file. Add a link to that
  file.
- Keep the commands in the runbook and the policy in the policy
  document. Link the two documents.
- Do not put agent-only tools in a document for humans. Write plain
  `git` and `gh` commands, not local wrappers.
- Update the documentation in the same pull request as the code that
  it describes.

## Length targets

| Document type        | Target length     |
| -------------------- | ----------------- |
| README or how-to     | 30 to 60 lines    |
| ADR or design doc    | 40 to 80 lines    |
| Troubleshooting note | 25 to 50 lines    |
| Technical proposal   | 60 to 120 lines   |
| Each document        | 800 words maximum |

A runbook that contains many procedures can be longer. If a document
goes over its target, tell the user and offer to divide it. Do not go
over the target silently.

## Warnings

Write a warning as a blockquote, before the step that it applies to.
Start with the label, then the command or the condition, then the risk.
Do not put bold text or emoji in the label. Use these labels:

- `WARNING`: a risk to people. If the two risks occur together, use
  this label.
- `CAUTION`: a risk of damage, for example a loss of data.
- `Note`: information with no risk.

```markdown
> CAUTION: Do not use the `--force` flag on the production database.
> The flag deletes rows.
```

## Formatter and documentation site

Use the tools that the project already has. The formatter can be oxfmt
or Prettier. The site generator can be MkDocs, Zensical, or a different
one. For a new project, we recommend
[oxfmt](https://oxc.rs/docs/guide/usage/formatter.html). The
[migration guide](https://oxc.rs/docs/guide/usage/formatter/migrate-from-prettier.html)
tells you how to move a project from Prettier to oxfmt.

- If the formatter breaks a syntax of the site generator, do not use
  that syntax. For example, Prettier and oxfmt remove the indentation
  that `!!!` admonitions need. Use the blockquote from the Warnings
  section.
- If the project has a documentation site, add each new page to the
  navigation of the site. Put it near the pages on the same topic. A
  page that has only a cross-link does not show in the sidebar.
- If the project has no formatter, do not add one. Tell the user.

## Before you commit

1. Count the words in your three longest sentences. Divide each
   sentence that is over the limit.

2. Search the prose for `should`, `may`, `;`, `—`, `**`, and
   contractions. Correct each hit.

3. If the project has a formatter, make sure that the format of the
   file is correct. If the project has no formatter, tell the user.

   ```bash
   npx oxfmt --check <file>.md      # or: npx prettier --check <file>.md
   ```

4. If the project has a documentation site, build the site. If the
   site generator has a strict mode, use it. For MkDocs, use this
   command:

   ```bash
   mkdocs build --strict
   ```

5. Make sure that the document explains what and why, and that it ends
   with an action. Make sure that a reader can read it in a maximum of
   10 minutes, without other documents.

The document is not completed until each step passes.
