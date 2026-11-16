# NFR checklist

Replace the core spec's Non-functionals section with this table. A row without a target is unfinished. Use `TBD` with an owner when the number is unknown. Use `N/A` with a reason when the concern does not apply. Do not mark Done without a way to verify.

```markdown
## Non-functionals
| Item | Target | How to verify | Status |
|------|--------|---------------|--------|
| Authentication | | who can call; unauthenticated result | Done / TBD / N/A |
| Authorization | | role or rule; forbidden result | |
| Validation and errors | shared envelope in API policy | invalid body → named code | |
| Audit | which actions write a trail | row exists after success; absent after reject | |
| Idempotency | per write endpoint | replay does not double-apply | |
| Timeouts and retries | per external call | timeout leaves local state unchanged | |
| Response time | e.g. p95 < TBD ms for the Must path | measurement method or TBD | |
| Throughput / concurrency | users or requests, or TBD | | |
| Capacity | data growth, or TBD | | |
| Cache | choice + invalidation, or N/A | | |
| Availability | target or TBD | | |
```

Performance rows may all be `TBD` on Quick. That is honest. Inventing "10k concurrent users" is not.

Security mechanism detail belongs in `security-design.md` when P0-SEC triggers. This table still states the target (who may call, what is audited) so a reader who skips the security section sees the requirement.

Backup RPO/RTO belong here only when P1-OPS includes backup. Otherwise N/A — "no production handoff yet."
