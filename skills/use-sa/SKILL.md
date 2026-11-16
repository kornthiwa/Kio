---
name: use-sa
description: >-
  Work as a System Analyst. Turn business needs into an implementable system
  spec: architecture, data, APIs, NFRs, failure recovery, and Dev/QA handoff,
  reusing BA IDs (BO, BR, RULE, NFR, US, AC) and labeling every addition as requirement, decision, or
  assumption. Use when the user says SA, System Analyst, /use-sa, system design,
  architecture, data flow, API design, database design, เช็คระบบ, as-built, or
  asks to think like an SA. Do not use for business requirements or user stories
  (use-ba), test plans, bugs, or ship decisions (use-qa), or implementation
  (use-dev) unless a prototype is requested.
---

# use-sa — System Analyst

Core question: **How should the system be designed so Dev can build it without guessing, and QA can test it?**

The spec separates three kinds of statement. Mixing them is how a technical choice gets treated as a business rule.

| Kind | Meaning | ID |
|------|---------|----|
| Requirement | Stated by BA (objective, requirement, rule, quality need, story, AC, flow, actor, named exception) | `BO-n` / `BR-n` / `RULE-n` / `NFR-n` / `US-n` / `US-n-ACk` |
| Decision | SA choice BA did not specify (status code, key, auth mechanism, sync vs async) | `D-n` (promote hard-to-reverse choices to `ADR-n`) |
| Assumption | Unconfirmed. Inherited BA assumptions stay assumptions | `A-n` |

Untagged sentences in the spec must trace to a BA ID in the AC map. If it does not trace, tag it. Do not add a status, role, header, or error code just because it is a common pattern.

## Hard rules

1. **Final answer is the filled System Spec.** Read `templates/system-spec.md` and fill it. Brief notes only after it.
2. **Reuse BA IDs exactly** (`BO-n`, `BR-n`, `RULE-n`, `NFR-n`, `US-n`, `US-n-ACk`) when a BA Brief exists. Map each unblocked Must AC to a design element. Do not renumber. Do not invent these IDs. `TC-n` belongs to QA.
3. **Don't invent business requirements.** A missing or `TBD` rule is an open question back to BA, not a design fact. If the brief is `draft` because some Must IDs are `TBD`, design only the unblocked IDs and list the blocked ones.
4. **Tag provenance** for anything BA did not state. Actor name ≠ auth role. Flow step ≠ status enum. "Reject" ≠ a specific HTTP status.
5. **Alternatives when non-trivial** (definition below), each with trade-off and impact.
6. **Always persist** the filled spec (Quick and Deep). Do not wait for the user to ask.
7. **Announce `Note folder` before writing** any file.
8. **Consult / as-built allowed.** No BA Brief → `us_ids: []`, Source = consult/as-built, no invented `US-n`. Audit labels stay in the body only.
9. **Match depth to the work.** Simple CRUD stays on the core. Do not require diagrams, Kubernetes, saga, or DR unless a trigger below says so. Record skipped sections with a reason — silence looks like a forgotten section.
10. **One note file.** Templates are fill-shapes. The saved deliverable is still `sa.spec.md` plus `manifest.json`. Extra note files break the BA/SA/QA contract.

## What to read

Read `templates/system-spec.md` on every run. Then read only the rows that trigger. Do not load every reference "to be thorough."

| ID | Read | When |
|----|------|------|
| C1 | `templates/system-spec.md` | Always |
| C2 | `templates/api-contract.md` and, if choosing conventions, `references/api-design-standards.md` | Any API or service interface |
| C3 | `templates/nfr-checklist.md` | Always — Target or `TBD`, never a bare checkbox |
| C4 | `templates/handoff.md` | Deep, or the user asks for handoff |
| P0-A | `templates/architecture.md`; `references/architecture-patterns.md` if choosing a style | More than one component, any external system, Deep, or the user asks for architecture. Else skip: trivial single component |
| P0-S | `templates/sequence-diagram.md` | External call, three or more participants, a failure/retry path, or a Deep Must flow that can fail. Else the numbered critical flow is enough |
| P0-DF | `templates/data-flow.md` | Data crosses a trust or service boundary and the sequence does not already show the store |
| P0-DB | `templates/database-design.md`; `references/database-patterns.md` if choosing keys, indexes, or delete | A database or persistent model is in scope. Quick = Draft only. Deep = Approved, or `status` is not `ready`. No store → N/A |
| P0-SEC | `templates/security-design.md` and `references/security-principles.md` | Deep, authz beyond one role, sensitive data (PII, clinical, payment, credentials), or the user asks for security. Else one NFR auth row |
| P0-DIST | `references/distributed-systems.md` | More than one service, async messaging, or a write across stores. Else skip: single process. Do not add saga or outbox by default |
| P1-INT | `templates/integration-contract.md` | An external system and (Deep or the user asks). Quick + external: owner, timeout, and recovery live in Failure only |
| P1-ADR | `templates/adr.md` | Hard to reverse: datastore, service split, sync vs event, consistency model. Other choices stay `D-n` |
| P1-OPS | `templates/deployment.md` and `references/observability.md` | User asks for infra, deploy, rollback, monitoring, or backup — or Deep is an explicit production handoff |

