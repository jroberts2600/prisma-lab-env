output "ssm_policy" {
  value = aws_iam_instance_profile.ssm_mgr_policy.name
}

output "flow_role_arn" {
  value = aws_iam_role.pc_flow_role.arn
}