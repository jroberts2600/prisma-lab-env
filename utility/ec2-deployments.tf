resource "aws_instance" "utility_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name

  tags = {
    Name = "utility-instance"
    Defender = "false"
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name

  tags = {
    Name = "web-instance"
    Defender = "false"
  }
}

/*
resource "aws_instance" "test_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name

  tags = {
    Name = "test-instance"
    Defender = "false"
  }
}

output "test_instance_public_ip" {
  value = aws_instance.test_instance.public_ip
}
*/
