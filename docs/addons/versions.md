# Add-ons Version Pinning

All add-ons are installed with pinned chart versions.

Recommended initial pins (update as needed):
- AWS Load Balancer Controller Helm chart: (to be pinned during install step)
- Argo Rollouts Helm chart: (to be pinned during install step)
- metrics-server: (to be pinned during install step)
- Fluent Bit: (to be pinned during install step)

Rationale:
- deterministic installs
- controlled upgrades
- easier rollback and audit
