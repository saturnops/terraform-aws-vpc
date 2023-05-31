locals {
  intra_subnets                        = var.intra_subnet_enabled ? length(var.intra_subnet_cidrs) > 0 ? var.intra_subnet_cidrs : [for netnum in range(var.availability_zones * 3, var.availability_zones * 4) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
  public_subnets                       = var.public_subnet_enabled ? length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [for netnum in range(0, var.availability_zones) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
  private_subnets                      = var.private_subnet_enabled ? length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : [for netnum in range(var.availability_zones, var.availability_zones * 2) : cidrsubnet(var.vpc_cidr, 4, netnum)] : []
  database_subnets                     = var.database_subnet_enabled ? length(var.database_subnet_cidrs) > 0 ? var.database_subnet_cidrs : [for netnum in range(var.availability_zones * 2, var.availability_zones * 3) : cidrsubnet(var.vpc_cidr, 8, netnum)] : []
  single_nat_gateway                   = var.one_nat_gateway_per_az == true ? false : true
  create_database_subnet_route_table   = var.database_subnet_enabled
  create_flow_log_cloudwatch_log_group = var.flow_log_enabled == true ? true : false
  is_supported_arch                    = data.aws_ec2_instance_type.arch.supported_architectures[0] == "arm64" ? false : true # for VPN Instance
  nacl_allow_vpc_access_rule = [{
    rule_no    = 97
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = var.vpc_cidr
    }

  ]
}
data "aws_availability_zones" "available" {}
data "aws_ec2_instance_type" "arch" {
  instance_type = var.vpn_server_instance_type
}

module "vpc" {
  source                                          = "terraform-aws-modules/vpc/aws"
  version                                         = "4.0.2"
  name                                            = format("%s-%s-vpc", var.environment, var.name)
  cidr                                            = var.vpc_cidr # CIDR FOR VPC
  azs                                             = [for n in range(0, var.availability_zones) : data.aws_availability_zones.available.names[n]]
  intra_subnets                                   = local.intra_subnets
  public_subnets                                  = local.public_subnets
  private_subnets                                 = local.private_subnets
  database_subnets                                = local.database_subnets
  enable_flow_log                                 = var.flow_log_enabled
  enable_nat_gateway                              = length(local.private_subnets) > 0 ? true : false
  single_nat_gateway                              = local.single_nat_gateway
  enable_vpn_gateway                              = false
  enable_dns_hostnames                            = true
  flow_log_traffic_type                           = "ALL"
  one_nat_gateway_per_az                          = var.one_nat_gateway_per_az
  map_public_ip_on_launch                         = var.auto_assign_public_ip
  flow_log_destination_type                       = "cloud-watch-logs"
  manage_default_network_acl                      = true
  default_network_acl_ingress                     = concat(local.nacl_allow_vpc_access_rule, var.default_network_acl_ingress)
  manage_default_security_group                   = true
  default_security_group_ingress                  = [] # Enforcing no rules being present in the default security group.
  default_security_group_egress                   = []
  create_database_nat_gateway_route               = false
  create_database_subnet_route_table              = local.create_database_subnet_route_table
  create_flow_log_cloudwatch_iam_role             = var.flow_log_enabled
  create_flow_log_cloudwatch_log_group            = local.create_flow_log_cloudwatch_log_group
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days


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

  public_route_table_tags = tomap({
    "Name" = "${var.environment}-${var.name}-public-route-table"
  })

  private_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-private-subnet"
    "Subnet-group" = "private"
  })

  private_route_table_tags = tomap({
    "Name" = "${var.environment}-${var.name}-private-route-table"
  })

  database_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-database-subnet"
    "Subnet-group" = "database"
  })

  database_route_table_tags = tomap({
    "Name" = "${var.environment}-${var.name}-database-route-table"
  })

  intra_subnet_tags = tomap({
    "Name"         = "${var.environment}-${var.name}-intra-subnet"
    "Subnet-group" = "intra"
  })

  intra_route_table_tags = tomap({
    "Name" = "${var.environment}-${var.name}-intra-route-table"
  })

  igw_tags = tomap({
    "Name" = "${var.environment}-${var.name}-igw"
  })

  nat_gateway_tags = tomap({
    "Name" = "${var.environment}-${var.name}-nat"
  })

  default_network_acl_name = format("%s-%s-nacl", var.environment, var.name)
  default_network_acl_tags = {
    "Name"        = format("%s-%s-nacl", var.environment, var.name)
    "Environment" = var.environment
  }
}

module "vpn_server" {
  count                    = var.vpn_server_enabled && local.is_supported_arch ? 1 : 0
  depends_on               = [module.vpc]
  source                   = "./modules/vpn"
  name                     = var.name
  vpc_id                   = module.vpc.vpc_id
  vpc_cidr                 = var.vpc_cidr
  environment              = var.environment
  vpn_key_pair             = var.vpn_key_pair_name
  public_subnet            = module.vpc.public_subnets[0]
  vpn_server_instance_type = var.vpn_server_instance_type
}
