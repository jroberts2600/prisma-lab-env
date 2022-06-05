output "ssm_policy" {
  value = module.iam.ssm_policy
}

output "flow_role_arn" {
  value = module.iam.flow_role_arn
}

output "Utility_Instance_SSH_Access" {
  value = module.ec2.utility_instance_public_ip
}
output "Web_Instance_SSH_Access" {
  value = module.ec2.web_instance_public_ip
}

output "demo-bucket" {
  value = module.s3.private-bucket
}
