resource "aws_flow_log" "pc_flow" {
  iam_role_arn    = aws_iam_role.pc_flow_role.arn
  log_destination = aws_cloudwatch_log_group.utility_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.utility.id
}

resource "aws_cloudwatch_log_group" "utility_flow_log" {
  name = "utility_flow_log-${random_string.suffix.id}"
  retention_in_days = 1
}