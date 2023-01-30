locals {
  region      = "us-east-1"
  environment = "prod"
  name        = "skaf"
  additional_aws_tags = {
    Owner      = "SaturnOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr = "172.10.0.0/16"
}

data "aws_availability_zones" "available" {}

module "key_pair_vpn" {
  source = "saturnops/keypair/aws"
  # region             = local.region
  environment        = local.environment
  key_name           = format("%s-%s-vpn", local.environment, local.name)
  ssm_parameter_path = format("%s-%s-vpn", local.environment, local.name)
}

module "vpc" {
  source = "saturnops/vpc/aws"

  environment                                     = local.environment
  name                                            = local.name
  region                                          = local.region
  vpc_cidr                                        = local.vpc_cidr
  azs                                             = [for n in range(0, 2) : data.aws_availability_zones.available.names[n]]
  enable_public_subnet                            = true
  enable_private_subnet                           = true
  enable_database_subnet                          = true
  enable_intra_subnet                             = true
  one_nat_gateway_per_az                          = true
  vpn_server_enabled                              = true
  vpn_server_instance_type                        = "t3a.small"
  vpn_key_pair                                    = module.key_pair_vpn.key_pair_name
  enable_flow_log                                 = true
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90

}
