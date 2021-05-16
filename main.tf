provider "aws" {
  region = "us-east-1"
}

module "utility" {
  key_pair = var.key_pair
  ec2_region = var.ec2_region
  source = "./utility"
}