variable "ec2_region" {
  type = string
}

variable "flow_role_arn" {
  type = string
}

variable "pcc_ws" {
  type = string
}

variable "pcc_image" {
  type = string
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-${random_string.suffix.result}"
}