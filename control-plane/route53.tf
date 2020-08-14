//route53 configuration 

data "aws_route53_zone" "private_zone" {
  name =  "${var.clustername}.${var.domain}"
  private_zone = true
}

data "aws_lb" "control_plane_int" {
  name = var.cluster_name-int
}

resource "aws_route53_record" "etcd_a_nodes" {
  count = var.control_plane.count
  type    = "A"
  ttl     = "60"
  zone_id = data.aws_route53_zone.zone.id
  name    = "etcd-${count.index}.${var.cluster_name}.${var.cluster_domain}"
  records = ["${aws_instance.master-nodes[count.index].private_ip}"]
  allow_overwrite = true
}

resource "aws_route53_record" "api-int" {
  name = "api-int.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.zone_id
  records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
  allow_overwrite = true
}

resource "aws_route53_record" "api" {
  name = "api.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.private_zone.zone_id
  records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
  allow_overwrite = true
}

