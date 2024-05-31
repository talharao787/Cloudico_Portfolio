module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"
  providers = {
    aws = aws.eks-admin
  }

  cluster_name    = var.cluster_name_override == "" ? local.cluster_name : var.cluster_name_override
  cluster_version = var.cluster_version

  cluster_endpoint_public_access         = true
  cluster_endpoint_private_access        = false
  cluster_security_group_use_name_prefix = var.use_name_prefix
  node_security_group_use_name_prefix    = var.use_name_prefix
  iam_role_use_name_prefix               = var.use_name_prefix
  create_iam_role                        = var.create_iam_role
  iam_role_arn                           = var.create_iam_role == false ? var.iam_role_arn : null
  iam_role_name                          = var.create_iam_role == false ? var.iam_role_name : null

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_timeouts = {
    create = "30m",
    delete = "30m",
  }

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = var.iam_role_attach_cni_policy
  }
  eks_managed_node_groups = var.eks_managed_node_groups

  fargate_profile_defaults = {
    iam_role_attach_cni_policy = var.iam_role_attach_cni_policy
  }
  fargate_profiles = var.fargate_profiles

  cluster_addons = {
    for addon_name, addon_version in var.eks_addon_versions : addon_name => {
      addon_version            = addon_version
      preserve                 = true
      service_account_role_arn = lookup(local.addon_namespace_service_account_arn, addon_name, null)
    }
  }

  cluster_security_group_id          = var.cluster_security_group_id != "" ? var.cluster_security_group_id : null
  cluster_security_group_name        = var.cluster_security_group_name != "" ? var.cluster_security_group_name : null
  cluster_security_group_description = var.cluster_security_group_description

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow all node-to-node traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
  create_kms_key            = var.create_kms_key
  cluster_encryption_config = []
  tags                      = local.tags
}

module "vpc_cni_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc-cni-irsa-${module.eks.cluster_name}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

module "ebs_cni_driver_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-cni-driver-irsa-${module.eks.cluster_name}"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa", "kube-system:ebs-csi-node-sa"]
    }
  }
}
