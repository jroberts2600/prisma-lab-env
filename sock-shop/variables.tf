variable "ec2_region" {
  type = string
}

data "aws_availability_zones" "available" {}