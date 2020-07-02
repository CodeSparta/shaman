resource "aws_security_group" "worker-sg" {
  name =  "${var.cluster_name}-worker-sg"
  vpc_id =  "${var.vpc_id}"

  tags =  merge(
  var.default_tags,
map(
"Name",  "${var.cluster_name}-worker-sg",
"kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_security_group_rule" "worker_ingress_all" {
  type              = "ingress"
  security_group_id = aws_security_group.worker-sg.id
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0", var.private_vpc_cidr]
  from_port   = 0
  to_port     = 0
}

resource "aws_security_group_rule" "worker_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.worker-sg.id
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  to_port     = 0
}
