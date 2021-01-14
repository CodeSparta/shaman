output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, bastion-node is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.bastion-node.*.public_dns
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.bastion-node.*.public_ip
}

