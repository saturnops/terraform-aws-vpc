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
  source = "saturnops/vpc/aws"

  name = local.name

  ipam_enabled       = local.ipam_enabled
  region             = local.region
  create_ipam_pool   = true
  vpc_cidr           = local.vpc_cidr
  availability_zones = ["us-east-1a", "us-east-1b"]

  private_subnet_enabled = true
  public_subnet_enabled  = true
}
