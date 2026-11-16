# Security principles

Read with `templates/security-design.md` when P0-SEC triggers. Design rules only. Exploit steps, payloads, and bypass procedures do not belong in a system spec or in this note.

## Identity

- Authentication answers who is calling. Authorization answers what that caller may do.
- A BA actor ("pharmacist") is not an auth scheme. Mapping it to a role is `D-n`. Extra constraints the brief never stated (license number, department) go back to BA.
- Service-to-service calls need their own principal. Reusing the end user's session inside a backend hop is a Decision you must write down, not a default.

## Tokens and sessions

State where the credential is stored on the client, how long it lives, and what an expired credential does to an in-flight confirm. If those are unknown, `TBD` with an owner. Do not specify a library just to look complete.

## Data

- Classify fields the AC actually stores: public, internal, sensitive (PII, clinical, payment, credential).
- Sensitive data: encryption in transit, a stated at-rest choice or TBD, and log redaction. A Deep spec cannot be `ready` with clinical or payment fields logged in full.
- Secrets: name and purpose only. Values live in a secret store, not in the spec, source, or tickets.

## Trust

Draw the boundary at the network or process edge where untrusted input arrives. Validate there. Downstream code may assume the boundary already rejected malformed input — say that, so Dev does not validate in three conflicting places and QA does not have to guess which message is canonical.

## Audit

Audit events answer who did what to which record, and when. They are not a debug log. The BA word "audit" means at least that trail. Retention length is `TBD` unless the brief stated it.

## Injection and output

Parameterized data access and encoded output are the design expectation. Name the boundary. Do not include sample attack strings in the spec.
