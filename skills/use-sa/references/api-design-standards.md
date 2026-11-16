# API design standards

Read when an endpoint's conventions are not already fixed by the existing system. The form to fill is `templates/api-contract.md`. Match the codebase if one exists; do not introduce a second style in the same spec.

## Defaults

- Nouns for resources, HTTP method for the action. A command that is not CRUD (`dispense`, `submit`) may be a POST on a subpath. Say which AC it covers.
- External or multi-client APIs: prefix `/v1`. One internal caller: unversioned is fine — record `D-n`.
- Collection GET: `limit` plus cursor or page, a default sort, and the filter fields the AC needs. No collection endpoint → pagination N/A.
- Write responses name the resulting state, not only "ok".
- Idempotency: header or natural business key for creates and confirms that move money, stock, or clinical state. Reads: N/A. The choice is a Decision even when you require the key.

## Errors

One envelope for the spec:

- `code` — stable, asserted by tests
- `message` — safe to show
- `retryable` — true only when a retry with the same idempotency key is safe
- `details` — field errors for validation; empty otherwise

Use 401 for missing identity, 403 for identity that must not do this, 404 when hiding existence matters more than 403 (say which), 409 for state conflicts, 422 for a business rule on a well-formed request, 503 for a dependency the caller may retry. The BA word "reject" does not pick the number.

## Compatibility

Adding an optional field is compatible. Renaming, removing, or changing a code string is not — that is a version or an ADR. Do not silently overload a code for two meanings.

## Rate limits

Public or multi-tenant: state the limit or TBD. Internal single caller: N/A.
