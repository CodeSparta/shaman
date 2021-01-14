resource "aws_route53_zone" "private_zone" {
  name = "${var.cluster_name}.${var.cluster_domain}"
  vpc {
    vpc_id = data.aws_vpc.cluster_vpc.id
  }
  force_destroy = "true"

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}.${var.cluster_domain}",
      "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}
