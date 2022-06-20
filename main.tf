provider "aws" {
  region = var.ec2_region
}

module "iam" {
  ec2_region = var.ec2_region
  source = "./modules/iam"
}

module "kms" {
  ec2_region = var.ec2_region
  source = "./modules/kms"
}

module "s3" {
  ec2_region = var.ec2_region
  s3_key_arn = module.kms.s3_key_arn
  source = "./modules/s3"
}

module "ec2" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  admin_ip = var.admin_ip
  ssm_policy = module.iam.ssm_policy
  flow_role_arn = module.iam.flow_role_arn
  source = "./modules/ec2"
  pcc_url = var.PCC_URL
  pcc_username = var.PCC_ACCESS_KEY_ID
  pcc_password = var.PCC_SECRET_ACCESS_KEY
}