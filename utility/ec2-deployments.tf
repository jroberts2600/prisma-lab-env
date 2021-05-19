resource "aws_instance" "utility_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  tags = {
    Name = "Utility Instance"
    Defender = "true"
  }
}

resource "aws_instance" "web_instance" {
	# checkov:skip=CKV_AWS_88: Publically accessible web port
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  tags = {
    Name = "Web Instance"
    Defender = "true"
  }
}


resource "aws_instance" "test_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  tags = {
    Name = "Test Instance"
    Defender = "false"
  }
}