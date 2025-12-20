terraform {
  # Support current local Terraform (1.6.x) while staying below 1.9.
  required_version = ">= 1.6, < 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
    }
  }
}
