data "aws_subnet" "private" {
  count = length(var.aws_azs)
  id    = aws_subnet.pri_subnet[count.index].id
}


resource "aws_subnet" "pri_subnet" {
  count             = length(var.aws_azs)
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = element(var.vpc_private_subnet_cidrs, count.index)
  availability_zone = format("%s%s", element(list(var.aws_region), count.index), element(var.aws_azs, count.index))

  tags = merge(
    var.default_tags,
    map(
      "Name", format("${var.cluster_name}-private-%s", format("%s%s", element(list(var.aws_region), count.index), element(var.aws_azs, count.index))),
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_route_table" "pri_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-pri_net_rtbl",
    "kubernetes.io/cluster/${var.cluster_name}", "owned")
  )
}

resource "aws_route_table_association" "pri_net_route_table_assoc" {
  count = length(var.aws_azs)

  subnet_id      = element(aws_subnet.pri_subnet.*.id, count.index)
  route_table_id = aws_route_table.pri_route_table.id
}
