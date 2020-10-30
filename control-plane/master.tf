resource "aws_instance" "master-nodes" {
  ami = var.rhcos_ami
  instance_type = var.ec2_type
  count = var.master_count
  subnet_id = var.subnet_list[count.index]
  user_data = "{\"ignition\": {\"version\": \"3.1.0\",\"config\": {\"replace\": {\"source\": \"http://registry.${var.cluster_domain}:8080/master.ign\",\"verification\":{}}}}}"

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
