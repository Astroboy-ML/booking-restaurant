variable "aws_region" {
  description = "AWS region used for Terraform operations"
  type        = string
  default     = "eu-west-3"
}

variable "default_tags" {
  description = "Default tags applied to all AWS resources created by Terraform"
  type        = map(string)
  default = {
    project = "booking-restaurant"
    env     = "sandbox"
  }
}
