# Database and API changes

Read only when the slice changes a schema, a migration, or a published request, response, or error. A pure in-process change does not load this file.

## Contract lock

The SA spec owns the contract: paths, fields, status codes, tables, and columns. You implement that contract.

- Do not add or rename a field, status, route, or column the spec does not state.
- If the spec and the brief disagree, stop that AC. Blocker to BA and SA. Do not pick a side in code.
- A contract change the spec did not approve is a blocker to SA. Do not implement it as an assumption. It becomes a `DEV-n` only after the user explicitly accepts that deviation. Say who accepted it. `status` stays `draft`. Do not mint `D-n` or `ADR-n`.
- No spec at all is not this file's path. Follow Input decision: stated ACs only, assumptions listed, `status: draft`.

## Schema

- Prefer expand, then switch readers, then contract. A migration that drops or renames in one step needs the spec or an explicit acceptance.
- Existing rows must still satisfy the constraints you add, or the migration backfills them in the same change.
- State the transaction boundary and what a failure leaves behind.
- State how to undo the migration (down step or forward fix). "We will restore a backup" is not a rollback plan unless the spec said so.
- Do not edit a migration that has already been applied in a shared environment. Add a new one. Ask if you cannot tell.

## API

- Request and response stay inside the published contract. Validate at the boundary the spec names.
- Unknown fields: follow the spec. If the spec is silent, reject or ignore the way the existing handlers already do, and write that as an assumption.
- Clients that already call this API must keep working, unless the user accepted a break as a `DEV-n`.
