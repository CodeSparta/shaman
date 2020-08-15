/*
data "aws_route53_zone" "private_zone" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = aws_route53_zone.private_zone.name
  private_zone = true
}
data "terraform_remote_state" "control-plane" {
  backend = "local"
  
  config {
    path = "../control-plane/terraform.tfstate"
  }
}

data "terraform_remote_state" "elb" {
  backend = "local"
  
  config {
    path = "../elb/terraform.tfstate"
  }
}
data "aws_lb" "control_plane_int" {
  name = aws_lb.control_plane_int.dns_name
}
*/
data "aws_route53_zone" "private_zone" {
  name = "${var.cluster_domain }."
  private_zone = true
}

data "aws_subnet" "private_subnet" {
  count       =  length(var.subnet_list)
  id          = "${element(var.subnet_list, count.index)}"
}

data "terraform_remote_state" "control-plane" {
  backend = "local"
  
  config = {
    path = "../control-plane/terraform.tfstate"
  }
}

data "terraform_remote_state" "elb" {
  backend = "local"
  
  config = {
    path = "../elb/terraform.tfstate"
  }
}
