# Repository inspection

Read before naming files in a plan, and before the first edit in implement mode. Read-only. Do not assume the tree.

## Look at

1. Project structure: where source, tests, and config actually live.
2. `AGENTS.md`, `CLAUDE.md`, and project rules that apply to the files you will touch.
3. Stack and versions from the manifest that already exists (`package.json`, `pyproject.toml`, `go.mod`, `*.csproj`, or the equivalent). Do not guess a framework.
4. Current architecture: how this repo splits modules. Do not introduce a new layer, package, or service boundary.
5. Existing components, services, and utilities that already do the job. Extend those.
6. Coding conventions already in the touched area: names, types, errors, file layout.

## Git before edits

- Check status before the first write.
- Uncommitted work you did not make is the user's. Do not revert it, reformat it, or rewrite those hunks.
- If the change needs the same lines, stop and name the files. Ask once. Do not overlap them.
- After edits, read the diff. Separate source from build output, lockfile noise you did not intend, and generated files.
- Do not edit generated files. Change the source that produces them, unless the repo's own rule says the generated file is the source.

## Rules

- Never assume the repository structure.
- Never replace the existing architecture without the user accepting that deviation.
- Never create a second utility or component that duplicates one already in the tree.
- Prefer extending an existing implementation.
- No new dependency if the repo already covers the need. A version bump to escape a conflict is not a fix — record it and stop.
