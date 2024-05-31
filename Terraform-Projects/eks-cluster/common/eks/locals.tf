locals {
  cluster_name = "${var.product_name}-${var.environment}"

  tags = {
    "application-role" = "eks"
    "tier"             = "infrastructure"
    "product"          = var.product_name
    "environment"      = var.environment
  }

  addon_namespace_service_account_arn = {
    vpc-cni            = module.vpc_cni_irsa.iam_role_arn
    aws-ebs-csi-driver = module.ebs_cni_driver_irsa.iam_role_arn
  }
}
