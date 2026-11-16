# ADR section

Use when a choice is hard to reverse: datastore, splitting or merging a service, synchronous API vs events, or the consistency model. Idempotency headers, HTTP codes, and index choices stay as `D-n` in Provenance unless changing them forces a rewrite of the boundary.

Keep ADRs inside `sa.spec.md`. They are how the next reader learns why — Alternatives already hold the comparison; the ADR holds the outcome.

```markdown
## ADR-n: <decision in one line>

- Status: proposed | accepted | superseded by ADR-m
- Context: constraint and AC IDs, not a restatement of the whole spec
- Options: A, B (same ones as Alternatives)
- Decision:
- Consequences: what becomes easier, what we accept as pain
- Revisit when:
```

One ADR per decision. Do not write ADR-001 "use a database" for a CRUD app with a single obvious store — that is "trivial: single path."
