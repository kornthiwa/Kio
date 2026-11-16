---
name: summarize-notes
description: >-
  Summarize BA/SA/Dev/QA lookback notes from workspace-root note/ folders using
  manifest.json and frontmatter first. Use when the user asks to summarize notes,
  week scan, lookback summary, what shipped, or status across note topics.
---

# summarize-notes

Core question: **What do the saved notes say — without inventing facts?**

## Hard rules

1. Prefer **`manifest.json` + YAML frontmatter**; fall back to markdown bodies only when needed.
2. **Never invent** missing roles, ACs, bugs, or recommendations. Say `missing` explicitly.
3. Workspace root only: folder that contains `Kio/` / `AGENTS.md` → `note/…` (not under `Kio/` unless that is the root).
4. If multiple topic folders match and the user did not name one → **list and ask** (do not guess).
5. Optional: run `scripts/validate-notes.ps1` / `validate-notes.sh` before summarizing if the user wants a health check.

## Modes

- **Topic** — one folder (`note/YYYY-MM-DD` or `note/YYYY-MM-DD-suffix`)
- **Week / range** — scan `note/*/` for dates in range (default: last 7 calendar days from today)
- **Health** — list folders missing `manifest.json` or role files

Default: **Topic** if a path/topic is given; else ask Topic vs Week.

## How to work

1. Resolve workspace root and list `note/*/`
2. Pick folder(s) per mode
3. For each folder:
   - Read `manifest.json` if present → `topic`, `us_ids`, `bo_ids`, `br_ids` (if present), `roles.*.status`, `tldr`, `recommendation`
   - Note which role files exist on disk
   - If summarizing deeply, read present role files; honor frontmatter `status` / `recommendation`
4. Emit the output template (below)
5. Do **not** write notes unless the user asks to save a summary file

## Output template (required)

```markdown
# Notes summary

## Scope
- Mode: Topic | Week | Health
- Folders: …

## Per topic
### `note/YYYY-MM-DD-suffix/`
- Topic: …
- US IDs: … | (none)
- BO / BR IDs: … | (none in manifest)
- Roles: ba=ready|missing  sa=…  dev=…  qa=…
- TL;DR: … | (no manifest tldr)
- QA recommendation: ship | ship_with_risk | no_ship | null | (no QA)
- Missing files: …
- Open / blocked (from files only): …

## Cross-topic (Week mode only)
- Ship / ship_with_risk / no_ship counts
- Blocked roles
- Folders without manifest

## Gaps
- …
```

## Mini example

```markdown
# Notes summary

## Scope
- Mode: Week
- Folders: note/2026-11-13-dispense/, note/2026-11-13-note-verify/

## Per topic
### `note/2026-11-13-dispense/`
- Topic: dispense
- US IDs: US-1
- Roles: ba=ready  sa=ready  dev=missing  qa=ready
- TL;DR: Dispense Must AC1/AC2; allergy TBD
- QA recommendation: no_ship
- Missing files: (none)
- Open / blocked: BUG-1 stock=0; US-1-AC3 GAP

### `note/2026-11-13-note-verify/`
- Topic: note-verify
- US IDs: US-1
- Roles: ba=missing  sa=ready  dev=missing  qa=missing
- TL;DR: metadata gaps closed
- QA recommendation: (no QA)
- Missing files: ba.brief.md, qa.status.md
- Open / blocked: (none in manifest)

## Cross-topic
- no_ship: 1 | ship: 0 | ship_with_risk: 0
- Folders without manifest: (none)

## Gaps
- dispense blocked on BUG-1
```
