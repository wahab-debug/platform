variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "EKS cluster CA certificate"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN for IRSA"
}
