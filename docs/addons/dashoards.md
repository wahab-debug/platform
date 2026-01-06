# Grafana Dashboards Strategy

Baseline dashboards:
- Kubernetes cluster overview
- Node resource usage
- Pod CPU/memory
- Namespace-level utilization
- Application request rate / error rate / latency

Sources:
- kube-state-metrics
- node-exporter
- application /metrics endpoints

Principles:
- Prefer RED metrics for services
- Prefer USE metrics for infrastructure
- Avoid per-pod dashboards in prod (noise)
