output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "cluster_connect" {
  description = "Connect to Kubernetes Cluster"
  value       = "aws eks --region ${var.ec2_region} update-kubeconfig --name ${local.cluster_name}"
}

/*
output "jenkins_url" {
  description = "Jenkins COnsole"
  value       = kubernetes_service.jenkins.status.0.load_balancer.0.ingress.0.hostname
}
*/