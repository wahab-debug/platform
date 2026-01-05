# Add-ons Manifest — Staging

Install order (platform-managed):

1. Namespaces (platform)
2. AWS Load Balancer Controller
3. metrics-server
4. Fluent Bit (CloudWatch)
5. Argo Rollouts

Notes:
- Staging should mimic prod configuration as closely as practical.
- Use staging to validate rollouts, dashboards, and alerting.
