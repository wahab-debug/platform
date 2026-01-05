# Terraform Remote State Design (S3 + DynamoDB)

## Goals
- Separate state per environment to reduce blast radius.
- Prevent concurrent state writes (locking).
- Enable clean CI/CD integration and drift detection.

## Recommended Approach
### Option A (preferred): One S3 bucket per environment
- `lab-platform-tfstate-dev`
- `lab-platform-tfstate-staging`
- `lab-platform-tfstate-prod`

Locking:
- DynamoDB table per environment, or a shared table with environment-specific locks.

Pros:
- Strong isolation and simpler access controls per environment.
Cons:
- Slightly more resources to manage.

### Option B (acceptable): One bucket with prefixes
Bucket:
- `lab-platform-tfstate`

Keys:
- `envs/dev/terraform.tfstate`
- `envs/staging/terraform.tfstate`
- `envs/prod/terraform.tfstate`

Pros:
- Less AWS resources.
Cons:
- Requires stricter IAM and naming discipline.

## Locking (DynamoDB)
- Table name example (shared): `lab-platform-terraform-locks`
- Partition key: `LockID` (string)

## Encryption & Access Controls
- S3 SSE enabled (SSE-S3 or SSE-KMS)
- Bucket versioning enabled
- Bucket public access blocked
- IAM policies:
  - environment-scoped access where possible
  - CI role with least privilege (read plan + write apply)

## CI/CD Integration Notes
- Plans should use environment-specific backend configuration.
- Applies should be restricted to protected branches and approved environments.
