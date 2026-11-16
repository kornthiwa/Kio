# System Spec template

Read this on every `use-sa` run. Fill **Core** always. Paste a **conditional** section only when `SKILL.md` says that trigger fired. Put every excluded conditional section in **Skipped sections** with a reason. Do not leave empty headings.

The chat answer and `sa.spec.md` are this filled document. Do not also create `architecture.md` or `adr.md` inside `note/`.

Provenance tags: `[Requirement US-1-AC1]` `[Decision D1]` `[Assumption A1]`. Untagged claims must appear in the AC map.

```markdown
---
topic:
date: YYYY-MM-DD
role: sa
status: draft
us_ids: []
note_folder: note/YYYY-MM-DD
---

# System Spec

## Note folder
`note/YYYY-MM-DD/` (same folder as the BA Brief when one exists)

## Context
- Source: BA Brief US-… / AC-…  |  consult / as-built
- Mode: Quick | Deep
- Goal:

## AC → Design map
| AC ID | Design element | Kind |
|-------|----------------|------|
| US-1-AC1 | | Requirement |

Consults with no BA stories: write `No BA IDs — consult` and do not invent US rows.

## Provenance
| ID | Kind | Statement | Because |
|----|------|-----------|---------|
| D1 | Decision | | BA did not specify this |
| A1 | Assumption | | Unconfirmed |

Requirements stay in the AC map. Repeat one here only when a reader could mistake it for a decision.

## System boundary
- In scope:
- Out of scope:
- External systems: (or none)

## Actors
- Name — source (BA actor / system). Auth role, if any, is a Decision, not a copy of the actor name.

## Skipped sections
| Section | Reason |
|---------|--------|
| Architecture detail | trivial: single component, no external |
| Sequence diagrams | covered by numbered flows |
| Approved data model | Quick — Draft only |
| Security design | single role, no sensitive-data trigger; see NFR |
| Distributed consistency | single process |
| Integration contract | no external / Quick failure section is enough |
| ADR | no hard-to-reverse choice |
| Deployment / observability / backup | not a production handoff |

Delete rows that you actually included. An empty table means every conditional section is in the spec — rare and usually wrong for CRUD.

## Data model
### Draft
- Entity:
  - fields:
  - relationships:
  - states: (only states BA named, plus tagged Decisions)
  - covers:

No persisted store → replace this section with `N/A — no persisted store`.

### Approved
Include only when P0-DB says Approved (Deep + a store). Otherwise omit and keep the Skipped row. Shape: `templates/database-design.md`.

## APIs / interfaces
One block per endpoint, shape from `templates/api-contract.md`. No interface → `N/A` and say what Dev implements instead (job, CLI, UI-only).

## Critical flows
1. Name — steps — AC IDs — Decisions used

## Non-functionals
Fill from `templates/nfr-checklist.md`. Every row needs Target + how to verify, or TBD / N/A.

## Failure and integration risks
| Risk | Impact | Recovery | Data left behind |
|------|--------|----------|------------------|
| | | | |

"Data left behind" is the consistency statement: which records exist, which status is unchanged, whether a retry is safe.

## Alternatives considered
| Option | Trade-off | Impact |
|--------|-----------|--------|
| A | | |
| B | | |

- Chosen:
- Why:
- Decision / ADR:
- (or: trivial — single path)

## Open decisions
- D-n or BA Q-n — owner — blocks build? yes/no

## Handoff — Dev
Quick: constraints + status. Deep: full lists in `templates/handoff.md`.

- Constraints Dev must not reinterpret:
- Status: Ready to build / Blocked (why)

## Handoff — QA
- Observable result per Must AC:
- Test data:
- Behaviors that are Decisions (do not send these back to BA as gaps):
- Status: Ready for test design / Blocked (why)
```

## Conditional sections

Insert in this order, only when triggered. Headings and fields live in the linked template.

1. Architecture — `architecture.md` (P0-A)
2. Sequences — `sequence-diagram.md` (P0-S)
3. Data flow — `data-flow.md` (P0-DF)
4. Security — `security-design.md` (P0-SEC)
5. Consistency — short section after reading `references/distributed-systems.md` (P0-DIST). Name the problem, the pattern used or rejected, and the `D-n` / `ADR-n`.
6. Integration contracts — `integration-contract.md` (P1-INT)
7. ADR — `adr.md` (P1-ADR)
8. Operations — `deployment.md` (P1-OPS): environments, deploy, rollback, observability, backup. Capacity numbers stay in the NFR table.

## Annotated example (hospital dispense)

