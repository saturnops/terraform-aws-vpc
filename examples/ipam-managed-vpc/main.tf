locals {
  region      = "us-east-1"
  environment = "stage"
  name        = "skaf"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr     = "10.10.0.0/16"
  ipam_enabled = true
}

module "vpc_ipam" {
  source = "../.."

  name = local.name

  ipam_enabled       = local.ipam_enabled
  region             = local.region
  create_ipam_pool   = true
  vpc_cidr           = local.vpc_cidr
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  private_subnet_enabled = true
  public_subnet_enabled  = true
}
