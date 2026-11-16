# API contract

Use for every in-scope endpoint or synchronous service interface. Quick may use field names and types. Deep adds validation rules. Conventions, when you need them: `references/api-design-standards.md`.

One shared error envelope per spec. Endpoints list their codes; they do not invent a second error shape.

```markdown
## Shared error envelope
HTTP status carries transport outcome. `code` is the stable string QA asserts on.

{
  "error": {
    "code": "STOCK_UNAVAILABLE",
    "message": "Human-readable, not a stack trace",
    "retryable": false,
    "details": {}
  }
}

| HTTP | code | retryable | When | Decision |
|------|------|-----------|------|----------|
| 400 | VALIDATION | no | malformed input | |
| 401 | UNAUTHENTICATED | no | | |
| 403 | FORBIDDEN | no | | |
| 404 | NOT_FOUND | no | | |
| 409 | CONFLICT | no | state / idempotency clash | |
| 422 | <business code> | no | rule failed, syntax was valid | |
| 503 | <dependency code> | yes | upstream timeout or down | |

Omit rows you do not use. 422 vs 409 is a Decision even when the BA AC says "reject."

## API policy
- Versioning: `/v1` for an external or multi-client API; unversioned for one internal caller — record D-n
- Pagination / filter / sort: default for collection GETs (limit, cursor or page, sort). N/A if there is no collection endpoint
- Rate limit: N/A for a single internal caller; a Decision if the API is public or multi-tenant
- Auth: scheme + who may call. Mapping a BA actor to a role is a Decision

### <METHOD> <path>
- Auth:
- Path / query / headers:
- Body fields: name, type, required, validation
- Response: success status + body fields
- Errors: codes from the envelope that this endpoint actually returns
- Idempotency: required key / natural key / not required — Decision, or N/A for a pure read. Money, inventory, and clinical creates must record a choice; do not leave them blank
- Covers: US-?-AC?
```

A BA AC that says "the system rejects" is covered by the error row's *when* clause. The HTTP number and `code` string stay in the Decision column.

Service interfaces that are not HTTP (queue handler, CLI) use the same headings with protocol-specific words. Do not invent a REST API the system does not have.
