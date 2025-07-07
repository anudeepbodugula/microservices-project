terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "terraform-state-bucket-myapp-microservices"
  key            = "terraform/eks/terraform.tfstate"
  region         = "ca-central-1"
  encrypt        = true
  dynamodb_table = "terraform-locks-myapp"
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  environment            = var.environment
  cidr_block             = var.cidr_block
  private_subnet_cidr    = var.private_subnet_cidr
  public_subnet_cidr     = var.public_subnet_cidr
  availability_zones     = var.availability_zones
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}