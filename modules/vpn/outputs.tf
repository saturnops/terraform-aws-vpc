output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.vpc_id
}

output "vpn_host_public_ip" {
  description = "IP Address of VPN Server"
  value       = aws_eip.vpn.public_ip
}

output "vpn_security_group" {
  description = "Security Group ID of VPN Server"
  value       = module.security_group_vpn.security_group_id
}
