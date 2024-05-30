locals {
  aws_profile = {
    dev = "<your profile here>"
  }[terraform.workspace]
  aws_region   = "eu-west-2"
  product_name = "<name of your application>"
  environment = {
    dev    = "dev"
  }[terraform.workspace]

  tags = {
    "application-role" = "eks"
    "tier"             = "infrastructure"
    "product"          = local.product_name
    "environment"      = local.environment
  }
}
