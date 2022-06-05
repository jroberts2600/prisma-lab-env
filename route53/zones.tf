resource "aws_route53_zone" "primary" {
  name = "foobar.io"
}

resource "aws_route53_record" "demo" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "foobar.io"
  type    = "A"
  ttl     = "300"
  records = [
    "ns-1935.awsdns-49.co.uk.",
    "ns-381.awsdns-47.com.",
    "ns-832.awsdns-40.net.",
    "ns-1275.awsdns-31.org."
  ]
}