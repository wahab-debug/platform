# Platform Standards

## Project Identity
- Project slug: `lab-platform`
- Repository name: `platform` (monorepo)

## Environments
- `dev`
- `staging`
- `prod`

## Naming Convention
Format:
- `{project}-{env}-{component}`

Examples:
- `lab-platform-dev-vpc`
- `lab-platform-staging-eks`
- `lab-platform-prod-alb-controller`

## Tagging Standard (AWS)
Apply to all supported AWS resources:
- `Project=lab-platform`
- `Environment=dev|staging|prod`
- `Owner=<your-name-or-team>`
- `CostCenter=<optional>`
- `ManagedBy=terraform`

## Branching & Releases (suggested)
- `main`: protected, deployable
- feature branches: PR required
- releases tagged: `vX.Y.Z` (optional)

## Security Baseline (minimum)
- IAM least privilege, prefer IRSA for Kubernetes controllers
- No long-lived credentials in repo
- Use AWS Secrets Manager (later: External Secrets Operator)
- Encryption at rest where supported (EBS, S3, etc.)
- Network segmentation via public/private subnets; limit public exposure
