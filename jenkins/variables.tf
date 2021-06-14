variable "ec2_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_cert" {
  description = "Cluster Certificate."
  type        = string
}

variable "pv_name" {
  type        = string
  default     = "jenkins-pv"
}

data "aws_availability_zones" "available" {}