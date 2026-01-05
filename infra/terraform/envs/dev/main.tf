terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "lab-platform"
      Owner     = "AB"
      ManagedBy = "terraform"
      Environment = "dev"
    }
  }
}

########################
# Networking (VPC)
########################
module "vpc" {
  source = "../../modules/vpc"

  project     = "lab-platform"
  environment = "dev"

  cidr_block = "10.10.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnets = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  private_subnets = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]
}

########################
# Kubernetes (EKS)
########################
module "eks" {
  source = "../../modules/eks"

  project     = "lab-platform"
  environment = "dev"

  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids

  node_instance_types = ["t3.medium"]
  desired_size        = 2
  min_size            = 1
  max_size            = 3
}
