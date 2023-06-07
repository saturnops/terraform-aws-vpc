locals {
  accepter_name    = "tenent-peering"
  accepter_region  = "us-east-2"
  accepter_vpc_id  = "vpc-049f2peerb195d692"
  requester_name   = "management-peering"
  requester_region = "us-east-2"
  requester_vpc_id = "vpc-0125epeere8cfb616"
  additional_tags = {
    Owner   = "tenent"
    Tenancy = "dedicated"
  }
}

module "vpc_peering" {
  source               = "saturnops/vpc/aws//modules/vpc_peering"
  accepter_name        = local.accepter_name
  accepter_vpc_id      = local.accepter_vpc_id
  accepter_vpc_region  = local.accepter_region
  requester_name       = local.requester_name
  requester_vpc_id     = local.requester_vpc_id
  requester_vpc_region = local.requester_region
}
