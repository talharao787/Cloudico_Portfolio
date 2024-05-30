output "database_credentials_secret_arn" {
  value = module.aurora_serverless.database_credentials_secret_arn
}

output "db_endpoint" {
  value = module.aurora_serverless.db_endpoint
}

output "db_read_endpoint" {
  value = module.aurora_serverless.db_read_endpoint
}
