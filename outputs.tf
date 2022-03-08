output "_1_region" {
  description = "AWS Region"
  value       = var.region
}

output "_2_vpc_id" {
  value = module.vpc.vpc_id
}

output "_3_vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "_4_public_subnets" {
  value = module.vpc.public_subnets
}

output "_4_private_subnets" {
  value = module.vpc.private_subnets
}

output "_6_database_subnets" {
  value = module.vpc.database_subnets
}

output "_7_vpn-host-public-ip" {
  value = var.vpn_server_enabled ? aws_eip.vpn.0.public_ip : null
}

output "_9_local_file" {
  description = "Path of pem file"
  value       = var.vpn_server_enabled ? format("%s-%s-%s-%s", path.module, var.environment, var.name, "vpn-key-pair.pem") : null
}

output "_8_vpn_server_info_pem" {
  value = var.vpn_server_enabled ? "SAVE THIS FILE AS .pem FOR ACCESSING vpn HOST" : null
}

output "vpn_server_pem_file" {
  description = "Warning!! ! Please Save this for future use !"
  value       = var.vpn_server_enabled ? nonsensitive(tls_private_key.vpn.0.private_key_pem) : null
}

output "pritunl_info" {
  value       = var.vpn_server_enabled ? "Please check the Pritunl keys and login credentials in 'pritunl-info.txt' file in 'pritunl' folder" : "vpn host is not enabled therefore pritunl not installed" 
}

