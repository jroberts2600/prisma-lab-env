provider "aws" {
  region = var.ec2_region
}

resource "random_string" "suffix" {
  length  = 4
  upper = false
  special = false
}
