output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name

}

output "cluster_version" {
  description = "The version of the EKS cluster"
  value       = module.eks.cluster_version

}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint

}

output "cluster_certificate_authority" {
  description = "The certificate authority data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true

}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id

}

output "region" {
  description = "The AWS region where the resources are created"
  value       = var.region

}