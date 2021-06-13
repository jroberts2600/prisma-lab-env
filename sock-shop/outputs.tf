output "sock-shop_url" {
  description = "Sock Shop Application"
  value       = kubernetes_service.front_end.status.0.load_balancer.0.ingress.0.hostname
}