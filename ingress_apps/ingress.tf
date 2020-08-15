resource "aws_route53_record" "wildcard-apps" {
  name = "*.apps.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = ["replaceme"]
  ttl = 300
}
