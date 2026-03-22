# ==========================================
# VPC Outputs
# ==========================================
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ==========================================
# EKS Outputs
# ==========================================
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

# ==========================================
# RDS Outputs
# ==========================================
output "db_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "db_name" {
  description = "Name of the database"
  value       = module.rds.db_name
}

output "db_port" {
  description = "Port of the RDS instance"
  value       = module.rds.db_port
}