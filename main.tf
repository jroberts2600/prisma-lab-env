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
  flow_role_arn = module.iam.flow_role_arn
  source = "./eks"
}

module "sock-shop" {
  ec2_region = var.ec2_region
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_cert = module.eks.cluster_ca_cert
  cluster_name = module.eks.cluster_name
  source = "./sock-shop"
}