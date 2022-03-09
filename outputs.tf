output "_1_region" {
  description = "AWS Region"
  value       = var.region
}

output "_2_vpc_id" {
  description = "The ID of the VPC"
  value = module.vpc.vpc_id
}

output "_3_vpc_cidr_block" {
  description = "AWS Region"
  value = module.vpc.vpc_cidr_block
}

output "_4_public_subnets" {
  description = "List of IDs of public subnets"
  value = length(var.public_subnets) > 0 ? module.vpc.public_subnets : null
}

output "_4_private_subnets" {
  description = "List of IDs of private subnets"
  value = length(var.private_subnets) > 0 ? module.vpc.private_subnets : null
}

output "_6_database_subnets" {
  description = "List of IDs of database subnets"
  value = length(var.database_subnets) > 0 ? module.vpc.database_subnets : null
}

output "_7_vpn-host-public-ip" {
  description = "IP Adress of VPN Server"
  value = var.vpn_server_enabled ? aws_eip.vpn.0.public_ip : null
}

output "_9_local_file" {
  description = "Path of pem file"
  value       = var.vpn_server_enabled ? format("%s-%s-%s-%s", path.module, var.environment, var.name, "vpn-key-pair.pem") : null
}

output "_8_vpn_server_info_pem" {
  description = "VPN PEM file Info "
  value = var.vpn_server_enabled ? "SAVE THIS FILE AS .pem FOR ACCESSING vpn HOST" : null
}

output "vpn_server_pem_file" {
  description = "Warning!! ! Please Save this for future use !"
  value       = var.vpn_server_enabled ? nonsensitive(tls_private_key.vpn.0.private_key_pem) : null
}

output "pritunl_info" {
  description = "Pritunl Info"
  value       = var.vpn_server_enabled ? "Please check the Pritunl keys and login credentials in 'pritunl-info.txt' file in 'pritunl' folder" : "vpn host is not enabled therefore pritunl not installed" 
}

