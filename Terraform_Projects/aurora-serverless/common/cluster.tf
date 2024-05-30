resource "aws_rds_cluster" "this" {
  # Configuration
  cluster_identifier_prefix    = local.full_name
  database_name                = var.product
  engine_mode                  = "provisioned"
  engine                       = local.engine_name
  engine_version               = var.pg_version
  source_region                = var.region
  allow_major_version_upgrade  = true
  port                         = "5432"
  deletion_protection          = true
  apply_immediately            = true
  preferred_maintenance_window = "fri:04:00-fri:05:00"
  tags                         = local.tags

  ## Serverless config
  serverlessv2_scaling_configuration {
    max_capacity = var.scaling_max_capacity
    min_capacity = var.scaling_min_capacity
  }

  ## Security & auditability
  vpc_security_group_ids              = [module.primary_db_sg.security_group_id]
  availability_zones                  = data.aws_availability_zones.primary_azs.names
  db_subnet_group_name                = aws_db_subnet_group.this.name
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.this.name
  master_username                     = random_string.db_username.result
  master_password                     = random_password.db_password.result
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.db_kms_key.arn
  enabled_cloudwatch_logs_exports     = ["${trimprefix(local.engine_name, "aurora-")}"]
  iam_database_authentication_enabled = false

  ## Snapshots and backups
  copy_tags_to_snapshot     = true
  skip_final_snapshot       = true
  final_snapshot_identifier = join("-", [local.full_name, "final-snapshot"])
  preferred_backup_window   = "03:00-04:00"
  backup_retention_period   = 14
}
