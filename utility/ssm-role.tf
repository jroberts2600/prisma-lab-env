resource "aws_iam_role" "ssm_role_tf" {
  name = "ssm_role_tf_${random_string.suffix.id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.ssm_role_tf.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "ssm_mgr_policy" {
  name = "ssm_mgr_tf_${random_string.suffix.id}"
  role = aws_iam_role.ssm_role_tf.name
}
