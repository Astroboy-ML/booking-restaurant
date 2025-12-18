aws_region = "eu-west-3"
cluster_name = "booking-eks-dev"
eks_version = "1.30"

# Networking (align AZs/subnets order)
azs                  = ["eu-west-3a", "eu-west-3b"]
vpc_cidr             = "10.10.0.0/16"
public_subnets_cidrs = ["10.10.0.0/20", "10.10.16.0/20"]
private_subnets_cidrs = ["10.10.32.0/20", "10.10.48.0/20"]
enable_nat_gateway   = false # set true for private egress (adds cost)

# EKS
enable_public_api_endpoint = true
cluster_log_types          = ["api", "audit"]

# Node group
node_group_name     = "booking-ng-dev"
node_instance_types = ["t3.small"]
node_desired_capacity = 2
node_min_size         = 1
node_max_size         = 3

cluster_tags = {
  environment = "dev"
  project     = "booking-restaurant"
}
