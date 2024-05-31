resource "aws_db_subnet_group" "this" {
  name       = join("-", [local.full_name, "subnet-group"])
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

module "primary_db_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/postgresql"
  version = "~> 4.0"

  name                = local.full_name
  description         = "Security group for ${local.full_name}"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
}
