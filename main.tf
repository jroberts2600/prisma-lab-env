provider "aws" {
  region = "us-east-1"
}

module "utility" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  admin_ip = var.admin_ip
  source = "./utility"
}
output "Utility_Instance_SSH_Access" {
  value = module.utility.utility_instance_public_ip
}
output "Web_Instance_SSH_Access" {
  value =module.utility.web_instance_public_ip
}

/*
module "tpot" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  admin_ip = var.admin_ip
  source = "./tpot"
}
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