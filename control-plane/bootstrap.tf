resource "aws_instance" "bootstrap-node" {
  ami = var.rhcos_ami
  instance_type = var.ec2_type
  subnet_id = var.subnet_list[0]
  user_data = "{\"ignition\":{\"config\":{\"append\":[{\"source\":\"http://registry.${var.cluster_domain}:8080/bootstrap.ign\",\"verification\":{}}]},\"security\":{},\"timeouts\":{},\"version\":\"2.2.0\"},\"networkd\":{},\"passwd\":{},\"storage\":{},\"systemd\":{}}"

  iam_instance_profile = "${var.cluster_name}-master-profile"

  root_block_device { volume_size = var.volume_size }

  vpc_security_group_ids = [data.aws_security_group.master-sg.id]

  tags = merge(
  var.default_tags,
  map(
    "Name", "${var.cluster_name}-bootstrap-node",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_lb_target_group_attachment" "bootstrap_22623" {
  target_group_arn = data.aws_lb_target_group.int_22623_tg.arn
  target_id        = aws_instance.bootstrap-node.private_ip
}

resource "aws_lb_target_group_attachment" "bootstrap_6443" {
  target_group_arn = data.aws_lb_target_group.int_6443_tg.arn
  target_id        = aws_instance.bootstrap-node.private_ip
}