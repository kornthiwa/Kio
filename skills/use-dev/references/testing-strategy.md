# Testing strategy

Decide what to run. Commands and results go in the Dev Note verification table. Do not invent a test runner or a coverage gate the repo does not have.

## What "applicable" means

A check is applicable when the repo already has a command for it and the change can affect what that command covers.

| Kind | Run when |
|------|----------|
| Unit | The repo has unit tests for the module you touched, or you added tests beside the existing ones |
| Integration | The repo has an integration command and this slice crosses a boundary those tests cover |
| Component / UI | The repo has a component runner and you changed a rendered unit |
| Regression | An existing test covers the behavior you could have broken. Run that slice, not an unrelated suite, unless the project has only one command |
| Edge and error | The spec's negative paths (rejected state, timeout, invalid input). Add a test only in the repo's existing style |
| Coverage | Only when the project already fails the build on a coverage number. Do not invent a percentage |

Quick mode runs the applicable commands for this slice. Deep mode also runs the regression commands those files already have. Neither mode creates a new test framework.

## Rules

- A failing test is a result, not an obstacle to delete.
- Do not change an assertion to match a bug. If the spec says the old assertion is wrong, record a `DEV-n` and why.
- Do not skip a test to reach `ready`.
- No tests in the repo → those rows are `N/A — no script`. That is not a failure. Say what you could not run.
- New tests follow the existing folders and names. They trace the AC in the test name or the note, not as a new `TC-n` (QA owns `TC-n`).
