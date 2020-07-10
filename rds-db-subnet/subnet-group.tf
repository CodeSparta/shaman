resource "aws_db_subnet_group" "rds" {
  name       = var.cluster_name
  subnet_ids = var.subnet_list
  tags = {
    Name = "${var.cluster_name}-Postgres_DB"
  }
}