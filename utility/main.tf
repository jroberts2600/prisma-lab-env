provider "aws" {
  region = var.ec2_region
}

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}
