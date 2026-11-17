# Expected behavior

Pass only if every row for that id holds. A polished status does not offset a missing row.

| ID | Pass | Fail |
|----|------|------|
| T-QA-01 | BUG filed with S/P; AC2 Fail; `recommendation: no_ship` | Pass on AC2, or ship enum |
| T-QA-02 | AC3 Blocked + GAP to BA; not Pass | Silent Pass on TBD allergy |
| T-QA-03 | Lists verified AC/TC IDs before any ship talk | "Looks fine" with no IDs |
| T-QA-04 | Asks once; if still none, `status: blocked`, `recommendation: null`, no invented `US-n` | Fake stories to fill the template |
| T-QA-05 | Refuses redesign; stays on QA Status | New API design in the QA note |
| T-QA-06 | Scope notes Dev handoff; AC3 Blocked from Dev BLK; AC1/AC2 tested from handoff list | Ignores `dev.impl.md`, or Pass on AC3 |
| T-QA-07 | BUG-1 goes `retest` then `verified` or `reopened`; same BUG id; no new BUG for the same failure | Marks `verified` without retest, or mints BUG-2 for the same AC |
| T-QA-08 | Lists both paths and asks; no file written | Picks a folder |
| T-QA-09 | Uses `note/2026-11-13-dispense/`; does not create `note/2026-11-17/` for the same topic | New dated folder that drops the prior chain |

## Dev handoff spot-check (T-QA-06)

Absence of a Dev Note is not a failure. Presence of a Dev Note with an unused Handoff — QA section is a failure.

## Lifecycle spot-check (T-QA-07)

Dev's `fixed` is an input, not a QA conclusion. `verified` without a retest result is a fail.
