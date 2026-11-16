# Security design section

Use when P0-SEC triggers. Otherwise the NFR auth row is enough — do not paste this section as a wall of TBDs.

This is design-time structure, not a penetration test and not production code. Read `references/security-principles.md` before inventing a token scheme. A code audit belongs to `security-audit-by-cloudflare`, not this skill.

Map BA actors to principals only as Decisions. If the brief does not say who is forbidden, ask BA or mark the rule TBD. Do not invent "only pharmacists" as a Requirement when the story merely uses a pharmacist as the actor.

```markdown
## Security

### Trust boundary
- Inside:
- Outside:
- Data that crosses:

### Authentication
- Who proves identity:
- Flow: (login, session, service credential) — Decision or TBD
- Token or session lifetime: TBD is acceptable
- What happens when the credential expires mid-action:

### Authorization
| Action | Allowed principal | Source |
|--------|-------------------|--------|
| | | Requirement US-… or Decision D-n |

### Sensitive data
| Field | Why sensitive | At rest | In transit | In logs |
|-------|---------------|---------|------------|---------|
| | | encrypt / N/A | TLS / N/A | redact |

### Secrets
- Which secrets exist (names and purpose only):
- Where they live: not in the spec, not in source
- Rotation: TBD or a stated approach

### Input and injection
- Validation site: (API boundary)
- Untrusted data is not concatenated into queries, commands, or HTML — state the binding approach at design level

### Audit
- Events recorded:
- Who can read the trail:
- What is not stored (secrets, full clinical payload) :
```

Clinical, payment, and credential fields cannot be "logs: TBD" on a Deep spec that is `ready`. Say redact, or block readiness.
