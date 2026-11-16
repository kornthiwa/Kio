# Code quality

Apply these to the diff you just made. Match the surrounding code when it already has a house style. Do not restyle the repo.

- SOLID, DRY, and KISS where they make this change smaller. Do not restructure neighbors to illustrate a principle.
- Separation of concerns: business rule, I/O, and presentation stay where this repo already puts them.
- Explicit control flow. No new abstraction unless a second caller in this change needs it.
- Strong typing where the language already has it. Do not introduce `any` (or the local equivalent) to silence a checker.
- Errors are handled or propagated. No empty catch.
- External input is validated at the boundary the spec names. Do not add a second, conflicting validator.
- Do not copy a business rule into a second module. Call the existing one.
- No premature optimization. If you touch a query or a render path, check the items below and stop there.
- Reuse project utilities found during inspection.
- Functions stay on one job.

## Queries and rendering (only if this change touches them)

- A loop that issues one query per row is an N+1. Load the set the way this repo already does, or record a `DEV-n` if you cannot without a contract change.
- Do not retain a listener, timer, buffer, or handle past the operation. Clean it up on the failure path too.
- Do not add a render or a recompute that the existing state update already triggers.

## Not allowed in order to look finished

- Disabling a lint rule, a type error, or a test.
- A new base class, wrapper, or package with one caller.
