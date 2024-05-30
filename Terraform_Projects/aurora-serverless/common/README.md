# Aurora Serverless Database Management

## Use case

Manages Aurora Serverless Databases and their associated resources.

## Usage

```terraform
module "aurora-postgres" {
  source = "../../common"

  environment = terraform.workspace
  product     = "sqr"
  component   = "fullstack"

  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  ingress_cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc.private_subnets_cidr_blocks
  subnet_ids          = data.terraform_remote_state.vpc.outputs.vpc.database_subnets

  pg_version                 = "13.6"
}
```

## Secret Values

This module does not require a secret `env.auto.tfvars` file.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_primary_db_sg"></a> [primary\_db\_sg](#module\_primary\_db\_sg) | terraform-aws-modules/security-group/aws//modules/postgresql | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_key.db_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_secretsmanager_secret.db_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.db_credentials_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.db_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.primary_azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.db_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component"></a> [component](#input\_component) | The component name. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. | `string` | n/a | yes |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | The CIDR blocks to allow ingress from. | `list(string)` | n/a | yes |
| <a name="input_pg_version"></a> [pg\_version](#input\_pg\_version) | The PostgreSQL version to use. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | The product name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the database to. | `string` | `"eu-west-2"` | no |
| <a name="input_scaling_max_capacity"></a> [scaling\_max\_capacity](#input\_scaling\_max\_capacity) | The maximum compute capacity of the database. | `number` | `4` | no |
| <a name="input_scaling_min_capacity"></a> [scaling\_min\_capacity](#input\_scaling\_min\_capacity) | The minimum compute capacity of the database. | `number` | `0.5` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The subnet IDs to deploy the database to. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to deploy the database to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_credentials_secret_arn"></a> [database\_credentials\_secret\_arn](#output\_database\_credentials\_secret\_arn) | n/a |
| <a name="output_db_endpoint"></a> [db\_endpoint](#output\_db\_endpoint) | n/a |
| <a name="output_db_read_endpoint"></a> [db\_read\_endpoint](#output\_db\_read\_endpoint) | n/a |
<!-- END_TF_DOCS -->