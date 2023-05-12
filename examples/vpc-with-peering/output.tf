output "vpc_peering_connection_id" {
  description = "Peering connection ID"
  value       = module.vpc_peering.vpc_peering_connection_id
}

output "vpc_peering_accept_status" {
  description = "Accept status for the connection"
  value       = module.vpc_peering.vpc_peering_accept_status
}
