variable "aws_region" {
  description = "AWS region to deploy bootstrap resources into"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project slug used for naming"
  type        = string
  default     = "lab-platform"
}

variable "owner" {
  description = "Owner tag value (team/person)"
  type        = string
  default     = "AB"
}

variable "environments" {
  description = "List of environments to create separate state backends for"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
}

variable "use_kms" {
  description = "If true, use a customer-managed KMS key for S3 state encryption. If false, use SSE-S3."
  type        = bool
  default     = false
}
