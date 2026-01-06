# Alerting Strategy

Goals:
- Alert on symptoms, not causes
- Reduce alert fatigue
- Page humans only when action is required

Initial alerts:
- Pod CrashLoopBackOff > 5m
- Deployment unavailable replicas
- Node NotReady
- High 5xx rate at ingress
- Sustained high latency (p95)

Non-goals (initially):
- CPU spikes
- Short-lived pod restarts
- Transient network errors

Routing:
- Dev: log-only
- Staging: Slack/email
- Prod: paging (simulated)
