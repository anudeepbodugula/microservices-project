output "cluster_name" {
    description = "The name of the EKS cluster"
    value       = module.eks.cluster_name
  
}
output "cluster_endpoint" {
    description = "The endpoint of the EKS cluster"
    value       = module.eks.cluster_endpoint
}
output "vpc_id" {
    description = "The VPC ID where the EKS cluster is deployed"
    value       = module.vpc.vpc_id
}