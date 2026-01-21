# Planning workflow

This document describes how to-dos, questions, and daily logs are structured in this forest, and how the helper scripts are expected to be used.

## To-dos

Location: `trees/planning/to-do/XXXX.tree`

Structure (minimum):
- `\import{base-macros}`
- `\todo{created}{state}{todo-XXXX}{minutes}{pretty}{title}`

Notes:
- `state` is shown on the page and used by the backlog/completed queries. Typical values are `incomplete` and `complete`.
- `todo-XXXX` is the Timewarrior tag for this to-do. The `XXXX` is the tree id.
- `minutes` and `pretty` are updated by `scripts/daily-log`. Avoid manual edits unless you keep them consistent.

Optional manual additions:
- `\tag{question-QXXXX}` to associate the to-do with a question.
- `\subtasks{ ... }` blocks or regular text notes after the `\todo` line.

Creation script:
- `scripts/new-todo "title"` creates a new to-do and its `todo-XXXX` tag.
- `scripts/new-todo --question QXXXX "title"` adds the question tag.
- `scripts/new-todo --subtask-of XXXX "title"` links this as a subtask.

## Questions

Location: `trees/notes/questions/QXXXX.tree`

Structure (minimum):
- `\import{base-macros}`
- `\question{created}{state}{question-QXXXX}{minutes}{pretty}{title}`

Notes:
- `state` is shown on the page and used by `trees/notes/questions.tree` (it lists `open` questions).
- `question-QXXXX` is the Timewarrior tag for this question.
- Related to-dos live in `trees/notes/questions/related-question-QXXXX.tree` and are transcluded by the `\question` macro (collapsed by default).
- `minutes` and `pretty` are updated by `scripts/daily-log`. Avoid manual edits unless you keep them consistent.

Related to-dos page:
- Structure: `\import{base-macros}`, `\title{related to-dos}`, `\relatedtodos{question-QXXXX}`.
- Safe edits: you can add notes above/below the `\relatedtodos{...}` line.

Creation script:
- `scripts/new-question "title"` creates a new question and its `question-QXXXX` tag.

## Daily logs

Location: `trees/planning/logs/YYYY/MM/YYYY-MM-DD.tree`

Structure (minimum):
- `\import{base-macros}`
- `\logday{month day, year}{ ... }`
- `\logitems{ ... }` with entries like `\logitem{ID}{1h 20m}` for both to-dos and questions.

Manual edits:
- `\logmanual{body}{time}` items are preserved across runs (time uses the same `1h 20m` format as `\logitem`).
- `\lognotes{...}` blocks are preserved across runs.

Update script:
- `scripts/daily-log` reads Timewarrior data for the day, matches `todo-XXXX` and `question-QXXXX` tags, updates the time totals in the corresponding to-do/question files, and rewrites the log file.
- `scripts/daily-log` normalizes `\logmanual{...}` times when they parse as hours/minutes and warns if they do not.
- Useful flags: `--date YYYY-MM-DD`, `--todo-dir PATH`, `--question-dir PATH`, `--logs-dir PATH`.
