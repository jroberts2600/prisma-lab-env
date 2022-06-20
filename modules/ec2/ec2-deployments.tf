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

/*
resource "aws_instance" "web_instance" {
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
*/
/*
resource "aws_instance" "web-server" {
  ami               = "ami-042e8287309f5df03" 
  instance_type     = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    # install Docker runtime
    sudo apt update -y
    sudo apt install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker ubuntu
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    # install Defender
    sudo apt install jq -y
    AUTH_DATA="$(printf '{ "username": "%s", "password": "%s" }' "${var.pcc_username}" "${var.pcc_password}")"
    TOKEN=$(curl -sSLk -d "$AUTH_DATA" -H 'content-type: application/json' "${var.pcc_url}/api/v1/authenticate" | jq -r ' .token ')
    DOMAIN_NAME=`echo ${var.pcc_url} | cut -d'/' -f3 | cut -d':' -f1`
    curl -sSLk -H "authorization: Bearer $TOKEN" -X POST "${var.pcc_url}/api/v1/scripts/defender.sh" | sudo bash -s -- -c $DOMAIN_NAME -d "none" -m
    EOF

  tags = {
    Name = "web-server"
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
}
*/