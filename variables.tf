variable "additional_tags" {
  description = "Tags for resources "
  type        = map(string)
  default = {
    automation = "true"
  }
}

variable "application_subnets" {
  default = []
  type    = list(any)
}

variable "vpn_server_enabled" {
  default = false
  type    = bool
}

variable "vpn_server_instance_type" {
  default = "t3a.small"
  type    = string
}

variable "create_database_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
  type        = bool
  default     = false
}

variable "create_database_subnet_route_table" {
  description = "Controls if separate route table for database should be created"
  type        = bool
  default     = false
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "database_subnets" {
  default = []
  type    = list(any)
}

variable "default_network_acl_tags" {
  description = "Additional tags for the Default Network ACL"
  type        = map(string)
  default     = {}
}

variable "default_security_group_egress" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default     = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "default_security_group_ingress" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default     = [
    {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
    }
  ]
}

variable "default_security_group_tags" {
  description = "Additional tags for the default security group"
  type        = map(string)
  default     = {}
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  default = false
  type    = bool
}

variable "environment" {
  default = ""
  type    = string
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
  type        = number
  default     = null
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds."
  type        = number
  default     = 600
}

variable "manage_default_security_group" {
  default = false
  type    = bool
}

variable "name" {
  default = ""
  type    = string
}

variable "one_nat_gateway_per_az" {
  default = false
  type    = bool
}

variable "public_subnets" {
  default = []
  type    = list(any)
}

variable "private_subnets" {
  default = []
  type    = list(any)
}

variable "region" {
  default = "ap-south-1"
  type    = string
}

variable "single_nat_gateway" {
  default = false
  type    = bool
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}


variable "create_cis_vpc" {
  default  = false
  type      = bool
}

variable "default_network_acl_ingress_cis" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 98
      action     = "deny"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 99
      action     = "deny"
      from_port  = 3389
      to_port    = 3389
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_security_group_egress_cis" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_ingress_cis" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "enable_public_subnet" {
  default = false
  type    = bool
}

variable "enable_private_subnet" {
  default = false
  type    = bool
}

variable "enable_database_subnet" {
  default = false
  type    = bool
}