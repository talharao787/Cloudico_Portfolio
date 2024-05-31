module "aurora_serverless" {
  source = "../../common"

  product     = local.product
  component   = local.component
  environment = local.environment

  pg_version = local.pg_version

  vpc_id              = data.terraform_remote_state.network_vpc.outputs.vpc.vpc_id
  subnet_ids          = data.terraform_remote_state.network_vpc.outputs.vpc.database_subnets
  ingress_cidr_blocks = data.terraform_remote_state.network_vpc.outputs.vpc.private_subnets_cidr_blocks
}

