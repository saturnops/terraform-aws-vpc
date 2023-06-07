locals {
  requester_route_tables_ids = data.aws_route_tables.requester.ids
  accepter_route_tables_ids  = data.aws_route_tables.accepter.ids
}

provider "aws" {
  alias  = "peer"
  region = var.requester_vpc_region
}

provider "aws" {
  alias  = "accepter"
  region = var.accepter_vpc_region
}

data "aws_vpc" "accepter" {
  id       = var.accepter_vpc_id
  provider = aws.accepter
}

data "aws_route_tables" "accepter" {
  vpc_id   = var.accepter_vpc_id
  provider = aws.accepter
}

data "aws_vpc" "requester" {
  id       = var.requester_vpc_id
  provider = aws.peer
}

data "aws_route_tables" "requester" {
  vpc_id   = var.requester_vpc_id
  provider = aws.peer
}

resource "aws_vpc_peering_connection" "this" {
  count       = var.peering_enabled ? 1 : 0
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  peer_region = var.accepter_vpc_region
  auto_accept = false
  provider    = aws.peer
  tags = {
    Name = format("%s-%s-%s", var.requester_name, "to", var.accepter_name)
  }
}

resource "aws_vpc_peering_connection_accepter" "this" {
  count                     = var.peering_enabled ? 1 : 0
  depends_on                = [aws_vpc_peering_connection.this]
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
  auto_accept               = true
  tags = {
    Name = format("%s-%s-%s", var.requester_name, "to", var.accepter_name)
  }
}

resource "aws_vpc_peering_connection_options" "this" {
  count                     = var.peering_enabled ? 1 : 0
  depends_on                = [aws_vpc_peering_connection_accepter.this]
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  provider = aws.accepter
}


####  route tables ####

resource "aws_route" "requester" {
  count                     = var.peering_enabled ? length(local.requester_route_tables_ids) : 0
  route_table_id            = local.requester_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block
  vpc_peering_connection_id = var.peering_enabled ? aws_vpc_peering_connection.this[0].id : null
  provider                  = aws.peer
}

resource "aws_route" "accepter" {
  count                     = var.peering_enabled ? length(local.accepter_route_tables_ids) : 0
  route_table_id            = local.accepter_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.requester.cidr_block
  vpc_peering_connection_id = var.peering_enabled ? aws_vpc_peering_connection.this[0].id : null
  provider                  = aws.accepter
}
