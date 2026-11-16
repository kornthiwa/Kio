# Operations section

Use only when P1-OPS triggers. Early design and ordinary CRUD skip this and say why.

Infrastructure drawings stop at what Dev and ops need to deploy and undo. Do not specify a Kubernetes distribution, cloud account, or cluster size unless the user already chose one.

Observability detail: `references/observability.md`. Pull in only the rows that match this system's failure modes.

```markdown
## Operations

### Environments
| Env | Purpose | Data | Integrates with |
|-----|---------|------|-----------------|
| local | | synthetic | stub / real |
| dev | | | |
| uat | | | |
| production | | | |

Omit environments the user does not have. Do not invent a UAT stage for a single-user script.

### Deploy and rollback
- Unit of deploy: (the deployable from Architecture)
- Strategy: recreate / rolling / expand-contract — Decision
- Config that changes per env: names only, no secret values
- Rollback: how, and which schema or migration cannot roll back
- Health: liveness vs readiness — what readiness refuses traffic for

### Observability
| Signal | What | Correlation |
|--------|------|-------------|
| Log | structured fields, no secrets | request id |
| Metric | the few that match NFRs | |
| Trace | across services, or N/A if one process | |
| Alert | condition + who — or TBD | |

### Backup and recovery
Include only when production persists data the user cannot recreate by hand.

| Concern | Target |
|---------|--------|
| Backup | what, how often |
| RPO | max data loss | 
| RTO | max time to serve again |
| Restore check | how we know a backup opens |
| Disaster | the scenario this covers, or TBD |

If RPO/RTO are unknown, write TBD with an owner. Do not default them to zero.
```
