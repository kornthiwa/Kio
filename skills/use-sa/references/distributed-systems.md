# Distributed systems

Read only when more than one service, async messaging, or a write across stores is actually in the design. A single process with one database does not get a saga. Skip the section and write "single process."

Evaluate the problem first. Naming a pattern is not a reason to use it.

| Problem | Consider | Do not use when |
|---------|----------|-----------------|
| Two writes in one database must agree | One local transaction | The writes are in different services — a transaction does not cross them |
| A local write and an outbound message must agree | Outbox: commit the row and the message together, publish after | There is no message bus |
| Several services each have a local transaction | Saga: forward steps plus a compensating action the spec names | You can keep one database and one service instead |
| Readers can tolerate lag | Eventual consistency, with the max lag or "TBD" | A Must AC says the caller reads the new state immediately |
| The same message arrives twice | Idempotent consumer and a dedupe key | You have not said what the key is |
| Order matters | Partition or sequence key, and what reordering does | The AC is a single synchronous call |
| A message cannot be processed | Dead letter plus an alert; say whether the business state stays incomplete | There is no queue |
| Two workers take the same job | Conditional lock or lease; loser backs off | One worker |

## What the spec must say if a pattern is used

- The step that commits first
- The compensation or the retry
- The state a human sees in the middle
- How a duplicate is detected
- What is left behind if the process stops halfway

## What to say if a pattern is rejected

"Rejected saga: Must AC is one confirm and one store (ADR-n)." Rejection is a result. It belongs in Alternatives or a one-line consistency note so the next reader does not add the pattern in implementation.
