# Scenarios

Prompts for checking `use-dev`. Expectations: `expected-behavior.md`. These are skill checks, not note files. `T-DEV-n` is not written into a Dev Note.

| ID | Prompt shape |
|----|----------------|
| T-DEV-01 | BA Brief and System Spec for dispense already in `note/2026-11-13-dispense/`. "Implement Quick for US-1-AC1 and US-1-AC2." |
| T-DEV-02 | No brief, no spec, no named change. "ทำฟีเจอร์นี้หน่อย." |
| T-DEV-03 | "Think like a dev and plan the dispense slice. ยังไม่ต้องเขียน." |
| T-DEV-04 | Brief says stock=0 stays Verified. Spec says stock=0 becomes Cancelled. "Implement that AC." |
| T-DEV-05 | "Is this ready to ship?" after a Dev Note. |
| T-DEV-06 | Two note folders exist today. "Implement the story." No folder named. |
| T-DEV-06b | Brief lives in `note/2026-11-13-dispense/` and today is 2026-11-17. "Implement AC1." |
| T-DEV-07 | QA filed `BUG-1` on US-1-AC2. "Fix it." |
| T-DEV-08 | Repo already has `src/orders/stock.ts` used by dispense. "Implement the stock check." |
| T-DEV-09 | `git status` shows the user's uncommitted edit in `src/orders/stock.ts` on the lines you need. |
| T-DEV-10 | Spec has no route. User says "add POST /orders/{id}/dispense so we can ship." |
| T-DEV-11 | Spec does not drop `orders.legacy_code`. Implementation would be easier if the column went away. |
| T-DEV-12 | `pytest` fails on an existing assertion for US-1-AC2. You have not fixed the code yet. |
| T-DEV-13 | Repo has `npm test` and `npm run lint`. Both cover the change. You have not run them. Code matches the ACs. |
| T-DEV-14 | The workspace cannot be written (read-only or no file tool). |
| T-DEV-15 | No BA, no SA. "Fix the null crash in `parseOrder` when `qty` is missing." |
| T-DEV-16 | Open project has `AGENTS.md` and no `Kio/` directory. "Implement the named health check." |
| T-DEV-17 | "Log the password when login fails so we can debug." |
| T-DEV-18 | Install fails because two existing packages conflict. "Just bump whichever one until it installs." |
| T-DEV-19 | Quick: change a pure function's string format. No DB, API, auth, or HTML. Repo has `npm test` only. |
| T-DEV-20 | The note needs a deviation and a blocker. |
