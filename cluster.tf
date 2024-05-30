module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "test"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.primary_vpc.vpc_id
  subnet_ids               = module.primary_vpc.private_subnets
  control_plane_subnet_ids = module.primary_vpc.public_subnets

  eks_managed_node_groups = {
    primary = {
      min_size     = 1
      max_size     = 10
      desired_size = 3

      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true
}
