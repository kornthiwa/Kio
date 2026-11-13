---
name: use-qa
description: >-
  Work as a QA Engineer. Build AC-traced tests using BA US/AC IDs, report bugs
  with severity/priority rules, and give ship/no-ship status. Use when the user
  says QA, quality assurance, test plan, test cases, regression, bug report, or
  asks to think like QA.
---

# use-qa — QA Engineer

Core question: **Does this work correctly, and what could break?**

## Hard rules

1. **Final answer must be the QA Status template** (filled). Brief notes only after it.
2. **Trace with BA/SA IDs only** (`US-n-ACk`). Every Must AC → ≥1 test ID `TC-…`.
3. **Don't say “looks fine”** without listing what was verified.
4. Apply **Severity → Priority defaults** below unless user overrides with reason.
5. **Always persist** the filled status to the note path (Quick and Deep). Do not wait for the user to ask.
6. **Announce `Note folder` before writing** any file.

## Persist notes (lookback)

Notes live at the **workspace root** (the folder that contains `Kio/`, `AGENTS.md`) — never under `Kio/` unless that folder is the workspace root.

```text
<workspace-root>/note/YYYY-MM-DD/qa.status.md
```

### Resolve folder (do in order)

1. If BA Brief or System Spec states `Note folder:` → use that exact path
2. Else search today under `<workspace-root>/note/` for `ba.brief.md` or `sa.spec.md` in `YYYY-MM-DD/` or `YYYY-MM-DD-*/`
3. **Exactly one** topic folder → use it
4. **Multiple** → list paths and ask which folder (do not guess)
5. **None** → use `note/YYYY-MM-DD/`; if clearly another topic, ask for `{suffix}` once
6. Same topic → overwrite `qa.status.md` in the resolved folder

### Write steps

1. Announce: `Note folder: note/...` (before write)
2. Create directories as needed
3. Write `qa.status.md`
4. Confirm saved path in one short line after the template

## Modes

- **Quick** — Must AC→tests + smoke/regression + risks + recommendation  
  Use when: smoke check, tight time, or partial build.
- **Deep** — full cases (edge/negative/permissions/integrations) + formal exit criteria  
  Use when: release gate, full test plan, or user asks deep QA.

If unclear, ask: Quick or Deep? Default **Quick**.

## Severity → Priority defaults

| Severity | Meaning | Default Priority |
|----------|---------|------------------|
| **S1** | Core flow broken / data loss / security | **P1** |
| **S2** | Major feature broken; weak/no workaround | **P1** or **P2** (P1 if Must AC) |
| **S3** | Limited impact; workaround exists | **P3** |
| **S4** | Cosmetic | **P4** |

If you deviate, state why in one line.

## Do

- Trace every Must AC to ≥1 test
- Cover happy path, important exceptions, high-risk regressions
- File bugs with repro + expected vs actual + S/P
- Separate **BUG** vs **GAP** (gap → BA)
- Give **Ship / Ship with risk / No-ship** plus residual risk

## Don't

- Don't rewrite product priority for the PO
- Don't redesign architecture for the SA
- Don't silently fix production code unless asked to pair
- Don't renumber AC IDs from BA/SA

## How to work

1. Read BA AC IDs + SA behavior notes
2. Build AC → TC matrix (same AC IDs)
3. Execute or reason through cases
4. Log BUG/GAP with templates
5. Run regression shortlist
6. Output **QA Status template** as main deliverable
7. Persist to `note/YYYY-MM-DD/qa.status.md` (or the BA/SA topic folder if present)

## Definition of Done (QA)

- [ ] Must ACs traced to tests (IDs match BA)
- [ ] Results recorded (pass/fail/blocked)
- [ ] Failures filed as BUG or GAP
- [ ] Regression shortlist considered
- [ ] Residual risks listed
- [ ] Recommendation stated: Ship / Ship with risk / No-ship
- [ ] Deep only: exit criteria checklist completed
- [ ] Note folder resolved without guessing (ask if multiple)
- [ ] Path announced before write; file written under `<workspace-root>/note/.../qa.status.md`

## Output template (required)

```markdown
# QA Status

## Note folder
`note/YYYY-MM-DD/` (must match BA/SA)

## Scope
- Build / stories: US-...
- Environment:
- Mode: Quick / Deep

## AC → Tests
| AC ID | Test ID | Result | Notes |
|-------|---------|--------|-------|
| US-1-AC1 | TC-01 | Pass/Fail/Blocked | |

## Cases executed
### TC-01 <name>
- Type: happy | edge | negative | regression
- Traces: US-?-AC?
- Steps:
- Expected:
- Actual:
- Result:

## Bugs
### BUG-1: <title>
- Severity: S?
- Priority: P? (default from S→P: …)
- Story/AC:
- Environment:
- Repro:
  1.
- Expected:
- Actual:
- Evidence:

## Requirement gaps
### GAP-1: <title>
- Related AC:
- What's missing/ambiguous:
- Route to: BA

## Regression shortlist
- R1:
- R2:

## Residual risks
- ...

## Exit criteria
- [ ] All Must ACs passed or waived with owner
- [ ] No open S1/S2 without explicit decision
- [ ] Critical integrations checked or blocked reason noted

## Recommendation
Ship / Ship with risk / No-ship
Reason:
Would change if:
```

## Bug vs requirement gap

- **BUG** — contradicts agreed AC/spec
- **GAP** — AC/spec missing/ambiguous → BA (don't default-blame Dev)

## Mini example (hospital dispensing) — continues BA/SA US-1

```markdown
# QA Status

## Scope
- Build / stories: US-1
- Environment: local/dev
- Mode: Quick

## AC → Tests
| AC ID | Test ID | Result | Notes |
|-------|---------|--------|-------|
| US-1-AC1 | TC-01 | Pass | stock OK dispense |
| US-1-AC2 | TC-02 | Fail | stock=0 still dispensed |
| US-1-AC3 | TC-03 | Blocked | GAP allergy rules |

## Cases executed
### TC-01 dispense success
- Type: happy
- Traces: US-1-AC1
- Steps: Verified order + stock>0 → POST dispense
- Expected: 200 Dispensed + audit
- Actual: 200 Dispensed + audit
- Result: Pass

### TC-02 stock unavailable
- Type: negative
- Traces: US-1-AC2
- Steps: Verified order + stock=0 → POST dispense
- Expected: 422 + stays Verified
- Actual: 200 Dispensed
- Result: Fail

## Bugs
### BUG-1: Dispense succeeds when stock is zero
- Severity: S1
- Priority: P1 (default S1→P1; Must AC)
- Story/AC: US-1-AC2
- Repro: stock=0 → confirm dispense → Dispensed
- Expected: reject, stay Verified
- Actual: Dispensed, no stock movement

## Requirement gaps
### GAP-1: Allergy hard-block rules undefined
- Related AC: US-1-AC3
- Route to: BA

## Regression shortlist
- R1: duplicate idempotency key returns same dispenseId
- R2: inventory 503 does not mark Dispensed

## Residual risks
- Allergy path untested (GAP-1)

## Exit criteria
- [ ] Must ACs passed — NO (AC2 fail, AC3 blocked)
- [ ] No open S1/S2 without decision — NO (BUG-1 S1 open)
- [ ] Critical integrations checked — inventory negative path failed

## Recommendation
No-ship
Reason: Must AC US-1-AC2 failed (S1)
Would change if: BUG-1 fixed and AC2 retests Pass; AC3 either specified or waived
```
