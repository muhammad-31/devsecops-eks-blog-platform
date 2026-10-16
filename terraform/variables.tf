variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "ap-south-1"

}

variable "environment" {
  description = "The environment to deploy the EKS cluster in (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}