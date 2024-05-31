output "cluster" {
  value       = module.cluster.eks
  description = "[Output](https://github.com/terraform-aws-modules/terraform-aws-eks#outputs) of AWS EKS Terraform module"
}

output "vpc_cni_irsa" {
  value       = module.cluster.vpc_cni_irsa
}

output "eks_oidc_provider" {
  value = {
    arn = module.cluster.eks.oidc_provider_arn
    url = module.cluster.eks.oidc_provider
  }
  description = "The cluster's OIDC provider's ID and ARN"
}
