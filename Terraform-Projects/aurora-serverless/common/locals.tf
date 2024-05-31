locals {
  full_name = "${var.product}-${var.component}-database-${var.environment}"

  tags = {
    "application-role" = "database"
    "tier"             = "infrastructure"
    "product"          = var.product
    "environment"      = var.environment
  }
  engine_name = "aurora-postgresql"
  pg_version  = var.pg_version
  pg_family   = "${local.engine_name}${trimsuffix(local.pg_version, regex("[.][0-9]+$", local.pg_version))}"
}
