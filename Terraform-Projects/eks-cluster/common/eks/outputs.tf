output "eks" {
  value       = module.eks
  description = "[Output](https://github.com/terraform-aws-modules/terraform-aws-eks#outputs) of AWS EKS Terraform module"
}

output "vpc_cni_irsa" {
  value       = module.vpc_cni_irsa
  description = "[Output](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks#outputs) of VPC CNI IRSA"
}
