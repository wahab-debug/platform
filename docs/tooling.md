# Tooling

This repository assumes consistent versions across environments and CI.

## Required Tools
- Terraform (>= 1.6.x recommended)
- AWS CLI v2
- kubectl (aligned to your EKS version)
- Helm v3
- tflint
- Trivy (CI image scanning)
- (optional) asdf for version pinning

## Formatting & Validation
Terraform:
- `terraform fmt -recursive`
- `terraform validate`

TFLint:
- `tflint --recursive`

Helm:
- `helm lint`
- `helm template` for rendering validation

## Notes
CI will enforce fmt + validate + lint gates before plans/applies.
