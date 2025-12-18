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

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "booking-eks"
}

variable "eks_version" {
  description = "EKS version to deploy"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "CIDR block for the EKS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across (ex: [\"eu-west-3a\", \"eu-west-3b\"])"
  type        = list(string)
  default     = []
}

variable "public_subnets_cidrs" {
  description = "Public subnets CIDRs (aligned with azs order)"
  type        = list(string)
  default     = []
}

variable "private_subnets_cidrs" {
  description = "Private subnets CIDRs (aligned with azs order)"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways for private subnets (costs apply)"
  type        = bool
  default     = false
}

variable "enable_public_api_endpoint" {
  description = "Expose the EKS API server publicly (true) or private-only (false)"
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "EKS control plane logs to enable"
  type        = list(string)
  default     = ["api", "audit"]
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "booking-ng"
}

variable "node_instance_types" {
  description = "Instance types for the managed node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_capacity" {
  description = "Desired node count"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum node count"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum node count"
  type        = number
  default     = 3
}

variable "cluster_tags" {
  description = "Additional tags applied to cluster and nodegroup"
  type        = map(string)
  default     = {}
}
