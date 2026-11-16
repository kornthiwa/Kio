# Security checklist

Review questions only. Do not write exploit steps, payloads, or bypasses into the note or the code.

Read this file only when the change touches untrusted input, authentication, authorization, persistence, queries, HTML or templates, secrets, or an outbound call. Otherwise the Dev Note says `Security: N/A — <why>` and you do not load this file.

## Check the diff

- Untrusted input is validated at the existing boundary. New fields follow that pattern.
- Authentication and authorization checks that already guard the path are still on it. Do not add a second scheme.
- Queries stay parameterized the way the repo already queries. Output that reaches HTML uses the repo's existing encoding.
- Secrets and environment values are read from the existing mechanism. No secret literal in source, notes, logs, or tests.
- Logs and errors do not include passwords, tokens, or the sensitive fields the brief marked.
- API errors do not add a new status or body the spec did not define (that is a contract change).
- A multi-step write uses the transaction style already in that module. Say what remains if the write fails halfway.
- Handles and connections are released on the failure path.
- A retry cannot double-apply a confirm. Use the idempotency the spec already required, or record a blocker.
- A race the spec already named (double submit, lost update) still ends in the state the spec named.

## Rules

- Never hardcode a secret.
- Never weaken an existing control to make the slice pass.
- Never remove or skip an authorization check.
- Never log sensitive values, including as a temporary debug line.
- A security concern outside this slice is one line in Residual risk. Do not redesign the security architecture in the same change.
