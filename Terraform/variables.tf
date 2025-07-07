variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ca-central-1"
  
}

variable "cidr_block" {
    description = "value for the VPC CIDR block"
    type        = string
    default = "10.0.0/16"
  
}

variable "availability_zones" {
    description = "List of availability zones for the VPC"
    type        = list(string)
    default     = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
  
}

variable "private_subnet_cidr" {
    description = "value for the private subnet CIDR block"
    type        = list(string)
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  
}

variable "public_subnet_cidr" {
    description = "value for the public subnet CIDR block"
    type        = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  
}
variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default     = "myapp-eks-cluster"
  
}

variable "cluster_version" {
    description = "Version of the EKS cluster"
    type        = string
    default     = "1.30"
  
}

variable "node_groups" {
    description = "Configuration for EKS node groups"
    type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    }))
  
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
    }
  }
  
}

variable "environment" {
    description = "Environment for the deployment (e.g., dev, staging, prod)"
    type        = string
    default     = "dev"
  
}