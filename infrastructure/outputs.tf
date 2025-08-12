output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.dev.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.dev.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.dev.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id
}

output "update_kubeconfig_command" {
  description = "Command to update kubeconfig for kubectl"
  value       = "aws eks update-kubeconfig --region eu-west-2 --name ${aws_eks_cluster.dev.name}"
}
