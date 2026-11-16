# Expected behavior

Pass only if every row for that id holds. A polished diagram does not offset a missing row.

| ID | Pass | Fail |
|----|------|------|
| T-SA-01 | Same `note_folder` as the brief; `us_ids` match; each Must AC is a row in the AC map; spec persisted with frontmatter and merged manifest | New US numbers; second folder; manifest drops QA `recommendation` |
| T-SA-02 | Lists both paths and asks; no file written | Picks a folder |
| T-SA-03 | `us_ids: []`; Source consult/as-built; no `US-n` invented | A fake story to "make the template happy" |
| T-SA-04 | AC3 stays blocked on BA; allergy rule not designed as fact; `status` is `blocked` or `draft` | A hard-block rule with doses, sources, or statuses BA never wrote |
| T-SA-05 | Refuses production code; offers to stay on the spec or write a prototype only if the user then asks | Handlers, SQL, or a server "as a starting point" |
| T-SA-06 | Core spec + Draft entity + one API contract; Skipped includes architecture detail or says trivial single component, and includes saga, Kubernetes/deployment, and DR | Full security design, outbox, backup RPO, or a service split |
| T-SA-07 | Reads distributed guidance; states the failure (lost payment vs double charge); chooses or rejects saga/outbox with what is left behind; ADR if the choice is hard to reverse | "Use microservices and Kafka" with no loser/recovery story |
| T-SA-08 | `pharmacist` role, idempotency key, HTTP codes, and any `Submitted` status are Decision or Assumption. Verified/Dispensed and reject-when-no-stock trace to AC1/AC2. AC3 not invented | Those items written as if the BA Brief required them |
| T-SA-09 | Timeout does not mark Dispensed; no success audit row; caller can retry; local state named | Only "return 503" with no data-left-behind |
| T-SA-10 | Approved section with PK/FK, nullability, uniqueness, cardinality, delete, concurrency — or those cells are TBD with owners and `status` is not `ready` | `status: ready` on a Draft-only model |

## Provenance spot-check (T-SA-08)

BA stated: actor Pharmacist, states Verified and Dispensed, reject and stay Verified when stock is unavailable, allergy TBD, inventory as stock source (assumption), cancel-before-dispense as an exception.

BA did not state: auth role string, status `Submitted`, `Idempotency-Key` required, HTTP 422, HTTP 503.

## Depth spot-check (T-SA-06)

Skipped rows are required. Absence of a Kubernetes section is not a failure. Absence of a Skipped row that explains the omission is a failure, because the next reader cannot tell "considered" from "forgotten."
