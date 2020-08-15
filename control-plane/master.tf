resource "aws_instance" "master-nodes" {
  ami = var.rhcos_ami
  instance_type = var.ec2_type
  count = var.master_count
  subnet_id = var.subnet_list[count.index]
  user_data = "{\"ignition\":{\"config\":{\"append\":[{\"source\":\"http://registry.${var.cluster_domain}:8080/master.ign\",\"verification\":{}}]},\"security\":{},\"timeouts\":{},\"version\":\"2.2.0\"},\"networkd\":{},\"passwd\":{},\"storage\":{},\"systemd\":{}}"

  iam_instance_profile = "${var.cluster_name}-master-profile"

  root_block_device { volume_size = var.volume_size }

  vpc_security_group_ids = [data.aws_security_group.master-sg.id]

  tags = merge(
  var.default_tags,
  map(
    "Name", "${var.cluster_name}-master-${count.index}",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_lb_target_group_attachment" "master_6443" {
  count = var.master_count
  target_group_arn = data.aws_lb_target_group.int_6443_tg.arn
  target_id        = aws_instance.master-nodes[count.index].private_ip
}

resource "aws_lb_target_group_attachment" "master_22623" {
  count = var.master_count
  target_group_arn = data.aws_lb_target_group.int_22623_tg.arn
  target_id        = aws_instance.master-nodes[count.index].private_ip
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
