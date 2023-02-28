output "vpc_peering_connection_id" {
  description = "Peering connection ID"
  value       = aws_vpc_peering_connection.this.id
}

output "vpc_peering_accept_status" {
  description = "Status for the connection"
  value       = aws_vpc_peering_connection_accepter.this.accept_status
}
