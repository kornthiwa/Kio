# Verification

Record this table in the Dev Note. One row per check. Do not collapse them into a single "tests passed".

| Check | Command | Result |
|-------|---------|--------|
| Lint | | pass / fail / not run / N/A |
| Type check | | pass / fail / not run / N/A |
| Unit test | | pass / fail / not run / N/A |
| Integration test | | pass / fail / not run / N/A |
| Build | | pass / fail / not run / N/A |

## How to fill a row

- Command: the script the repo already has (`npm test`, `pytest`, `go test`, the project file). Never invent a command.
- `pass` only after you run it and it exits successfully in this session.
- `fail` with the first real error. Fix the cause in this change. Do not silence the check.
- `not run`: the repo has the command and you did not run it. Status cannot be `ready`.
- `N/A — no script`: the repo has no such command. This does not block `ready`.
- `N/A — not applicable`: the command exists but cannot see this change (for example a UI suite on a SQL-only fix). Say why in the cell.

## Two different "done"

- Implementation complete: the in-scope Must ACs are in the code.
- Verification complete: every applicable row is `pass` or `N/A` with a reason.

`status: ready` needs both. Implementation complete with a `not run` or `fail` row stays `draft`.

Plan mode fills every row `not run` and does not imply they passed.
