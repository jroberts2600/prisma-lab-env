output "Utility_Instance_SSH_Access" {
  value = module.utility.utility_instance_public_ip
}
output "Web_Instance_SSH_Access" {
  value = module.utility.web_instance_public_ip
}

/*
output "T-Pot_Admin_UI" {
  value = module.tpot.Admin_UI
}
output "T-Pot_SSH_Access" {
  value = module.tpot.SSH_Access
}
output "T-Pot_Web_UI" {
  value = module.tpot.Web_UI
}
*/

//
// Kubernetes Specific Outputs
//

/*
output "Kubernetes_Connect" {
  value = module.eks.cluster_connect
}

output "Sock-Shop" {
  value = module.sock-shop.sock-shop_url
}
*/

/*
output "Jenkins" {
  value = module.eks.jenkins_url
}
*/