/*
resource "aws_instance" "tpot" {
  ami           = var.ec2_ami[var.ec2_region]
  instance_type = var.ec2_instance_type
  key_name      = var.key_pair
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "T-Pot Honeypot"
    Defender = "false"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }
  user_data                   = templatefile("./tpot/cloud-init.yaml", { timezone = var.timezone, password = var.linux_password, tpot_flavor = var.tpot_flavor, web_user = var.web_user, web_password = var.web_password })
  vpc_security_group_ids      = [aws_security_group.tpot.id]
  associate_public_ip_address = true
}
*/
