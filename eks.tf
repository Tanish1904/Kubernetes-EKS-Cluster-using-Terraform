module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = local.name
  cluster_version = "1.31"
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
  
  cluster_addons = {
      vpc-cni = {
        most-recent = true
      }
      kube-proxy = {
        most-recent = true
      }
      coredns = {
        anti-recent = true
      }
    }
  instance_types = ["t2.medium"]
  attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
  tws-cluster-ng = {
    instance_types = ["t2.medium"]

    min_size = 2
    max_size = 3
    desired_size = 2

    capacity_type = "SPOT"

  }
}
  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}