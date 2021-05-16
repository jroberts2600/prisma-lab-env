resource "aws_flow_log" "pc_flow" {
  iam_role_arn    = aws_iam_role.pc_flow_role.arn
  log_destination = aws_cloudwatch_log_group.pc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.utility.id
}

resource "aws_cloudwatch_log_group" "pc_flow_log" {
  name = "pc_flow_log"
}

resource "aws_iam_role" "pc_flow_role" {
  name = "pc_flow_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "pc_flow_policy" {
  name = "pc_flow_policy"
  role = aws_iam_role.pc_flow_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
