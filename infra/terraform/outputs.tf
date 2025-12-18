output "aws_region" {
  description = "AWS region configured for the current workspace"
  value       = var.aws_region
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL for IRSA"
  value       = try(aws_eks_cluster.this.identity[0].oidc[0].issuer, null)
}

output "node_group_role_arn" {
  description = "IAM role for worker nodes"
  value       = aws_iam_role.eks_nodes.arn
}

output "vpc_id" {
  description = "VPC id for the EKS cluster"
  value       = aws_vpc.this.id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = values(aws_subnet.private)[*].id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = values(aws_subnet.public)[*].id
}
