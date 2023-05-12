locals {
  region = "us-east-2"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "vpc_accepter" {
  source                = "saturnops/vpc/aws"
  name                  = "accepter"
  vpc_cidr              = "10.10.0.0/16"
  environment           = "dev"
  availability_zones    = 2
  public_subnet_enabled = true
}

module "vpc_requester" {
  source                = "saturnops/vpc/aws"
  name                  = "requester"
  vpc_cidr              = "172.10.0.0/16"
  environment           = "uat"
  availability_zones    = 2
  public_subnet_enabled = true
}

output "vpc_id_accepter" {
  description = "The ID of the accepter VPC"
  value       = module.vpc_accepter.vpc_id
}

output "vpc_id_requester" {
  description = "The ID of the requester VPC"
  value       = module.vpc_requester.vpc_id
}
