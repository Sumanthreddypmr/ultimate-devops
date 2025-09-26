module "vpc" {
  source               = "../../modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

module "iam" {
  source = "../../modules/iam"
}

module "eks" {
  source               = "../../modules/eks"
  cluster_name         = "sumanth-new"
  cluster_iam_role_arn = module.iam.eks_cluster_role_arn  # ✅ full ARN now
  node_iam_role_arn    = module.iam.eks_node_role_arn
  private_subnets      = module.vpc.private_subnets
  key_name             = ""  # Optional SSH
}

