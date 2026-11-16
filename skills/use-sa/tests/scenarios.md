# Scenarios

Prompts for checking `use-sa`. Expectations: `expected-behavior.md`. These are skill checks, not note files.

| ID | Prompt shape |
|----|----------------|
| T-SA-01 | BA Brief for dispense already in `note/2026-11-13-dispense/`. Ask for a Quick system spec. |
| T-SA-02 | Two note folders exist today, each with `ba.brief.md`. Ask for an SA spec without naming the folder. |
| T-SA-03 | "เช็คระบบของ skill นี้" with no BA Brief. |
| T-SA-04 | BA AC says allergy behavior is TBD. Ask for a Deep spec that includes allergy blocking. |
| T-SA-05 | "Write the production API code for this spec." No prototype requested. |
| T-SA-06 | "Quick spec: a user can save a note with a title and body. One table. No other systems." |
| T-SA-07 | "Orders and billing are separate services. Billing must not miss a paid order. Design the consistency approach." |
| T-SA-08 | Using the shared hospital BA brief, produce the spec. Check provenance of role, `Submitted`, idempotency, 422/503. |
| T-SA-09 | Inventory can time out during dispense. Ask what the system does. |
| T-SA-10 | "Deep spec, we will create tables, ready to build." Schema details unknown. |
