# Production-Grade DevOps Platform on AWS (EKS)

This repository demonstrates the design and implementation of a **production-grade, multi-environment DevOps platform** on AWS.  
It is built using **Terraform, Kubernetes (EKS), Helm, GitHub Actions, and Argo Rollouts**, with strong emphasis on **security, observability, cost control, and deployment safety**.

The project is intentionally designed **infrastructure-first**, following real-world platform engineering practices.

---

## Architecture Diagram

### High-Level Platform Architecture (ASCII)

```text
GitHub Actions
  |
  |  CI / CD
  |  (OIDC authentication)
  v
AWS IAM
  |
  |  OIDC Provider
  |  No Static Credentials
  v
Terraform
  |
  |  Remote State (S3 + DynamoDB)
  |  Isolated per Environment
  |
  +--> Dev
  |
  +--> Staging
  |
  +--> Prod
  |
  v
AWS VPC
  |
  |-- Public Subnets
  |-- NAT Gateway
  |-- Private Subnets
  |
  v
Amazon EKS
  |
  |-- Private API Endpoint
  |-- Managed Node Groups
  |
  v
Kubernetes Platform Add-ons
  |
  |-- AWS Load Balancer Controller (IRSA)
  |-- Argo Rollouts (Blue / Green)
  |-- metrics-server
  |-- Fluent Bit → CloudWatch Logs (IRSA)
  |-- Prometheus
  |-- Grafana
  |
  v
Application Workloads
  |
  |-- Deployed via Helm
  |-- Blue / Green Strategy
  |
  v
AWS Application Load Balancer
  |
  |-- Active Service
  |-- Preview Service
```
## High-Level Architecture

**Environments**
- Dev
- Staging
- Prod

Each environment is **fully isolated** with:
- Separate VPC
- Separate EKS cluster
- Separate Terraform state
- Independent CI/CD promotion flow

---

## Core Technologies

- **Cloud**: AWS (EKS, VPC, IAM, ECR, CloudWatch)
- **Infrastructure as Code**: Terraform
- **Containers & Orchestration**: Docker, Kubernetes (EKS)
- **Package Management**: Helm
- **CI/CD**: GitHub Actions (OIDC-based authentication)
- **Progressive Delivery**: Argo Rollouts (Blue/Green)
- **Observability**: Prometheus, Grafana, CloudWatch Logs
- **Security**: IRSA, least-privilege IAM, no static credentials

---

## Repository Structure
```text
platform/
├── infra/
│ └── terraform/
│ ├── bootstrap/ # Terraform backend & security (OIDC, ECR)
│ ├── envs/ # dev / staging / prod compositions
│ ├── modules/ # reusable VPC, EKS, IRSA, add-ons modules
│ └── policies/ # IAM policies (ALB, Fluent Bit, etc.)
│
├── apps/
│ └── helm/
│ ├── charts/
│ │ ├── addons/ # namespaces, platform add-ons
│ │ └── myapp/ # sample application chart
│ └── envs/
│ ├── dev/
│ ├── staging/
│ └── prod/
│
├── cicd/
│ └── scripts/ # deployment helpers
│
├── .github/workflows/ # CI/CD pipelines
├── docs/ # architecture, add-ons, alerting strategy
├── Makefile
└── README.md
```
---

## Infrastructure Design

### Terraform Backend & State
- Remote state stored in **S3**
- State locking via **DynamoDB**
- Separate state per environment
- Bootstrap stack isolated from application infrastructure

### Networking
- Dedicated VPC per environment
- Public & private subnets across multiple AZs
- Cost-aware NAT Gateway strategy
- Production-ready routing and tagging

### Kubernetes (EKS)
- Managed EKS clusters
- Private subnets for worker nodes
- Managed node groups
- OIDC enabled for IRSA
- Control-plane logging enabled

---

## Security Model

### AWS & IAM
- **No static AWS credentials**
- GitHub Actions authenticates via **OIDC**
- Least-privilege IAM roles per component
- IRSA for all in-cluster AWS access

### Kubernetes Security
- Non-root containers
- Read-only root filesystem
- Capability drops
- Namespaced workloads

---

## CI/CD Pipeline

### Continuous Integration
- Helm linting and rendering
- Docker image build
- Vulnerability scanning (Trivy)
- Push to Amazon ECR

### Continuous Deployment
- **Dev**: automatic deployment on merge to `main`
- **Staging / Prod**: manual approvals via GitHub Environments
- Helm-based deployments
- Image immutability via commit SHA tagging

---

## Progressive Delivery (Blue/Green)

- Argo Rollouts used for deployments
- Separate **active** and **preview** services
- ALB routes traffic to active service
- Preview environment available for validation
- Manual promotion for staging and production
- Instant rollback support

---

