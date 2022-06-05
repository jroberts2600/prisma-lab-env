variable "key_pair" {
  type = string
}

variable "ec2_region" {
  type = string
}

variable "admin_ip" {
  description = "Admin IP addresses in CIDR format"
}

variable "flow_role_arn" {
  type = string
}

variable "ssm_policy" {
  type = string
}