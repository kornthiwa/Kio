# Observability

Read when P1-OPS triggers, or the user asks how the running system will be seen. Pair with the Operations section. Do not add a tracing vendor by default.

Design the signals around failures the spec already named (timeouts, rejected confirms, dead letters). A dashboard with no question is noise.

| Signal | Include | Minimum |
|--------|---------|---------|
| Structured log | Always when there is a service | timestamp, severity, message, request id; no secrets; no full sensitive payloads |
| Correlation id | Any call that crosses a process, including one external HTTP call | Same id on inbound, outbound, and the log line of the error |
| Metrics | An NFR has a numeric target, or a dependency can time out | count and latency of the Must path; error count by `code`; dependency timeout count |
| Trace | More than one service | The hop that failed; N/A for one process if logs already carry the request id |
| Health | Something deploys and receives traffic | Liveness = process up. Readiness = ready for traffic (database or a required dependency, if the spec says traffic should stop without it) |
| Alert | Production handoff | The condition (symptom, not a cause guess), and TBD owner if the team is unknown |

## How this ties to NFR

Each NFR row that says "how to verify" should point at a signal above or at a test. "We will monitor it" is not a verification method.

## What not to add

- Log every field of a clinical or payment body.
- A second correlation id per layer.
- Alerts on all 4xx. Alert on reject paths that mean data risk (stock went negative, duplicate dispense) and on dependency failures that leave work stuck.
