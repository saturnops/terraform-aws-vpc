locals {
  region      = "us-east-1"
  environment = "stage"
  name        = "skaf"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr = "172.10.0.0/16"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "saturnops/vpc/aws"

  environment           = local.environment
  name                  = local.name
  vpc_cidr              = local.vpc_cidr
  azs                   = [for n in range(0, 3) : data.aws_availability_zones.available.names[n]]
  enable_public_subnet  = true
  enable_private_subnet = true

}
