output "database_credentials_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "db_endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "db_read_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}
