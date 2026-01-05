terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "lab-platform"
      Owner       = "AB"
      ManagedBy   = "terraform"
      Environment = "prod"
    }
  }
}

########################
# Networking (VPC)
########################
module "vpc" {
  source = "../../modules/vpc"

  project     = "lab-platform"
  environment = "prod"

  cidr_block = "10.30.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnets = [
    "10.30.1.0/24",
    "10.30.2.0/24"
  ]

  private_subnets = [
    "10.30.11.0/24",
    "10.30.12.0/24"
  ]
}

########################
# Kubernetes (EKS)
########################
module "eks" {
  source = "../../modules/eks"

  project     = "lab-platform"
  environment = "prod"

  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  # Prod: use more stable instance family than dev (still cost-conscious)
  # You can switch to m5/m6 later; keep it consistent for now.
  node_instance_types = ["t3.large"]
  desired_size        = 3
  min_size            = 3
  max_size            = 6
}
# ALB Controller IRSA Role
module "alb_irsa" {
  source = "../../modules/iam-irsa"

  project     = "lab-platform"
  environment = "prod"
  name        = "aws-load-balancer-controller"

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_issuer_url

  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"

  policy_json = file("${path.module}/../../policies/aws-load-balancer-controller.json")
}
