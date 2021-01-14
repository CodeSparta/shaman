data "aws_vpc" "cluster_vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.cluster_vpc.id

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}


resource "random_id" "index" {
  byte_length = 2
}

locals {
  subnet_ids_list         = tolist(data.aws_subnet_ids.public.ids)
  subnet_ids_random_index = random_id.index.dec % length(data.aws_subnet_ids.public.ids)
  instance_subnet_id      = local.subnet_ids_list[local.subnet_ids_random_index]
}

resource "aws_instance" "bastion-node" {
  ami           = var.bastion_ami
  instance_type = var.bastion_type
  subnet_id     = local.instance_subnet_id
  key_name      = var.aws_ssh_key
  root_block_device { volume_size = var.bastion_disk }

  security_groups = var.master_sg_ids

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-bastion-node"
    )
  )
  lifecycle {
    ignore_changes = [subnet_id]
  }
}
