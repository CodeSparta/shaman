output "master_sg_id" {
  value = aws_security_group.master-sg.id
}

output "worker_sg_id" {
  value = aws_security_group.worker-sg.id
}

output "registry_sg_id" {
  value = aws_security_group.registry-sg.id
}
