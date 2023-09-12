output "region" {
  description = "AWS Region"
  value       = local.region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_ipam.vpc_id
}

output "vpc_cidr_block" {
  description = "AWS Region"
  value       = module.vpc_ipam.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_ipam.public_subnets
}
