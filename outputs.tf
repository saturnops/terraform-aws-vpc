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
  value = length(var.public_subnets) > 0 ? module.vpc.public_subnets : null
}

output "_4_private_subnets" {
  value = length(var.private_subnets) > 0 ? module.vpc.private_subnets : null
}

output "_5_application_subnets" {
  value = length(var.application_subnets) > 0 ? module.vpc.private_subnets : null
}

output "_6_database_subnets" {
  value = length(var.database_subnets) > 0 ? module.vpc.database_subnets : null
}

output "_7_bastion-host-public-ip" {
  value = var.bastion_host_enabled ? aws_eip.bastion.0.public_ip : null
}

output "_9_local_file" {
  description = "Path of pem file"
  value       = var.bastion_host_enabled ? format("%s-%s-%s-%s", path.module, var.environment, var.name, "bastion-key-pair.pem") : null
}

output "_8_bastion_host_info_pem" {
  value = var.bastion_host_enabled ? "SAVE THIS FILE AS .pem FOR ACCESSING BASTION HOST" : null
}

output "bastion_host_pem_file" {
  description = "Warning!! ! Please Save this for future use !"
  value       = var.bastion_host_enabled ? nonsensitive(tls_private_key.bastion.0.private_key_pem) : null
}

output "pritunl_info" {
  value       = var.bastion_host_enabled ? "Please check the Pritunl keys and login credentials in 'pritunl-info.txt' file in 'pritunl' folder" : "Bastion host is not enabled therefore pritunl not installed" 
}