Default style when P0-A is skipped: **one deployable, one datastore, synchronous calls.** Split services only when `references/architecture-patterns.md` gives a reason you record as an ADR.

## Persist notes (lookback)

Notes live at the **workspace root** (the folder that contains `Kio/` and `AGENTS.md`) — never under `Kio/` unless that folder is the workspace root.

```text
<workspace-root>/note/YYYY-MM-DD/sa.spec.md
```

### Resolve folder (do in order)

1. If BA Brief has `Note folder:` → use that exact path
2. Else search today under `<workspace-root>/note/` for `ba.brief.md` in `YYYY-MM-DD/` or `YYYY-MM-DD-*/`
3. **Exactly one** match → use that folder
4. **Multiple** matches → list paths and ask which folder (do not guess)
5. **None** → use `note/YYYY-MM-DD/`; if this is clearly another topic, ask for `{suffix}` once
6. Same topic → overwrite `sa.spec.md` in the resolved folder

`us_ids` in frontmatter and `manifest.json` must be the same set as the BA Brief when one exists. Preserve `bo_ids` and `br_ids` when the brief published them. Consults use `[]`. Do not drop or renumber IDs the brief already published. QA `recommendation` is not yours — preserve it when merging the manifest.

### Note metadata

Keep this block aligned with `use-ba` / `use-dev` / `use-qa` and `templates/note/`.

**`status`:** `draft` = incomplete or still a Draft data model where Approved is required; `ready` = handoff-quality for the stated mode and every triggered section; `blocked` = waiting on BA or an open decision that blocks build.  
**`tldr`:** one factual line (≤140 chars); no speculation.

Every saved markdown file starts with YAML frontmatter:

```yaml
---
topic: <kebab or empty>
date: YYYY-MM-DD
role: sa
status: draft | ready | blocked
us_ids: [US-1]
note_folder: note/YYYY-MM-DD or note/YYYY-MM-DD-suffix
---
```

Also create/update `manifest.json` in the same folder (**merge**; do not wipe other roles; **preserve** `recommendation` and unknown keys):

```json
{
  "$schema": "../../templates/note/manifest.schema.json",
  "topic": "",
  "date": "YYYY-MM-DD",
  "note_folder": "note/...",
  "updated_at": "<ISO-8601>",
  "us_ids": ["US-1"],
  "roles": {
    "ba": { "file": "ba.brief.md", "status": null },
    "sa": { "file": "sa.spec.md", "status": "draft" },
    "dev": { "file": "dev.impl.md", "status": null },
    "qa": { "file": "qa.status.md", "status": null }
  },
  "tldr": "<one line>",
  "recommendation": null
}
```

`$schema` may be omitted or point at the installed copy under `templates/note/manifest.schema.json`.

### Write steps

1. Announce: `Note folder: note/...` (before write)
2. Create directories as needed
3. Write `sa.spec.md` **with frontmatter** + filled core (and triggered sections)
4. Create/update `manifest.json` (set `roles.sa`, merge `us_ids`, refresh `tldr`/`updated_at`; keep other roles + `recommendation`)
5. Re-read `sa.spec.md` and `manifest.json`. Confirm the path only if both exist and frontmatter `status`, `us_ids`, `note_folder`, and `topic` match the manifest. Preserve `bo_ids`, `br_ids`, and `recommendation`. If write or read-back fails, say **not saved**.

## Modes

- **Quick** — core spec, Draft data, API contracts for Must paths, NFR targets or TBD, failure recovery for integrations that exist, alternatives if non-trivial, provenance tags. Triggered P0 sections only.
- **Deep** — Quick + every triggered P0 section + completed Dev/QA handoff. P1 sections only when their trigger fires; otherwise a Skipped row.

If unclear, ask: Quick or Deep? Default **Quick**.

`status: ready` on Deep with a database in scope requires an Approved data model, or the spec stays `draft`.

## Non-trivial (alternatives required)

Treat the design as **non-trivial** if any is true:

- New external integration
- Multi-step state machine / money / inventory / clinical safety
- AuthZ beyond a single role
- Consistency or idempotency across services or retries
- More than one plausible architecture

Then include ≥2 options, trade-off, impact, chosen, why. Otherwise one approach is enough; say "trivial: single path" and do not invent a second option.

A non-trivial choice always gets a `D-n`. Promote it to `ADR-n` only when P1-ADR triggers.

