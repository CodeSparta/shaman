# private S3 endpoint
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "private_s3" {
  vpc_id       = aws_vpc.cluster_vpc.id
  service_name = data.aws_vpc_endpoint_service.s3.service_name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Principal": "*",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  tags = merge(
    var.default_tags,
    map(
      "Name", format("${var.cluster_name}-pri-s3-vpce"),
    "kubernetes.io/cluster/${var.cluster_name}", "owned")
  )
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = length(var.aws_azs)

  vpc_endpoint_id = aws_vpc_endpoint.private_s3.id
  route_table_id  = aws_route_table.pri_route_table.id
}

## private ec2 endpoint
data "aws_vpc_endpoint_service" "ec2" {
  service = "ec2"
}

resource "aws_security_group" "private_ec2_api" {
  name   = "${var.cluster_name}-ec2-api"
  vpc_id = aws_vpc.cluster_vpc.id

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-private-ec2-api",
    )
  )
}

resource "aws_security_group_rule" "private_ec2_ingress" {
  type = "ingress"

  from_port = 0
  to_port   = 0
  protocol  = "all"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.private_ec2_api.id
}

resource "aws_security_group_rule" "private_ec2_api_egress" {
  type = "egress"

  from_port = 0
  to_port   = 0
  protocol  = "all"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.private_ec2_api.id
}

resource "aws_vpc_endpoint" "private_ec2" {
  vpc_id            = aws_vpc.cluster_vpc.id
  service_name      = data.aws_vpc_endpoint_service.ec2.service_name
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.private_ec2_api.id
  ]

  subnet_ids = aws_subnet.pri_subnet.*.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-ec2-vpce"
    )
  )
}

data "aws_vpc_endpoint_service" "elasticloadbalancing" {
  service = "elasticloadbalancing"
}

resource "aws_security_group" "private_elb_api" {
  name   = "${var.cluster_name}-elb-api"
  vpc_id = aws_vpc.cluster_vpc.id

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-private-elb-api",
    )
  )
}

resource "aws_security_group_rule" "private_elb_ingress" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "all"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.private_elb_api.id
}

resource "aws_security_group_rule" "private_elb_api_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "all"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.private_elb_api.id
}

resource "aws_vpc_endpoint" "elasticloadbalancing" {
  vpc_id              = aws_vpc.cluster_vpc.id
  service_name        = data.aws_vpc_endpoint_service.elasticloadbalancing.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.private_ec2_api.id
  ]

  subnet_ids = aws_subnet.pri_subnet.*.id
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-elb-vpce"
    )
  )
}
