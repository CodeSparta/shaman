resource "aws_lb" "control_plane_int" {
  name = "${var.cluster_name}-int"

  load_balancer_type = "network"
  internal           = "true"
  subnets            = data.aws_subnet.private_subnet.*.id

  tags = merge(
    var.default_tags,
    map(
      "kubernetes.io/cluster/${var.cluster_name}", "shared",
      "Name", "${var.cluster_name}-int"
    )
  )
}

resource "aws_lb_listener" "control_plane_int_6443" {
  load_balancer_arn = aws_lb.control_plane_int.arn

  port     = "6443"
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.control_plane_int_6443.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "control_plane_int_22623" {
  load_balancer_arn = aws_lb.control_plane_int.arn

  port     = "22623"
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.control_plane_int_22623.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "control_plane_int_6443" {
  name                 = "${var.cluster_name}-6443-int-tg"
  port                 = 6443
  protocol             = "TCP"
  tags                 = var.default_tags
  target_type          = "ip"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 60
}

resource "aws_lb_target_group" "control_plane_int_22623" {
  name                 = "${var.cluster_name}-22623-int-tg"
  port                 = 22623
  protocol             = "TCP"
  tags                 = var.default_tags
  target_type          = "ip"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 60
}
