output "elasticache_address" {
  value = aws_elasticache_cluster.test.cache_nodes.0.address
}

output "elasticache_port" {
  value = aws_elasticache_cluster.test.cache_nodes.0.port
}

output "serviceaccount_role_arn" {
  value = module.iam_eks_role.iam_role_arn
}
