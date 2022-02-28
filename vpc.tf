data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
module "vpc" {
  source                                          = "terraform-aws-modules/vpc/aws"
  version                                         = "2.77.0"
  name                                            = format("%s-%s-vpc", var.environment, var.name)
  cidr                                            = var.vpc_cidr # CIDR FOR VPC
  azs                                             = data.aws_availability_zones.available.names
  public_subnets                                  = var.public_subnets                                                                                                           # CIDR FOR PUBLIC SUBNETS
  private_subnets                                 = length(var.private_subnets) > 0 ? var.private_subnets : (length(var.application_subnets) > 0 ? var.application_subnets : []) # CIDR FOR PRIVATE SUBNETS
  database_subnets                                = var.database_subnets
  create_database_subnet_route_table              = var.create_database_subnet_route_table
  create_database_nat_gateway_route               = var.create_database_nat_gateway_route
  enable_nat_gateway                              = var.enable_nat_gateway
  single_nat_gateway                              = var.single_nat_gateway
  one_nat_gateway_per_az                          = var.one_nat_gateway_per_az
  enable_dns_hostnames                            = true
  enable_vpn_gateway                              = false
  manage_default_network_acl                      = true
  default_network_acl_ingress                     = var.create_cis_vpc ? var.default_network_acl_ingress_cis : var.default_network_acl_ingress
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_traffic_type                           = "ALL"
  create_flow_log_cloudwatch_log_group            = true
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  manage_default_security_group                   = var.create_cis_vpc ? true : false
  default_security_group_ingress                  = var.create_cis_vpc ? var.default_security_group_ingress_cis : var.default_security_group_ingress
  default_security_group_egress                   = var.create_cis_vpc ? var.default_security_group_egress_cis : var.default_security_group_egress

  # TAGS TO BE ASSOCIATED WITH EACH RESOURCE

  tags = tomap(
    {
      "Name"        = format("%s-%s-vpc", var.environment, var.name)
      "Environment" = var.environment
    },
  )

  public_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-public-subnet"
    "Subnet-group" = "public"
  })

  private_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-private-subnet"
    "Subnet-group" = "private"
  })

  database_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-database-subnet"
    "Subnet-group" = "database"
  })

  # TAGGING FOR DEFAULT NACL

  default_network_acl_name = format("%s-%s-nacl", var.environment, var.name)
  default_network_acl_tags = {
    "Name"        = format("%s-%s-nacl", var.environment, var.name)
    "Environment" = var.environment
    "CIS-Compliant" = var.create_cis_vpc ? "True" : "False"
  }
  default_security_group_tags = {
    "CIS-Compliant" = var.create_cis_vpc ? "True" : "False"
  }
}