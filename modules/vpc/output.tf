output "vpc_id" {
  description = "ARN of the vpcs"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}
