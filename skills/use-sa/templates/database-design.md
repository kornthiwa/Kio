# Database design section

Use when a persisted model is in scope.

- **Quick:** fill Draft in the core spec only. Do not pretend it is Approved.
- **Deep:** fill Approved below before `status: ready`. Each cell is a concrete rule or `TBD` with an owner.
- **No store:** do not use this file. Core says `N/A — no persisted store`.

Read `references/database-patterns.md` when choosing keys, indexes, delete, or locking. Do not add an index or a soft-delete column without a reason in the table.

States in Approved must match Draft. A new state here is a new Decision, or it does not belong.

```markdown
## Data model — Approved

### Entity: <Name>
| Field | Type | Null | Key | Constraint | Notes |
|-------|------|------|-----|------------|-------|
| id | | no | PK | | |
| | | | FK → | | |

- Cardinality: (e.g. Order 1 — * DispenseRecord)
- Unique: (business key, not only the surrogate id)
- Delete: hard / soft / append-only — and why
- States: allowed values and which transitions are legal
- Covers: US-…-AC…

### Access
| Query or write | Filter | Index intent |
|----------------|--------|--------------|
| | | PK only / add index because … |

### Transaction and concurrency
- Transaction boundary: which writes commit together
- Concurrent update: optimistic version / conditional status update / single-threaded — Decision id
- What the loser of a race observes (status code + unchanged data)

### Migration
- Greenfield: initial schema only
- Existing data: backfill, dual-read, or expand-contract — or TBD with owner
- Rollback of the schema: possible / not possible
```

Clinical, money, and inventory tables: say whether a row is updated in place or an audit row is appended. "Audit" in a BA AC is not automatically a soft-delete flag.