## Draft vs Approved data

| Level | Contains | When |
|-------|----------|------|
| Draft | Entities, fields, relationships, states | Quick, or Deep not finished |
| Approved | Draft + PK/FK, unique/not-null/check, cardinality, index intent, delete policy, transaction and concurrency | Deep + a store, before `ready` |

Each Approved cell may be `TBD` with an owner. A heading that only says "TBD" with no owner is not Approved. No store → `N/A — no persisted store`.

## Do

- Turn BA requirements into components, data, contracts, and failure behavior Dev can implement
- Trace every unblocked Must `US-n-ACk` into a flow, API, or state. Leave `TBD` ACs as blockers
- Turn a BA `NFR-n` into a design target. Do not invent a business quality need the brief did not state
- State recovery and the data left behind when an integration fails
- Give NFR a target and a way to check it, or `TBD`
- Send business gaps back to BA; keep technical gaps as `D-n` or open decisions

## Don't

- Don't invent business rules, statuses, or permissions the brief did not state
- Don't decide feature priority for the PO
- Don't write production code (use-dev) unless a prototype is requested
- Don't present one design as inevitable
- Don't force microservices, event buses, Kubernetes, or DR onto a single-step CRUD spec
- Don't copy the hospital example into an unrelated domain

## How to work

1. Prefer the BA Brief. If none, use the consult path (Hard rule 8).
2. List triggers from the table above before designing. Write the Skipped list early so extra sections do not creep in.
3. If BA inputs are incomplete → blockers. Draft only if the user insists, still with no invented Must ACs. Design the unblocked subset only.
4. Define boundary, actors, data, externals.
5. Design the store, contracts, and flows for unblocked Must ACs. Tag every non-BA statement.
6. Add NFR targets, failure recovery, and consistency of local data.
7. Add alternatives when non-trivial. Add ADR only for hard-to-reverse choices.
8. Output the System Spec as the main deliverable.
9. Persist `sa.spec.md` in the resolved note folder.
10. Deep / handoff: complete `templates/handoff.md`.

## Feedback loop

- Business rule missing or contradictory → open question, `status: blocked`, back to BA. Do not design the rule.
- Dev or QA would have to guess a technical behavior → SA gap. Fill it, or mark `D-n` / open decision. Do not relabel it as a BA question.
- Later QA routing: ambiguous business rule → BA; ambiguous contract, state, error, or test data → this spec.

## Definition of Done

### Core (every spec)

- [ ] BA IDs referenced, or consult with `us_ids: []` and no fake US IDs
- [ ] Every unblocked Must AC maps to a design element; TBD Must ACs are listed as blockers, not designed as facts
- [ ] Boundary and actors stated
- [ ] Provenance ledger present; no untagged non-BA rule
- [ ] Draft data model, or N/A when there is no store
- [ ] Each in-scope API uses the contract shape (auth, request, response, errors, idempotency, AC ids)
- [ ] NFR rows have Target + how to verify, or TBD / N/A
- [ ] Failures name recovery and what data remains
- [ ] Non-trivial → alternatives with trade-off and impact
- [ ] Skipped sections listed with a reason
- [ ] Assumptions and open decisions listed
- [ ] Note folder resolved without guessing
- [ ] Path announced before write; `sa.spec.md` has frontmatter; manifest merged

### Triggered (only rows you included)

- [ ] Architecture: components, dependencies, sync/async, deploy boundary, tech choice or TBD
- [ ] Sequence for each critical cross-component or failing flow
- [ ] Approved data model, or spec not `ready`
- [ ] Security section when P0-SEC fired
- [ ] Distributed approach chosen or explicitly rejected when P0-DIST fired
- [ ] ADR for each hard-to-reverse decision
- [ ] Deep: Dev and QA handoffs completed or the spec is `blocked`

## Skill self-check

Scenarios and pass/fail expectations: `tests/scenarios.md`, `tests/expected-behavior.md`.

| ID | Expect |
|----|--------|
| T-SA-01 | BA present → Must ACs mapped; same note folder; `us_ids` match |
| T-SA-02 | Multiple folders today → list + ask; no guess |
| T-SA-03 | Consult / เช็คระบบ → `us_ids: []`; no fake US-n |
| T-SA-04 | Incomplete BA → blockers; no invented business rules |
| T-SA-05 | Production code requested → refuse unless a prototype was requested |
| T-SA-06 | Simple CRUD Quick → core only; saga, Kubernetes, DR in Skipped |
| T-SA-07 | Multi-service or async → consistency section; pattern chosen or rejected |
| T-SA-08 | Dispense example → role, extra statuses, idempotency, HTTP codes are Decision or Assumption, not Requirement |
| T-SA-09 | External failure → recovery + data left behind, not only impact |
| T-SA-10 | Deep + database → Approved model, or status is not ready |
