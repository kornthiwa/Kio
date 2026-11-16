# Integration contract

Use when P1-INT triggers (external system and Deep, or the user asks). On Quick, put owner, timeout, and recovery in the Failure table instead of this section.

One block per external system. This is the contract Dev codes against and QA fails when the dependency misbehaves. It is not a second copy of the BA integration name.

```markdown
## Integration — <system name>

- Direction: we call them / they call us / both
- Style: sync API / event — Decision or ADR
- Data we send:
- Data we receive:
- Owner of each dataset: (Assumption if BA did not say)
- Auth between parties: how the credential is obtained — not the secret value
- Timeout:
- Retry: count, backoff, which errors are retryable
- Idempotency of the outbound call:
- Version / compatibility: what we do when their contract changes — or TBD
- Failure recovery: user-visible result + data left behind
- Covers: US-…-AC… or N/A (technical dependency)
```

Do not put passwords, tokens, or connection strings in the spec. Name the secret's purpose and where it should live (`templates/security-design.md` or a one-line NFR if security design is skipped).
