output "region" {
  description = "AWS Region for the VPC"
  value       = var.region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "IPV4 CIDR Block for this VPC"
  value = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value = length(module.vpc.public_subnets) > 0 ? module.vpc.public_subnets : null
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value = length(module.vpc.private_subnets) > 0 ? module.vpc.private_subnets : null
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value = length(module.vpc.database_subnets) > 0 ? module.vpc.database_subnets : null
}

output "intra_subnets" {
  description = "Intra Subnet IDs"
  value = length(module.vpc.intra_subnets) > 0 ? module.vpc.intra_subnets : null

}

output "vpn_host_public_ip" {
  description = "IP Address of VPN Server"
  value = var.vpn_server_enabled ? aws_eip.vpn.0.public_ip : null
}

output "vpn_security_group" {
  description = "Security Group ID of VPN Server"
  value = var.vpn_server_enabled ? var.create_cis_vpc ? [module.security_group_vpn_cis.0.security_group_id] : [module.security_group_vpn.0.security_group_id] : null
}

output "pritunl_info" {
  description = "Pritunl Info"
  value       = var.vpn_server_enabled ? "Please check the Pritunl keys and login credentials in 'pritunl-info.txt' file." : null
}
