data "aws_vpc" "cluster_vpc" {
  id =  var.vpc_id
}

data "aws_lb" "control_plane_int" {
  arn =  var.control_plane_lb_int_arn
}
