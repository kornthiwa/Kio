# Sequence section

Use when P0-S triggers. One diagram per critical flow that crosses a component or can fail. A single in-process step stays a numbered list in Critical flows.

Show the happy path and the failure path that a Must AC or a Decision cares about. Name the transaction boundary on the diagram (where the local commit happens) so a timeout cannot be read as "already saved."

Emit this section:

## Sequences

### SD-1 <flow name>
Covers: US-…-AC…

```mermaid
sequenceDiagram
  actor Actor
  participant App
  participant DB
  participant Ext
  Actor->>App: request
  App->>Ext: call
  Ext-->>App: ok or timeout
  App->>DB: commit only after success
  App-->>Actor: response
```

- Request → processing → response:
- Transaction boundary: commit point; what is rolled back on failure
- Retry: who retries, with which idempotency key
- Error path: status/code, and data left behind

If this diagram already includes the datastore and the external system, skip a separate data-flow section and say so in Skipped: "covered by SD-1."
