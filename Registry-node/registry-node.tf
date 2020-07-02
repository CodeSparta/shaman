data "aws_security_group" "master-sg" {
  filter {
    name   = "tag:Name"
    values = [format("${var.cluster_name}-master-sg")]
  }
}

resource "aws_instance" "registry-node" {
  ami = var.rhcos_ami
  instance_type = var.ec2_type
  subnet_id = var.subnet_list[0]
  //user_data = "{\"ignition\":{\"config\":{},\"security\":{\"tls\":{}},\"timeouts\":{},\"version\":\"2.2.0\"},\"networkd\":{},\"passwd\":{\"users\":[{\"name\":\"core\",\"sshAuthorizedKeys\":[\"${trimspace(file(var.registry_ssh_public_key_file_path))}\"]}]},\"storage\":{},\"systemd\":{}}"

  root_block_device { volume_size = var.volume_size }

  vpc_security_group_ids = [data.aws_security_group.master-sg.id]

  tags = merge(
  var.default_tags,
  map(
    "Name", "${var.cluster_name}-registry-node",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
     )
   )
  }
