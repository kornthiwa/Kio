# Dev and QA handoff

Use on Deep, or when the user asks for a handoff. Quick specs keep the short handoff in the core template.

The handoff tells Dev what is binding and tells QA what is observable. It also says where a later gap goes, so QA does not rewrite the requirement and does not file a business gap for an HTTP code the SA chose.

```markdown
## Handoff — Dev
- [ ] Entities and legal states are implementable (Draft or Approved, as the mode requires)
- [ ] API contracts include auth, validation, errors, idempotency
- [ ] Must AC flows covered, including reject paths
- [ ] Transaction boundary and race outcome stated where writes can collide
- [ ] Open decisions explicit; none of them are hidden inside "obvious" defaults
- [ ] Business rules still TBD are not implemented as if decided

### Implementation constraints
- Binding decisions: D-n / ADR-n — Dev does not swap status codes, states, or commit points
- Must not add: statuses, roles, or endpoints that are not in this spec
- Error envelope: shared shape; new codes need a spec update
- Retry safety: which calls are idempotent
- Config / secrets: names only; no values in code or in the spec

Status: Ready to build / Blocked (why)

## Handoff — QA
- [ ] Each Must AC has an observable result (status, body code, and stored row)
- [ ] State transitions listed, including illegal ones
- [ ] Negative cases listed with AC IDs
- [ ] Permission rules listed, each tagged Requirement or Decision
- [ ] Integration failures describe recovery and data left behind
- [ ] Test data listed for each negative case

### Testability
| AC or Decision | Setup data | Observable pass | If this fails, route to |
|----------------|------------|-----------------|-------------------------|
| US-1-AC1 | | | Dev (contradicts spec) |
| D2 error code | | | SA if the code is ambiguous; Dev if the code contradicts D2 |
| BA Q1 still open | | do not test | BA |

- Decisions are not requirement gaps. A wrong implementation of D2 is a bug against the spec.
- A missing business rule is a GAP to BA. Do not invent the expected result.
- An untestable sentence ("fast", "secure") is an SA gap: the NFR row needs a target or TBD, and this handoff stays Blocked.

Status: Ready for test design / Blocked (why)
```
