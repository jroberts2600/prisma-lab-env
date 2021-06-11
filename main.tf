provider "aws" {
  region = "us-east-1"
}

module "iam" {
  ec2_region = var.ec2_region
  source = "./iam"
}

module "utility" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  admin_ip = var.admin_ip
  ssm_policy = module.iam.ssm_policy
  flow_role_arn = module.iam.flow_role_arn
  source = "./utility"
}

/*
module "tpot" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  admin_ip = var.admin_ip
  flow_role_arn = module.iam.flow_role_arn
  source = "./tpot"
}
*/

module "eks" {
  ec2_region = var.ec2_region
  pcc_ws = var.pcc_ws
  pcc_image = var.pcc_image
  pcc_admission-cert = var.pcc_admission-cert
  pcc_admission-key = var.pcc_admission-key
  pcc_ca = var.pcc_ca
  pcc_client-cert = var.pcc_client-cert
  pcc_client-key = var.pcc_client-key
  pcc_service-parameter = var.pcc_service-parameter
  flow_role_arn = module.iam.flow_role_arn
  source = "./eks"
}