terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "diksha-gitops-backed-bucket"
    key     = "eks-gitops/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Python-AWS-EKS-GitOps"
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}

# Data source for available AWS availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source for current AWS Account ID and Caller Identity
data "aws_caller_identity" "current" {}
