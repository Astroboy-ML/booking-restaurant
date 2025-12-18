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

variable "eks_cluster_role_name" {
  description = "Optional override for the IAM role name assumed by the EKS control plane (defaults to <cluster_name>-eks-role)"
  type        = string
  default     = null
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

variable "enable_private_api_endpoint" {
  description = "Enable private access to the EKS API server within the VPC (true recommended; set false to disable)"
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

variable "eks_node_role_name" {
  description = "Optional override for the IAM role name assumed by worker nodes (defaults to <cluster_name>-node-role)"
  type        = string
  default     = null
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
