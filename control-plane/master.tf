data "aws_security_group" "master-sg" {
  filter {
    name   = "tag:Name"
    values = [format("${var.cluster_name}-master-sg")]
  }
}

resource "aws_instance" "master-node" {
  ami = var.rhcos_ami
  instance_type = var.ec2_type
  count = var.master_count
  subnet_id = var.subnet_list[count.index]
  user_data = "{\"ignition\":{\"config\":{\"append\":[{\"source\":\"http://registry.${var.cluster_name}.${var.cluster_domain}/master.ign\",\"verification\":{}}]},\"security\":{},\"timeouts\":{},\"version\":\"2.2.0\"},\"networkd\":{},\"passwd\":{},\"storage\":{},\"systemd\":{}}"

  iam_instance_profile = "${var.cluster_name}-master-profile"

  root_block_device { volume_size = var.volume_size }

  vpc_security_group_ids = [data.aws_security_group.master-sg.id]

  tags = merge(
  var.default_tags,
  map(
    "Name", "${var.cluster_name}-master-$count.index}",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}