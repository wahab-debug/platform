variable "project" {
  type        = string
  description = "Project slug"
  default     = "lab-platform"
}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
}

variable "github_org" {
  type        = string
  description = "GitHub org/username (owner)"
  default     = "wahab-debug"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo name"
  default     = "platform"
}

variable "github_branch" {
  type        = string
  description = "Branch allowed to deploy from"
  default     = "main"
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR repository name"
  default     = "lab-platform-myapp"
}
