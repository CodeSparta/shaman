output "master_nodes_ids" {
  value = [for m in aws_instance.master-nodes : m.id]
}

output "master_private_ips" {
  value = [for m in aws_instance.master-nodes : m.private_ip]
}

