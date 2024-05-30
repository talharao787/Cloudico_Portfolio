module "cluster" {
  source = "../../../common/eks"

  aws_profile     = local.aws_profile
  product_name    = local.product_name
  environment     = local.environment
  use_name_prefix = true

  cluster_version = "1.28"
  eks_addon_versions = {
    coredns            = "v1.10.1-eksbuild.5"
    kube-proxy         = "v1.28.1-eksbuild.1"
    vpc-cni            = "v1.15.3-eksbuild.1"
    aws-ebs-csi-driver = "v1.23.0-eksbuild.1"
  }

// provide exact path to output here 

  vpc_id     = data.terraform_remote_state.vpc.outputs
  subnet_ids = data.terraform_remote_state.vpc.outputs

  eks_managed_node_groups = {
    dev = {
      spot = {
        name = "spot-node-group"

        min_size     = 1
        max_size     = 3
        desired_size = 1

        capacity_type  = "SPOT"
        instance_types = ["m5.2xlarge", "m5a.2xlarge", "m6i.2xlarge", "m6a.2xlarge"]
      }
    }
  }[local.environment]
}
