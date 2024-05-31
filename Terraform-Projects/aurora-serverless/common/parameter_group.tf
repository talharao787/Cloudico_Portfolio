resource "aws_rds_cluster_parameter_group" "this" {
  name_prefix = join("-", [var.product, var.environment, "parameter-group-${local.pg_family}-"])
  family      = local.pg_family
  description = "Aurora cluster parameter group for ${var.product} - ${var.environment} based on ${local.pg_family}."
}
