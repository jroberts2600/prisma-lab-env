variable "ec2_region" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_cert" {
  description = "Cluster Certificate."
  type        = string
}

data "aws_availability_zones" "available" {}