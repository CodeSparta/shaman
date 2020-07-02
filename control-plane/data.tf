data "aws_security_group" "master-sg" {
  filter {
    name   = "tag:Name"
    values = [format("${var.cluster_name}-master-sg")]
  }
}