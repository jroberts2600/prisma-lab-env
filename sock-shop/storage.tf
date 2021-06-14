resource "aws_ebs_volume" "sock-shop" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    App = "Sock-Shop"
  }
}
