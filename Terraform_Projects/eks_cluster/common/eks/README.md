# EKS

## Use case

This is a common module that creates an AWS EKS cluster and its dependencies.

This module is a wrapper around the [`terraform-aws-eks`](https://github.com/terraform-aws-modules/terraform-aws-eks) open-source Terraform module. We use a wrapper to limit the configurability of the open-source module. This helps us to increase consistency and maintain parity between clusters.

**Note:** This module does not manage the Kubernetes resources inside the cluster (e.g. aws-auth, cluster-wide Helm releases, RBAC). For these resources, please check: [`terraform/kubernetes`](../../../kubernetes/).

## Pre-requirements

To use this module in a top-level you need to have:

- A VPC created using a top-level modules in [`terraform/vpcs`](../../../vpcs/)
- An `eks-admin` IAM role created using the [`eks-admin-role`](../../top-level/eks-admin-role/) module. The provider will assume this role and use it as "EKS creator".

## Customisations and limitations

- Allow worker nodes to be created only via [EKS managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) and [Fargate profiles](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html). These are created using the underlying sub-modules of `terraform-aws-eks`. ⚠️ There will be slight differences in the default values provided when compared to the underlying sub-modules.
  - [Full list](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/eks-managed-node-group#inputs) of configurations for EKS managed node block.
  - [Full list](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/fargate-profile#inputs) of configurations for Fargate profile block.
- Use an [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) for VPC CNI addon by default to limit nodes permissions.

## Notes

### First setup

When creating a new cluster you need to set `iam_role_attach_cni_policy` to `true` at the first apply. You can set it to false and use VPC CNI IRSA once the `aws-node` pods use the service account who's IAM role is defined in `top-level/eks-admin-role`, which has appropriate VPC permissions. Without this initial policy, the VPC CNI fails to assign IPs and nodes cannot join the cluster. See <https://github.com/aws/containers-roadmap/issues/1666> for more context.

## Usage example

```terraform
module "cluster" {
  source = "../../../common/eks"

  aws_profile  = local.aws_profile
  product_name = local.product_name
  environment  = local.environment

  cluster_version = "1.21"
  eks_addon_versions = {
    coredns    = "v1.8.4-eksbuild.1"
    kube-proxy = "v1.21.2-eksbuild.2"
    vpc-cni    = "v1.10.2-eksbuild.1"
  }

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.vpc.private_subnets

  eks_managed_node_groups = {
    spot = {
      name       = "spot-node-group"
      subnet_ids = data.terraform_remote_state.vpc.outputs.vpc.private_subnets

      min_size     = 1
      max_size     = 3
      desired_size = 1

      capacity_type  = "SPOT"
      instance_types = ["m5a.4xlarge", "m5.4xlarge"]
    }
    on-demand = {
      name = "on-demand-node-group"
      # If I want specify a single subnet or availability zone for a node group
      subnet_ids = [
        data.terraform_remote_state.vpc.outputs.vpc.private_subnets.0,
      ]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      capacity_type  = "ON_DEMAND"
      instance_types = ["m5a.4xlarge", "m5.4xlarge"]
    }
  }

  fargate_profiles = {
    one = {
      name = "fargate_one"
      subnet_ids = [
        data.terraform_remote_state.vpc.outputs.vpc.private_subnets.0,
      ]
      selectors = [{
        namespace = "my-namespace"
      }]
    }
    two = {
      name = "fargate_two"
      subnet_ids = [
        data.terraform_remote_state.vpc.outputs.vpc.private_subnets.1,
      ]
      selectors = [{
        namespace = "my-other-namespace"
      }]
    }
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_cni_driver_irsa"></a> [ebs\_cni\_driver\_irsa](#module\_ebs\_cni\_driver\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.15 |
| <a name="module_vpc_cni_irsa"></a> [vpc\_cni\_irsa](#module\_vpc\_cni\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | Name of the AWS profile to be used. This should match with the AWS account to be used.
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region to be used. This should match with the region for the AWS account to be used. | `string` | `"eu-west-2"` | no |
| <a name="input_cluster_name_override"></a> [cluster\_name\_override](#input\_cluster\_name\_override) | Let the top level module override the cluster name | `string` | `""` | no |
| <a name="input_cluster_security_group_description"></a> [cluster\_security\_group\_description](#input\_cluster\_security\_group\_description) | To specify a description for the cluster's pre-existing security group | `string` | `"EKS cluster security group"` | no |
| <a name="input_cluster_security_group_id"></a> [cluster\_security\_group\_id](#input\_cluster\_security\_group\_id) | To specify a pre-existing cluster security group | `string` | `""` | no |
| <a name="input_cluster_security_group_name"></a> [cluster\_security\_group\_name](#input\_cluster\_security\_group\_name) | To specify the name of a pre-existing cluster security group | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster | `string` | `"1.23"` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create a new cluster IAM role or use an existing one. Default is `true` to create a new IAM role | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Controls if a KMS key for cluster encryption should be created | `bool` | `false` | no |
| <a name="input_eks_addon_versions"></a> [eks\_addon\_versions](#input\_eks\_addon\_versions) | Map of EKS add-on versions | `map(string)` | <pre>{<br>  "aws-ebs-csi-driver": "v1.15.0-eksbuild.1",<br>  "coredns": "v1.8.7-eksbuild.3",<br>  "kube-proxy": "v1.23.15-eksbuild.1",<br>  "vpc-cni": "v1.12.1-eksbuild.2"<br>}</pre> | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Map of EKS managed node group definitions to create. Reference [this](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.8.1/node_groups.tf#L222-L327) for a full list of available configurations | `map(any)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment. e.g. `non-prod`, `production`, `all` | `string` | n/a | yes |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | Map of Fargate Profile definitions to create. Reference [this](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.8.1/node_groups.tf#L188-L220) for a full list of available configurations | `map(any)` | `{}` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The ARN of an pre-existing cluster IAM role, used only if the `create_iam_role` is set to `false` | `string` | `""` | no |
| <a name="input_iam_role_attach_cni_policy"></a> [iam\_role\_attach\_cni\_policy](#input\_iam\_role\_attach\_cni\_policy) | This should be set to true during cluster creation. After that, it should be set to false. | `bool` | `false` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of an pre-existing cluster IAM role, used only if the `create_iam_role` is set to `false` | `string` | `""` | no |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Name of the product | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration | `list(string)` | n/a | yes |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | Let [AWS EKS Terraform](https://github.com/terraform-aws-modules/terraform-aws-eks) module use the name prefix for the resources | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks"></a> [eks](#output\_eks) | [Output](https://github.com/terraform-aws-modules/terraform-aws-eks#outputs) of AWS EKS Terraform module |
| <a name="output_vpc_cni_irsa"></a> [vpc\_cni\_irsa](#output\_vpc\_cni\_irsa) | [Output](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks#outputs) of VPC CNI IRSA |
<!-- END_TF_DOCS -->
