terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }

  # Remote state — enables team collaboration
  # Uncomment and configure for real AWS usage
  # backend "s3" {
  #   bucket         = "commerce-platform-terraform-state"
  #   key            = "platform/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "commerce-platform"
      ManagedBy   = "terraform"
      Environment = var.environment
      Owner       = "platform-team"
    }
  }
}