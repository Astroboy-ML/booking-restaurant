aws_region   = "eu-west-3"          # région cible (provider AWS)
cluster_name = "booking-eks-dev"    # préfixe de nommage cluster/rôles
eks_version  = "1.30"

# Networking (align AZs/subnets order)
azs                   = ["eu-west-3a", "eu-west-3b"]
vpc_cidr              = "10.10.0.0/16"
public_subnets_cidrs  = ["10.10.0.0/20", "10.10.16.0/20"]
private_subnets_cidrs = ["10.10.32.0/20", "10.10.48.0/20"]
enable_nat_gateway    = false # set true for private egress (adds cost)

# EKS API endpoints
enable_public_api_endpoint  = true  # exposer l'API en public
enable_private_api_endpoint = true  # garder l'accès privé dans le VPC
cluster_log_types           = ["api", "audit"]

# IAM roles (override optional)
eks_cluster_role_name = null
node_group_name       = "booking-ng-dev"
eks_node_role_name    = null

# Node group sizing
node_instance_types   = ["t3.small"]
node_desired_capacity = 2
node_min_size         = 1
node_max_size         = 3

cluster_tags = {
  environment = "dev"
  project     = "booking-restaurant"
}
