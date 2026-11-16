# Database patterns

Read when choosing keys, indexes, delete behavior, or locking. The Approved table in `templates/database-design.md` is where the choice is recorded.

## Keys

- Surrogate primary key when the row is referenced by other tables.
- Unique business key when two actors must not create the same real-world thing (order number, idempotency key).
- Foreign keys for relationships the app relies on. State `ON DELETE` behavior; do not leave cascade as an accident.

## Cardinality

Write it as `1—1`, `1—*`, or `*—*`. A many-to-many needs a table the spec names. BA "has an audit record" is usually `1—*` append-only, not a column overwritten in place.

## Indexes

Index a filter or sort the API actually offers, or a uniqueness rule. "Index every column" slows writes and is not a strategy. Primary key lookup needs no extra index.

## Delete

| Policy | Use when | Cost |
|--------|----------|------|
| Hard delete | The row is not an audit and retention does not apply | Gone; say whether children block the delete |
| Soft delete | Users undo, or the business says "hide" | Every query must exclude the flag; unique keys must account for dead rows |
| Append-only | BA asked for an audit or a ledger | No update-in-place; corrections are new rows |

## Concurrency

| Situation | Approach |
|-----------|----------|
| Two requests, one status transition (dispense, pay, approve) | Conditional update (`WHERE status = expected`); loser gets a conflict, original row unchanged |
| Counters that must not go negative (stock) | Constraint plus a single statement, or one owner of the number — name which |
| Lost update on a form | Version column; stale version → conflict |

Pick one and name the loser's response. "Use a transaction" without the predicate does not stop two commits of the same transition.

## Migration

Greenfield: initial schema only. Existing data: expand then backfill then contract, and say whether the old app still writes during the backfill. If rollback of the migration is impossible, say so in the Dev handoff.
