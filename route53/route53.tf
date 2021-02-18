resource "aws_route53_record" "api-int" {
  name = "api-int.${data.aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.id
  records = [data.terraform_remote_state.elb.outputs.control_plane_int]
  ttl = 300
}

resource "aws_route53_record" "api" {
  name = "api.${data.aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.id
  records = [data.terraform_remote_state.elb.outputs.control_plane_int]
  //records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
}
