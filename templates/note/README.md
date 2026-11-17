# Note lookback contract

Workspace root (not inside `Kio/` unless that is the workspace):

```text
note/YYYY-MM-DD/
  ba.brief.md
  sa.spec.md
  dev.impl.md
  qa.status.md
  manifest.json
```

Multi-topic same day: `note/YYYY-MM-DD-{suffix}/`  
Same topic on a later day: reuse the original folder (do not open a new dated folder that drops the chain). Resolve by topic match — not “exactly one folder today”.

Install copies this folder to the project as `templates/note/` (schema + this README).

## Frontmatter (every role file)

See `frontmatter.schema.json`.

```yaml
---
topic: dispense
date: 2026-11-13
role: ba          # ba | sa | dev | qa
status: ready     # draft | ready | blocked
us_ids: [US-1]    # prefer US-n; [] OK for consults
bo_ids: [BO-1]    # optional; BA objectives, same IDs as the brief
br_ids: [BR-1]    # optional; BA requirements (not RULE-n)
note_folder: note/2026-11-13-dispense
recommendation: null   # qa only: ship | ship_with_risk | no_ship | null
---
```

## manifest.json

Machine-readable index for week scans / tooling. Writers **merge** updates — never wipe other roles; preserve `recommendation` and unknown keys.

See `manifest.schema.json`. Optional `"$schema": "templates/note/manifest.schema.json"`.

Validate:

```powershell
& path\to\Kio\scripts\validate-notes.ps1 -Target "C:\path\to\project"
```

```bash
path/to/Kio/scripts/validate-notes.sh /path/to/project
```
