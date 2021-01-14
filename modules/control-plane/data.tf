data "aws_security_group" "master-sg" {
  filter {
    name   = "tag:Name"
    values = [format("${var.cluster_name}-master-sg")]
  }
}

data "aws_lb_target_group" "int_6443_tg" {
  name = "${var.cluster_name}-6443-int-tg"
}

data "aws_lb_target_group" "int_22623_tg" {
  name = "${var.cluster_name}-22623-int-tg"
}

