# ADR 0001: Environment Separation and Terraform State Strategy

## Status
Accepted

## Context
We require three environments (dev, staging, prod) with production-grade isolation principles, repeatable infrastructure provisioning, and safe change management. We also want a cost-aware path that can begin in a single AWS account but can graduate to multi-account without refactoring.

## Decision
1. **Separate Terraform state per environment**
   - Each environment has a distinct Terraform state, lock, and clear blast radius.
   - State storage uses S3 + DynamoDB locking.

2. **Separate EKS clusters per environment**
   - dev, staging, and prod are deployed to separate EKS clusters.
   - This matches typical production practices and supports realistic rollout/incident behavior.

3. **Consistent naming convention**
   - Resource naming: `{project}-{env}-{component}`
   - Example: `lab-platform-dev-eks`, `lab-platform-prod-vpc`

4. **Tagging standard for all AWS resources (where supported)**
   - `Project`: `lab-platform`
   - `Environment`: `dev|staging|prod`
   - `Owner`: `abdul wahab`
   - `ManagedBy`: `terraform`

5. **Account strategy**
   - Phase 1 (cost-friendly): single AWS account with strict isolation via naming, tags, state separation, and IAM roles.
   - Phase 2 (production ideal): separate AWS accounts per environment under AWS Organizations.

## Consequences
- Separate state requires maintaining multiple backend configurations and enforcing strong conventions in CI/CD.
- Separate clusters increase cost versus namespaces, but provide a materially better approximation of production operations.
- The repo must enforce consistent standards to avoid drift across environments.

## Alternatives Considered
- Single EKS cluster with namespaces:
  - Lower cost, but weaker isolation and less realistic operational behavior.
- Single Terraform state:
  - Not acceptable due to blast radius and risk of accidental cross-environment changes.
