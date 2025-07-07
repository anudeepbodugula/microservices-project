variable "cidr_block" {
    description = "value of the CIDR block for the VPC"
    type = string
  
}

variable "private_subnet_cidr" {
    description = "list of CIDR blocks for private subnets"
    type = list(string) 
  
}

variable "public_subnet_cidr" {
    description = "list of CIDR blocks for public subnets"
    type = list(string) 
  
}

variable "availability_zones" {
    description = "list of availability zones for the subnets"
    type = list(string) 
  
}

variable "environment" {
    description = "the environment for which the VPC is being created (e.g., dev, staging, prod)"
    type = string
    default = "dev"
  
}