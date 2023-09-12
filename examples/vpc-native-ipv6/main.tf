locals {
  name        = "skaf"
  region      = "ap-south-1"
  environment = "stage"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr     = "10.10.0.0/16"
  ipv6_enabled = true
  ipv6_only    = true
}

module "vpc" {
  source                                          = "../.."
  name                                            = local.name
  vpc_cidr                                        = local.vpc_cidr
  ipv6_only                                       = local.ipv6_only
  environment                                     = local.environment
  ipv6_enabled                                    = local.ipv6_enabled
  availability_zones                              = ["ap-south-1a", "ap-south-1b"]
  public_subnet_enabled                           = true
  private_subnet_enabled                          = true
  intra_subnet_enabled                            = true
  database_subnet_enabled                         = true
  public_subnet_assign_ipv6_address_on_creation   = true
  private_subnet_assign_ipv6_address_on_creation  = true
  database_subnet_assign_ipv6_address_on_creation = true
  intra_subnet_assign_ipv6_address_on_creation    = true
}
