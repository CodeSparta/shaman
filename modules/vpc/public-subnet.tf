data "aws_subnet" "public" {
  count = length(var.aws_azs)
  id    = aws_subnet.pri_subnet[count.index].id
}

resource "aws_subnet" "public-subnet" {
  count                   = length(var.aws_azs)
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = element(var.vpc_public_subnet_cidrs, count.index)
  availability_zone       = format("%s%s", element(list(var.aws_region), count.index), element(var.aws_azs, count.index))
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags,
    map(
      "Name", format("${var.cluster_name}-public-%s", format("%s%s", element(list(var.aws_region), 0), element(var.aws_azs, 0))),
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}


resource "aws_route_table_association" "route_net" {
  count          = length(var.aws_azs)
  route_table_id = aws_route_table.public-route-table[0].id
  subnet_id      = aws_subnet.public-subnet[count.index].id
}

resource "aws_route_table" "public-route-table" {
  count  = length(var.aws_azs)
  vpc_id = aws_vpc.cluster_vpc.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-public-rtbl",
    "kubernetes.io/cluster/${var.cluster_name}", "owned")
  )

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet-gateway[0].id
  }
}

resource "aws_route_table_association" "public_route_table_assoc" {
  subnet_id      = aws_subnet.public-subnet[0].id
  route_table_id = aws_route_table.public-route-table[0].id
}

resource "aws_internet_gateway" "inet-gateway" {
  count  = length(var.aws_azs[0])
  vpc_id = aws_vpc.cluster_vpc.id

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-public-inet-gw",
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

