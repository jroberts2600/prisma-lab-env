variable "ec2_region" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

data "aws_availability_zones" "available" {}