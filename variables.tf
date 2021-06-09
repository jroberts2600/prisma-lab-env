variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "pcc_ws" {
  type = string
}

variable "pcc_image" {
  type = string
}

variable "pcc_admission-cert" {
  type = string
}

variable "pcc_admission-key" {
  type = string
}

variable "pcc_ca" {
  type = string
}

variable "pcc_client-cert" {
  type = string
}

variable "pcc_client-key" {
  type = string
}

variable "pcc_service-parameter" {
  type = string
}

variable "key_pair" {
  description = "Key pair to be used on ec2 instances"
  default = "nv-pan"
  type = string
}

variable "ec2_region" {
  description = "AWS region to launch servers"
  default     = "us-east-1"
  type = string
}

variable "admin_ip" {
  default     = ["24.178.240.50/32"]
  description = "admin IP addresses in CIDR format"
}
