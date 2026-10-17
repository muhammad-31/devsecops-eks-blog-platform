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
  description = "Kubernetes version of the EKS cluster. Keep it in standard support; extended support costs six times as much per hour."
  type        = string
  default     = "1.36"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Networks allowed to reach the public Kubernetes API endpoint. Set this to your office/VPN ranges; the default leaves it open to the internet (still behind IAM authentication)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}