## Observability & Operations

### Metrics
- Prometheus for cluster and application metrics
- metrics-server for HPA support
- kube-state-metrics & node-exporter enabled

### Visualization
- Grafana dashboards for:
  - Cluster health
  - Node and pod utilization
  - Application performance

### Logging
- Fluent Bit ships logs to CloudWatch
- Per-environment log groups
- Cost-visible log structure

### Alerting Philosophy
- Alert on symptoms, not noise
- SLO-oriented alerts
- Minimal initial alert set
- Promotion gating based on observability signals

---

## Deployment Workflow (When Applied)

1. Terraform bootstrap (state + security)
2. Environment infrastructure (VPC → EKS)
3. Platform add-ons (ALB, metrics, logging)
4. Observability stack
5. Application deployment via Argo Rollouts
6. Controlled promotion and rollback

---

## Why This Project Matters

This project reflects **real production practices**, not simplified demos:
- Environment isolation
- Secure CI/CD with OIDC
- Progressive delivery
- Strong observability foundations
- Clear operational runbooks

It is designed to be **auditable, explainable, and interview-ready**.

---

## Author

**DevOps / Platform Engineer**  
Focused on building secure, scalable, and observable cloud platforms using AWS and Kubernetes.

```text

                               ┌────────────────────────────┐
                               │        GitHub Actions        │
                               │  CI/CD (OIDC → AWS IAM)      │
                               └───────────────┬────────────┘
                                               │
                                     AssumeRoleWithWebIdentity
                                               │
                               ┌───────────────▼────────────┐
                               │           AWS IAM            │
                               │   OIDC Role (No Static Keys) │
                               └───────────────┬────────────┘
                                               │
        ┌──────────────────────────────────────┼──────────────────────────────────────┐
        │                                      │                                      │
┌───────▼────────┐                    ┌────────▼────────┐                    ┌────────▼────────┐
│   Dev Account   │                    │ Staging Account  │                    │   Prod Account   │
│   (Same AWS)    │                    │  (Same AWS)      │                    │  (Same AWS)      │
└───────┬────────┘                    └────────┬────────┘                    └────────┬────────┘
        │                                      │                                      │
        │ Terraform (separate state per env)   │ Terraform (separate state per env)   │ Terraform (separate state per env)
        │                                      │                                      │
┌───────▼──────────────────────────────────────────────────────────────────────────────────────────┐
│                                           AWS VPC (per env)                                         │
│                                                                                                      │
│   ┌───────────────┐            ┌───────────────┐            ┌───────────────┐                      │
│   │ Public Subnet │            │ Public Subnet │            │  NAT Gateway  │                      │
│   └───────┬───────┘            └───────┬───────┘            └───────┬───────┘                      │
│           │                            │                            │                              │
│   ┌───────▼───────┐            ┌───────▼───────┐            ┌───────▼───────┐                      │
│   │ Private Subnet│            │ Private Subnet│            │ Route Tables  │                      │
│   └───────┬───────┘            └───────┬───────┘            └───────────────┘                      │
│           │                            │                                                           │
│           └──────────────┬─────────────┴──────────────┐                                            │
│                          │                            │                                            │
│               ┌──────────▼──────────┐       ┌─────────▼─────────┐                                  │
│               │     EKS Cluster      │       │ Managed NodeGroup  │                                  │
│               │  (Private Endpoint)  │       │ (Private Subnets)  │                                  │
│               └──────────┬──────────┘       └─────────┬─────────┘                                  │
│                          │                            │                                            │
│        ┌─────────────────▼─────────────────┐          │                                            │
│        │        Kubernetes Add-ons          │          │                                            │
│        │-----------------------------------│          │                                            │
│        │ • AWS Load Balancer Controller     │◄─ IRSA ─┘                                            │
│        │ • Argo Rollouts (Blue/Green)      │                                                   │
│        │ • metrics-server                  │                                                   │
│        │ • Fluent Bit → CloudWatch Logs    │◄─ IRSA                                            │
│        │ • Prometheus + Grafana            │                                                   │
│        └─────────────────┬─────────────────┘                                                   │
│                          │                                                                      │
│                   ┌──────▼──────┐                                                               │
│                   │ Application │                                                               │
│                   │   (Helm)    │                                                               │
│                   │  Blue/Green │                                                               │
│                   └──────┬──────┘                                                               │
│                          │                                                                      │
│               ┌──────────▼──────────┐                                                           │
│               │ AWS ALB (Ingress)    │                                                           │
│               │ Active / Preview     │                                                           │
│               └─────────────────────┘                                                           │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

```
---

## Disclaimer

This repository is intended for **learning, demonstration, and portfolio purposes**.  
All infrastructure is designed first and applied deliberately to avoid unnecessary cloud costs.
