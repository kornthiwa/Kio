# Architecture patterns

Read only when choosing a style (P0-A and the choice is not obvious). Default is one deployable, one datastore, synchronous calls. Record a split as an ADR.

| Signal | Prefer | Avoid |
|--------|--------|-------|
| One team, one Must flow, one store | Modular monolith / single service | A service per entity |
| An external system the AC already names | Sync call inside the use case, unless latency or availability forces otherwise | A bus "for later" |
| Independent release or a hard org/trust boundary | Separate deployable for that boundary only | Splitting tables that must commit together |
| Spiky read load on a slow query | Cache or read model, with an invalidation rule | Caching the write path by default |
| Long work the user does not wait for | Async job with a visible state | Async for a request/response AC that expects an immediate result |

## Communication

| Need | Pattern |
|------|---------|
| Caller must know success before continuing | Synchronous |
| Caller can proceed and learn the outcome from state | Asynchronous, and the spec names that state |
| Both sides must succeed or neither does, one database | One local transaction |
| Both sides must succeed or neither does, two services | See `distributed-systems.md` — do not pretend a sync HTTP chain is a transaction |

## Deployment boundary

A boundary is a process, a network trust edge, or a team that releases alone. "We might use Kubernetes" is not a boundary. Name the units you actually ship.

## Technology

Choose a technology when the user named one, an existing system already uses one, or an NFR rules the others out. Otherwise `TBD`. The reason belongs in the table, not in a brand name picked for familiarity.
