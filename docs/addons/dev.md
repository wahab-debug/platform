# Add-ons Manifest — Dev

Install order (platform-managed):

1. Namespaces (platform)
2. AWS Load Balancer Controller
3. metrics-server
4. Fluent Bit (CloudWatch)
5. Argo Rollouts

Notes:
- Dev can tolerate minimal HA.
- Promotion gates are handled in CI/CD, not here.
