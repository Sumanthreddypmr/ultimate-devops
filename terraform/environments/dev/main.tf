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
  cluster_iam_role_arn = module.iam.eks_cluster_role_arn # ✅ full ARN now
  node_iam_role_arn    = module.iam.eks_node_role_arn
  private_subnets      = module.vpc.private_subnets
  key_name             = "" # Optional SSH
}
/*
module "secrets" {
  source         = "../../modules/secrets"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
}
*/

/*
module "ecs" {
  source = "../../modules/ecs"

  cluster_name            = "ultimate-devops-ecs"
  env                     = "dev"
  vpc_id                  = module.vpc.vpc_id
  public_subnets          = module.vpc.public_subnets
  private_subnets         = module.vpc.private_subnets
  app_sg_id               = module.vpc.app_sg_id
  ecs_task_execution_role = module.iam.ecs_task_execution_role_arn

  appointment_image       = "624480629504.dkr.ecr.us-east-1.amazonaws.com/ab-images:appointment-20250928-0406"
  patient_image           = "624480629504.dkr.ecr.us-east-1.amazonaws.com/ab-images:patient"
}
*/