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