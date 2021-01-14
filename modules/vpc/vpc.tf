resource "aws_vpc" "cluster_vpc" {
  cidr_block           = var.cidr_blocks
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}",
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}
