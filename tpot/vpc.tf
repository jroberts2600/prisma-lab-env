# declare a VPC
/*
resource "aws_vpc" "tpot" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tpot-vpc-${random_string.suffix.id}"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.tpot.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "tpot_igw" {
  vpc_id = aws_vpc.tpot.id

  tags = {
    Name = "T-Pot VPC - Internet Gateway"
  }
}

resource "aws_route_table" "tpot_us_east_1a_public" {
    vpc_id = aws_vpc.tpot.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tpot_igw.id
    }

    tags = {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "tpot_us_east_1a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.tpot_us_east_1a_public.id
}

resource "aws_security_group" "tpot" {
  name        = "T-Pot"
  description = "T-Pot Honeypot"
  vpc_id      = aws_vpc.tpot.id
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 64294
    to_port     = 64294
    protocol    = "tcp"
    cidr_blocks = var.admin_ip
  }
  ingress {
    from_port   = 64295
    to_port     = 64295
    protocol    = "tcp"
    cidr_blocks = var.admin_ip
  }
  ingress {
    from_port   = 64297
    to_port     = 64297
    protocol    = "tcp"
    cidr_blocks = var.admin_ip
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "T-Pot"
  }
}
*/
