# Implementation standards

How to change the tree once inspection is done. The Dev Note still uses only published BA/SA IDs plus local `DEV-n` / `BLK-n`.

## Before the first edit

Write down, in the note or in the working plan:

- Impact: callers, stored data, and contracts the change can break.
- Files to edit. Files to add. Say "none" when there are none.
- Module dependencies you will actually call.
- The steps, in order, each one a reviewable slice.
- Regression spots: existing behavior the slice can disturb.
- Tests that already cover those spots.

Do not edit a file that is outside that list. If a later step needs a new file, add it to the list before editing it.

## While editing

- One logical change at a time. Finish or record it before starting the next.
- Follow conventions already in those files.
- Keep the published API and schema unless `references/database-api-guidelines.md` applies and the user or SA has accepted a change.
- Do not add a dependency to make the slice easier.
- Leave unrelated reformatting and drive-by cleanup out of the diff.

## When implementation fails

| What happened | What to do |
|---------------|------------|
| Build failed | Read the error. Fix the cause in this change. Re-run. Do not report `ready`. |
| Test failed | Find the cause. Do not delete, skip, or weaken the test to go green. |
| An existing test broke | Treat it as a regression. Fix the code, or stop and record why the spec says the old assertion is wrong. |
| Dependency conflict | Do not change versions to see what sticks. Record the conflict. Status stays `draft` or `blocked`. |
| Only part of the slice lands | Record what landed and what did not. Implementation: `partial`. Status: `draft`. |

Do not hide an error with an empty catch, a swallowed exit code, or a disabled lint/test rule.

## After the slice

Inspect the diff before the note is finished. Remove temporary logging and debug breakpoints. Generated files and secrets do not belong in the change.
