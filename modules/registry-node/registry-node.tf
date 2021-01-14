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

data "aws_route53_zone" "private_zone" {
  name         = "${var.cluster_name}.${var.cluster_domain}."
  private_zone = true
}

resource "aws_instance" "registry-node" {
  ami           = var.rhcos_ami
  instance_type = var.registry_type
  subnet_id     = local.instance_subnet_id
  user_data     = "{\"ignition\": {\"version\":\"3.1.0\"},\"passwd\":{\"users\":[{\"name\": \"core\",\"passwordHash\": \"\",\"sshAuthorizedKeys\":[\"${var.ssh_public_key}\"]}]}}"


  root_block_device { volume_size = var.registry_volume }
  security_groups             = var.registry_sg_ids
  associate_public_ip_address = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-registry-node",
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_route53_record" "registry-entry" {
  zone_id         = data.aws_route53_zone.private_zone.id
  name            = "registry.${data.aws_route53_zone.private_zone.name}"
  type            = "A"
  ttl             = "300"
  records         = ["${aws_instance.registry-node.private_ip}"]
  allow_overwrite = true
}
