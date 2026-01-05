variable "project" {
  type        = string
  description = "Project slug"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "IRSA role purpose name (e.g. aws-load-balancer-controller)"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN from EKS"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL (issuer) from EKS (without https:// prefix)"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace of the ServiceAccount"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes ServiceAccount name"
}

variable "policy_json" {
  type        = string
  description = "IAM policy JSON document to attach"
}
