locals {
  region      = "us-east-1"
  environment = "dev"
  name        = "skaf"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr = "10.10.0.0/16"
}

module "vpc" {
  source                = "saturnops/vpc/aws"
  name                  = local.name
  vpc_cidr              = local.vpc_cidr
  environment           = local.environment
  availability_zones    = 2
  public_subnet_enabled = true
  auto_assign_public_ip = true
}