Illustrates provenance. Do not copy into other domains. BA source is the shared US-1 brief: pharmacist dispenses a verified order; AC1 stock OK → Dispensed + audit; AC2 stock unavailable → reject, stay Verified; AC3 allergy TBD; inventory assumed stock source; cancel-before-dispense is a named exception. BA does **not** define an auth role, the status `Submitted`, an idempotency header, or HTTP status codes.

This excerpt is not a full Quick spec. A real run also includes Architecture and SD-1, because inventory is external. Those drawings are omitted here so the tags stay easy to check.

```markdown
## AC → Design map
| AC ID | Design element | Kind |
|-------|----------------|------|
| US-1-AC1 | POST /orders/{id}/dispense success path | Requirement |
| US-1-AC2 | Same API rejects; order stays Verified | Requirement |
| US-1-AC3 | Not designed | Requirement (TBD) — blocked on BA Q1 |

## Provenance
| ID | Kind | Statement | Because |
|----|------|-----------|---------|
| D1 | Decision | Auth role `pharmacist` maps the BA actor | BA named the actor, not an authz mechanism |
| D2 | Decision | Stock failure is HTTP 422, code STOCK_UNAVAILABLE, not retryable | AC2 says reject; the code is ours |
| D3 | Decision | Idempotency-Key required on this POST | BA did not specify double-submit; clinical + inventory makes a silent duplicate unsafe |
| D4 | Decision | Conditional update WHERE status=Verified; one winner, loser 409 | Derived so AC1 cannot apply twice; not a new business rule |
| D5 | Decision | Unknown or non-Verified order → 409, code NOT_VERIFIED | AC starts at Verified; other statuses are not success |
| A1 | Assumption | Inventory service is stock truth | Inherited BA A1 |
| A2 | Assumption | `Submitted` is upstream of this spec and is not a state we persist here | "Doctor submits" is a flow step, not an AC state |
| D6 | Decision | Status `Cancelled` models "cancelled before dispense" | BA named the exception, not the enum value |
| D7 | Decision | Inventory timeout is HTTP 503, code INVENTORY_TIMEOUT, retryable | BA did not specify the transport failure |
| ADR-1 | Decision | Sync stock check inside the dispense API | Hard to reverse vs async reserve; see Alternatives |

## Data model
### Draft
- MedicationOrder: id, status (Verified \| Dispensed \| Cancelled)
  - Verified and Dispensed: Requirement US-1-AC1/AC2
  - Cancelled: Decision D6, models BA exception "cancelled before dispense"
  - Submitted: not in this spec (A2)
- DispenseRecord: id, orderId, pharmacistId, at — append-only audit for AC1

## APIs / interfaces
### POST /orders/{id}/dispense
- Auth: role=pharmacist [Decision D1]
- Request: path order id; header Idempotency-Key [Decision D3]
- Response: 200 { orderId, status: Dispensed, dispenseId }
- Errors: see shared envelope. 422 STOCK_UNAVAILABLE [D2]; 409 NOT_VERIFIED [D5]; 409 ALREADY_DISPENSED [D4]; 503 INVENTORY_TIMEOUT retryable, order stays Verified, no DispenseRecord [D7]
- Idempotency: required key; replay returns the same dispenseId [D3]
- Covers: US-1-AC1, US-1-AC2

## Failure and integration risks
| Risk | Impact | Recovery | Data left behind |
|------|--------|----------|------------------|
| Inventory timeout | Cannot know stock | 503, caller retries with the same key | Order stays Verified; no DispenseRecord |
| Duplicate submit | Second request | Same key → same dispenseId; no key collision across orders | One DispenseRecord |
| Stock zero | Must not dispense | 422 | Stays Verified; no audit of a successful dispense |

## Alternatives considered
| Option | Trade-off | Impact |
|--------|-----------|--------|
| A sync check in this API | One step, matches AC | Couples latency to inventory |
| B reserve-then-dispense | Better under load | Extra states BA did not ask for |

- Chosen: A
- Why: Must scope is a single confirm
- ADR-1

## Skipped sections
| Section | Reason |
|---------|--------|
| Approved data model | Example is Quick — Draft only |
| Saga / outbox | Rejected; single API + sync call (ADR-1) |
| Deployment / DR | Not a production handoff |
| Security design | D1 is enough until authz grows past one role; clinical payload still needs the NFR audit row |

## Open decisions
- BA Q1 allergy — blocks AC3 — yes
- BA Q2 partial dispense — blocks only if BA says Must — yes until answered

## Handoff — QA
- US-1-AC1 observable: 200, status Dispensed, one audit row
- US-1-AC2 observable: 422 STOCK_UNAVAILABLE, status still Verified
- Test data: stock>0; stock=0; inventory timeout; same Idempotency-Key twice
- 422 and 503 are Decisions D2 and D7. A wrong code is a spec miss (SA), not a missing business rule (BA)
- AC3: do not test; GAP to BA
```
