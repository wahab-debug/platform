# Runbook: Application Rollback (Argo Rollouts + Helm)

## Purpose
Provide a safe, repeatable process to rollback application deployments in dev/staging/prod with minimal downtime and clear verification steps.

## Preconditions
- You have cluster access (kubectl context set correctly).
- You know the target environment namespace: `dev`, `staging`, or `prod`.
- You have the rollout name and Helm release name.

---

## 1) Quick Triage Checklist (do this first)
1. Confirm correct context:
   - `kubectl config current-context`
2. Confirm namespace:
   - `kubectl get ns`
3. Check rollout status:
   - `kubectl argo rollouts get rollout <rollout-name> -n <namespace>`
4. Check pods and recent events:
   - `kubectl get pods -n <namespace>`
   - `kubectl describe pod <pod> -n <namespace>`
   - `kubectl get events -n <namespace> --sort-by=.lastTimestamp | tail -n 30`
5. Check ingress/LB health (symptoms):
   - `kubectl get ingress -n <namespace>`
6. Check alerts/dashboards:
   - Grafana: error rate, latency, saturation
   - CloudWatch: ALB 5xx, target health, container logs

---

## 2) Argo Rollouts Rollback (preferred)
### 2.1 Abort an in-progress rollout
- `kubectl argo rollouts abort <rollout-name> -n <namespace>`

### 2.2 Undo to the previous stable version
- `kubectl argo rollouts undo <rollout-name> -n <namespace>`

### 2.3 Verify traffic/stability
- `kubectl argo rollouts get rollout <rollout-name> -n <namespace>`
- Validate:
  - all pods Ready
  - error rate returns to baseline
  - latency returns to baseline
  - no new crash loops

---

## 3) Helm Rollback (secondary path)
Use this if:
- Argo Rollouts components are unhealthy, or
- configuration regressions require reverting chart values.

### 3.1 Identify release history
- `helm history <release-name> -n <namespace>`

### 3.2 Rollback to a known revision
- `helm rollback <release-name> <revision> -n <namespace>`

### 3.3 Verify
- `helm status <release-name> -n <namespace>`
- `kubectl get pods -n <namespace>`

---

## 4) Post-Rollback Actions
1. Open an incident note (even for practice):
   - what changed (commit/release)
   - impact
   - rollback method used
   - verification evidence (screenshots/metrics)
2. Create a follow-up task:
   - add missing alert/guardrail
   - fix readiness probe, resource limits, or failing dependency

---

## 5) Common Root Causes (quick mapping)
- CrashLoopBackOff: bad config, missing secret, incompatible image
- Readiness failing: dependency down, wrong port, probe too strict
- Elevated 5xx: app error, upstream dependency, misrouted ingress
- Latency spikes: CPU throttling, DB saturation, GC, insufficient resources
