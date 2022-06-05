resource "aws_route53_zone" "primary" {
  name = "jtb75-002.ng20.org"
}

resource "aws_route53_record" "utility" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "utility.${aws_route53_zone.name}"
  type    = "A"
  ttl     = "300"
  records = [var.utility_ip]
}