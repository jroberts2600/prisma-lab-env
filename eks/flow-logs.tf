resource "aws_flow_log" "pc_flow" {
  iam_role_arn    = var.flow_role_arn
  log_destination = aws_cloudwatch_log_group.eks_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "eks_flow_log" {
  name = "eks_flow_log"
  retention_in_days = 1
}