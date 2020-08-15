resource "aws_route53_record" "api-int" {
  name = "api-int.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
}

resource "aws_route53_record" "api" {
  name = "api-int.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = [data.aws_lb.control_plane_int.dns_name]
  ttl = 300
}

resource "aws_route53_record" "etcd_srv" {
  allow_overwrite = "true"
  name = "_etcd-server-ssl._tcp"
  type = "SRV"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = [
    "0 10 2380 etcd-0.${var.cluster_name}.${var.cluster_domain}",
    "0 10 2380 etcd-1.${var.cluster_name}.${var.cluster_domain}",
    "0 10 2380 etcd-2.${var.cluster_name}.${var.cluster_domain}"
  ]
  ttl = 300
}

resource "aws_route53_record" "etcd_a_nodes" {
  count = var.control_plane.count
  type    = "A"
  ttl     = "60"
  allow_overwrite = true
  zone_id = data.aws_route53_zone.zone.id
  name    = "etcd-${count.index}.${var.cluster_name}.${var.cluster_domain}"
  records = ["${aws_instance.master-nodes[count.index].private_ip}"]
}
resource "aws_lb" "control_plane_int" {
  name =  "${var.cluster_name}-int"

  load_balancer_type = "network"
  internal = "true"
  subnets = data.aws_subnet.private_subnet.*.id

tags =  merge(
var.default_tags,
  map(
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
    "Name", "${var.cluster_name}-int"
    )
  )
}
