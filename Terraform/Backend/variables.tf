variable "environment" {
  description = "The environment for which the Terraform state is being managed (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  
}