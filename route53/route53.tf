resource "aws_route53_record" "api-int" {
  name = "api-int.${data.aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.id
  records = [data.terraform_remote_state.elb.outputs.control_plane_int]
  ttl = 300
}

resource "aws_route53_record" "api" {
  name = "api-int.${data.aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.id
  records = [data.terraform_remote_state.elb.outputs.control_plane_int]
  //records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
}

resource "aws_route53_record" "etcd_srv" {
  allow_overwrite = "true"
  name = "_etcd-server-ssl._tcp"
  type = "SRV"
  zone_id = data.aws_route53_zone.private_zone.zone_id
  records = [
    "0 10 2380 etcd-0.${var.cluster_domain}",
    "0 10 2380 etcd-1.${var.cluster_domain}",
    "0 10 2380 etcd-2.${var.cluster_domain}"
  ]
  ttl = 300
}

resource "aws_route53_record" "etcd_a_nodes" {
  count = 3
  type    = "A"
  ttl     = "60"
  allow_overwrite = true
//change lookup to private_zone - jrickard
  zone_id = data.aws_route53_zone.private_zone.id
  name    = "etcd-${count.index}.${var.cluster_domain }"
  records = ["${data.terraform_remote_state.control-plane.outputs.master_private_ips[count.index]}"]
}
