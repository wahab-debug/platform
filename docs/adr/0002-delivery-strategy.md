# ADR 0002: Delivery Strategy, Blue/Green Rollouts, and Promotion Gates

## Status
Accepted

## Context
We want production-grade delivery practices, including progressive delivery, controlled promotion, rapid rollback, and evidence-based decisions via metrics/health signals.

## Decision
1. **Progressive delivery using Argo Rollouts**
   - Argo Rollouts will manage blue/green rollouts for the application.
   - Traffic shifting is controlled via the ingress/load balancer integration.

2. **Environment promotion gates**
   - Dev: automatic deploy on merge to main (or development branch) after CI passes.
   - Staging: deploy requires approval (manual gate) after CI passes.
   - Prod: deploy requires approval + change log/release note reference.

3. **Rollback strategy**
   - Primary: Argo Rollouts undo/promote controls for quick rollback.
   - Secondary: Helm rollback to last known good release.
   - Rollback triggers include:
     - elevated 5xx rate
     - latency regression
     - readiness failures
     - alert firing tied to SLO-like thresholds

4. **Artifact immutability**
   - All deployments use immutable container images (tagged by commit SHA).
   - Helm values reference the immutable tag, not `latest`.

## Consequences
- Argo Rollouts adds operational components but provides strong learning and production parity.
- Requires defining health checks, alerts, and measurable rollout criteria early.

## Alternatives Considered
- Manual Service selector switch:
  - Simple but limited automation and weaker production realism.
- Canary only:
  - Useful, but blue/green aligns better with your stated objective and demo story.
