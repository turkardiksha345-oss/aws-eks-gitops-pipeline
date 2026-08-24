variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-kubernetes-cluster"
}

variable "nodegroup_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "standard-workers"
}

variable "node_instance_types" {
  description = "Instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "max_nodes" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "ecr_repo_name" {
  description = "Name of the Amazon ECR repository"
  type        = string
  default     = "eks-cluster-app"
}

variable "domain_name" {
  description = "Primary domain name for ACM SSL Certificate and ALB Ingress"
  type        = string
  default     = "cdec-engineer.store"
}

variable "github_repo" {
  description = "GitHub repository in format 'org_or_user/repo_name' for OIDC trust policy"
  type        = string
  default     = "turkardiksha345-oss/aws-eks-gitops-pipeline"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether the Amazon EKS public API server endpoint is enabled (authenticated via AWS IAM)"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access the EKS API endpoint if public access is enabled"
  type        = list(string)
  default     = []
}
