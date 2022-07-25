locals {
    public_subnets=var.enable_public_subnet ? length(var.public_subnets) > 0 ? var.public_subnets : [for netnum in range(0, 3) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
    private_subnets=var.enable_private_subnet ? length(var.private_subnets) > 0 ? var.private_subnets : [for netnum in range(3, 6) : cidrsubnet(var.vpc_cidr, 3, netnum)] : []
    database_subnets=var.enable_database_subnet ? length(var.database_subnets) > 0 ? var.database_subnets : [for netnum in range(6, 9) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
    intra_subnets=var.enable_intra_subnet ? length(var.intra_subnets) > 0 ? var.intra_subnets : [for netnum in range(9, 12) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
    single_nat_gateway=var.one_nat_gateway_per_az == true ? false : true   
    create_database_subnet_route_table = true
    create_database_nat_gateway_route = false
    create_flow_log_cloudwatch_log_group=var.enable_flow_log == true ? true : false 
}

module "vpc" {
  source                                          = "terraform-aws-modules/vpc/aws"
  version                                         = "2.77.0"
  name                                            = format("%s-%s-vpc", var.environment, var.name)
  cidr                                            = var.vpc_cidr # CIDR FOR VPC
  azs                                             = var.azs
  public_subnets                                  = local.public_subnets 
  private_subnets                                 = local.private_subnets 
  database_subnets                                = local.database_subnets
  intra_subnets                                   = local.intra_subnets
  create_database_subnet_route_table              = local.create_database_subnet_route_table
  create_database_nat_gateway_route               = local.create_database_nat_gateway_route
  enable_nat_gateway                              = length(local.private_subnets) > 0 ? true : false
  single_nat_gateway                              = local.single_nat_gateway
  one_nat_gateway_per_az                          = var.one_nat_gateway_per_az
  enable_dns_hostnames                            = true
  enable_vpn_gateway                              = false
  manage_default_network_acl                      = true
  default_network_acl_ingress                     = var.create_cis_vpc ? var.default_network_acl_ingress_cis : var.default_network_acl_ingress
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_traffic_type                           = "ALL"
  create_flow_log_cloudwatch_log_group            = local.create_flow_log_cloudwatch_log_group
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

  intra_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-intra-subnet"
    "Subnet-group" = "intra"
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
