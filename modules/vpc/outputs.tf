output "vpc_id" {
  value = aws_vpc.cluster_vpc.id
}
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.pri_subnet.*.id
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public-subnet.*.id
}
output "az_to_private_subnet_id" {
  value = zipmap(data.aws_subnet.private.*.availability_zone, data.aws_subnet.private.*.id)
}
