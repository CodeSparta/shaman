resource "aws_db_instance" "postgres_rds" {
  engine               = "postgres"
  engine_version       = "11.6"

  allocated_storage    = var.db_size
  storage_type         = "gp2"

  instance_class       = var.rds_postgres_type
  name                 = var.cluster_name
  identifier           = var.cluster_name


  username             = var.rds_user
  password             = var.rds_password
  port                 = "5432"
  deletion_protection  = false
  skip_final_snapshot  = true

  db_subnet_group_name = var.cluster_name

  tags = merge(
  var.default_tags,
  map(
    "Name", "${var.cluster_name}-postgres-db",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}