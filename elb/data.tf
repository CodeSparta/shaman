data "aws_subnet" "private_subnet" {
  count       =  length(var.subnet_list)
id          = "${element(var.subnet_list, count.index)}"
}
