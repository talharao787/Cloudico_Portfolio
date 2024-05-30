resource "aws_rds_cluster_instance" "this" {
  identifier                   = "serverless-instance"
  instance_class               = "db.serverless"
  engine                       = aws_rds_cluster.this.engine
  cluster_identifier           = aws_rds_cluster.this.id
  tags                         = local.tags
  apply_immediately            = true
  preferred_maintenance_window = "fri:04:00-fri:05:00"
  auto_minor_version_upgrade   = true

  ## Security & auditability
  publicly_accessible          = false
  performance_insights_enabled = true

  ## Snapshots and backups
  copy_tags_to_snapshot = true
}
