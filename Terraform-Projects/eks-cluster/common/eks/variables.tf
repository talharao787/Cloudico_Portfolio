variable "aws_profile" {
  type        = string
  description = "Name of the AWS profile to be used. This should match with the AWS account to be used."
}
variable "aws_region" {
  type        = string
  description = "Name of the AWS region to be used. This should match with the region for the AWS account to be used."
  default     = "eu-west-2"
}
variable "product_name" {
  type        = string
  description = "Name of the product"
}

variable "cluster_name_override" {
  type        = string
  default     = ""
  description = "Let the top level module override the cluster name"
}

variable "cluster_security_group_id" {
  type        = string
  default     = ""
  description = "To specify a pre-existing cluster security group"
}

variable "cluster_security_group_name" {
  type        = string
  default     = ""
  description = "To specify the name of a pre-existing cluster security group"
}


variable "cluster_security_group_description" {
  type        = string
  default     = "EKS cluster security group"
  description = "To specify a description for the cluster's pre-existing security group"
}

variable "use_name_prefix" {
  type        = bool
  description = "Let [AWS EKS Terraform](https://github.com/terraform-aws-modules/terraform-aws-eks) module use the name prefix for the resources"

  default = false
}

variable "iam_role_attach_cni_policy" {
  type        = bool
  description = "This should be set to true during cluster creation. After that, it should be set to false."
  default     = false
}

variable "create_iam_role" {
  type        = bool
  default     = true
  description = "Whether to create a new cluster IAM role or use an existing one. Default is `true` to create a new IAM role"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "The ARN of an pre-existing cluster IAM role, used only if the `create_iam_role` is set to `false`"
}

variable "iam_role_name" {
  type        = string
  default     = ""
  description = "The name of an pre-existing cluster IAM role, used only if the `create_iam_role` is set to `false`"
}


variable "environment" {
  type        = string
  description = "Name of the environment. e.g. `non-prod`, `production`, `all`"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster"

  default = "1.23"
}

variable "eks_addon_versions" {
  type        = map(string)
  description = "Map of EKS add-on versions"
  default = {
    coredns            = "v1.8.7-eksbuild.3"
    kube-proxy         = "v1.23.15-eksbuild.1"
    vpc-cni            = "v1.12.1-eksbuild.2"
    aws-ebs-csi-driver = "v1.15.0-eksbuild.1"
  }
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create. Reference [this](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.8.1/node_groups.tf#L222-L327) for a full list of available configurations"

  default = {}
}

variable "fargate_profiles" {
  type        = map(any)
  description = "Map of Fargate Profile definitions to create. Reference [this](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.8.1/node_groups.tf#L188-L220) for a full list of available configurations"

  default = {}
}

variable "create_kms_key" {
  type        = bool
  description = "Controls if a KMS key for cluster encryption should be created"
  default     = false
}
