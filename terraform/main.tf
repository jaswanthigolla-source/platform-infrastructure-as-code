# Main configuration — wires all modules together
# VPC outputs feed into EKS and RDS modules automatically

# ==========================================
# VPC Module
# ==========================================
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# ==========================================
# EKS Module — uses VPC outputs
# ==========================================
module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_version    = var.eks_cluster_version
  node_instance_type = var.eks_node_instance_type
  node_min_size      = var.eks_node_min_size
  node_max_size      = var.eks_node_max_size
  node_desired_size  = var.eks_node_desired_size

  depends_on = [module.vpc]
}

# ==========================================
# RDS Module — uses VPC outputs
# ==========================================
module "rds" {
  source = "./modules/rds"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  allowed_cidr_blocks = var.private_subnet_cidrs
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  instance_class      = var.db_instance_class

  depends_on = [module.vpc]
}