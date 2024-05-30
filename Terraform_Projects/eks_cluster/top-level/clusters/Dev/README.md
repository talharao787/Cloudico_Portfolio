# EKS cluster

## Use case

Manages the EKS cluster that runs the `production` environment for Railsafe product application servers.

## Resources created

This module provisions resources for a new EKS cluster. For more information, please check the [`common/eks`](../../../common/eks/) module.

## Workspaces

No workspaces.

## Remote state

| Remote state | Description                                                       |
| ------------ | ----------------------------------------------------------------- |
| vpcs          | To get a list of available subnets where to provision the cluster |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ../../../common/eks | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | [Output](https://github.com/terraform-aws-modules/terraform-aws-eks#outputs) of AWS EKS Terraform module |
| <a name="output_eks_oidc_provider"></a> [eks\_oidc\_provider](#output\_eks\_oidc\_provider) | The cluster's OIDC provider's ID and ARN |
| <a name="output_vpc_cni_irsa"></a> [vpc\_cni\_irsa](#output\_vpc\_cni\_irsa) | [Output](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks#outputs) of VPC CNI IRSA |
<!-- END_TF_DOCS -->
