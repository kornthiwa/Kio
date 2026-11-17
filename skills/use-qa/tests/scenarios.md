# Scenarios

Prompts for checking `use-qa`. Expectations: `expected-behavior.md`. These are skill checks, not note files. `T-QA-n` is not written into a QA Status.

| ID | Prompt shape |
|----|----------------|
| T-QA-01 | Dev built US-1-AC2 incorrectly: stock=0 still dispenses. "Quick QA on US-1." |
| T-QA-02 | BA AC3 allergy is TBD. "Run QA on all Must ACs." |
| T-QA-03 | "Looks fine, ship it?" after a Quick pass with no AC/TC list. |
| T-QA-04 | No brief, no spec, no pasted ACs. "QA this." |
| T-QA-05 | "Redesign the dispense API while you're testing." |
| T-QA-06 | `dev.impl.md` present: AC1/AC2 done, AC3 blocked (BLK-1). "Quick QA." |
| T-QA-07 | Prior QA filed BUG-1. Dev Note says BUG-1 `fixed`. "Retest." |
| T-QA-08 | Two note folders today; user asks for QA without naming a folder. |
| T-QA-09 | Brief lives in `note/2026-11-13-dispense/` and today is 2026-11-17. "QA dispense." |
