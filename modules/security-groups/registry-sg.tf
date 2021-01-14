resource "aws_security_group" "registry-sg" {
  name   = "${var.cluster_name}-registry-sg"
  vpc_id = data.aws_vpc.cluster_vpc.id

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-registry-sg",
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_security_group_rule" "registry_ingress_8080" {
  security_group_id = aws_security_group.registry-sg.id
  type              = "ingress"
  cidr_blocks       = [var.cidr_blocks]
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_security_group_rule" "registry_ingress_5000" {
  security_group_id = aws_security_group.registry-sg.id
  type              = "ingress"
  cidr_blocks       = [var.cidr_blocks]
  protocol          = "tcp"
  from_port         = 5000
  to_port           = 5000
}

resource "aws_security_group_rule" "registry_ingress_22" {
  security_group_id = aws_security_group.registry-sg.id
  type              = "ingress"
  cidr_blocks       = [var.cidr_blocks]
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_security_group_rule" "registry_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.registry-sg.id
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
