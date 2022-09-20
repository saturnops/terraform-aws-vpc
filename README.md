## IAM permission Required to run this module

- AmazonVPCFullAccess
- CloudWatchFullAccess
- AmazonSSMFullAccess
- AmazonEC2FullAccess
- IAMFullAccess

# AWS Virtual Private Cloud (VPC) Terraform Module

Terraform module to create Networking resources for workload deployment on AWS Cloud.

## Usage Example

```hcl
module "vpc" {
  source = "git::https://{GIT_USER}:{GIT_TOKEN}@gitlab.com/saturnops/sal/terraform/aws/network.git?ref=dev"

  environment                                     = var.environment
  name                                            = var.name
  region                                          = var.region
  additional_aws_tags                                 = var.additional_aws_tags
  vpc_cidr                                        = var.vpc_cidr
  public_subnets                                  = var.public_subnets
}

```
## Network Scenarios

This module supports three scenarios for creating Network resource on AWS. Each will be explained in further detail in the corresponding sections.

- **vpc_minimal (default behavior):** For creating a VPC with only public subnets and IGW.
  - `vpc_cidr       = ""`
  - `public_subnets = []`
- **vpc_secure:** For creating a VPC with both public and private subnets and IGW and NAT gateway. Jump server/Bastion Host is also configured.
  - `public_subnets                    = []`  
  - `private_subnets                   = []`     
  - `enable_nat_gateway                = true`
  - `single_nat_gateway                = true`
  - `one_nat_gateway_per_az            = false`
  - `vpn_host_enabled                  = true`
  - `vpn_host_instance_type            = "t3a.small"`
  - `enable_flow_log                   = false`
  - `flow_log_max_aggregation_interval = 60`
  - `flow_log_cloudwatch_log_group_retention_in_days = 90`

- **vpc_three_tier:** For creating a VPC with public, private and database subnets ( where app and database subnets are private subnets)along with an IGW and NAT gateway. Jump server/Bastion Host is also configured.
  - `public_subnets         = []`  
  - `private_subnets        = []`  
  - `database_subnets       = []`
  - `create_database_subnet_route_table    = true`
  - `create_database_nat_gateway_route     = true`
  - `create_cis_vpc         = true`

## NAT Gateway Scenarios

This module supports three scenarios for creating NAT gateways. Each will be explained in further detail in the corresponding sections.

- One NAT Gateway per subnet (default behavior)
  - `enable_nat_gateway     = true`
  - `single_nat_gateway     = false`
  - `one_nat_gateway_per_az = false`
- Single NAT Gateway
  - `enable_nat_gateway     = true`
  - `single_nat_gateway     = true`
  - `one_nat_gateway_per_az = false`
- One NAT Gateway per availability zone
  - `enable_nat_gateway     = true`
  - `single_nat_gateway     = false`
  - `one_nat_gateway_per_az = true`

If both `single_nat_gateway` and `one_nat_gateway_per_az` are set to `true`, then `single_nat_gateway` takes precedence.

Make sure whenever you set `one_nat_gateway_per_az` to `true` you should have as many public subnets as we have AZ in the region or else this module will fail cause some `region` has more than 3 AZ like N.Virginia and we bydefault provisoning only 3 public subnets 

- To create ***CIS compliant VPC*** set the variable ***create_cis_vpc*** to ***true*** in the .tfvars file.

- To add SSL to the Pritunl endpoint:
        
        Create a DNS record mapping to the vpn host public IP.
        Login to pritunl from the credentials in the pritunl-info.txt in the pritunl folder.
        After login,in the Initial setup window, add the record created in the 'Lets Encrypt Domain' field.
        Pritunl will automatically configure a signed SSL certificate from Lets Encrypt.

        NOTE: Port 80 to be open publicly in the vpn security group to verify and renewing the domain certificate.

- Follows the VPC recommendations of CIS Amazon Web Services Foundations Benchmark v1.4.0 

[ 5. NETWORKING ]

server administration ports (Automated)

server administration ports (Automated)

(Automated)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.14.4 |
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_instance_type.arch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of Availability Zone to be used by VPC | `list(any)` | `[]` | no |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | Database Tier subnet CIDRs to be created | `list(any)` | `[]` | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "rule_no": 98,<br>    "to_port": 22<br>  },<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 3389,<br>    "protocol": "tcp",<br>    "rule_no": 99,<br>    "to_port": 3389<br>  },<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_enable_database_subnet"></a> [enable\_database\_subnet](#input\_enable\_database\_subnet) | Set true to enable database subnets | `bool` | `false` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_intra_subnet"></a> [enable\_intra\_subnet](#input\_enable\_intra\_subnet) | Set true to enable intra subnets | `bool` | `false` | no |
| <a name="input_enable_private_subnet"></a> [enable\_private\_subnet](#input\_enable\_private\_subnet) | Set true to enable private subnets | `bool` | `false` | no |
| <a name="input_enable_public_subnet"></a> [enable\_public\_subnet](#input\_enable\_public\_subnet) | Set true to enable public subnets | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Specify the environment indentifier for the VPC | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs. | `number` | `null` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds. | `number` | `60` | no |
| <a name="input_intra_subnet_cidrs"></a> [intra\_subnet\_cidrs](#input\_intra\_subnet\_cidrs) | A list of intra subnets CIDR to be created | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the VPC | `string` | `""` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Set to true if a NAT Gateway is required per availability zone for Private Subnet Tier | `bool` | `false` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | A list of private subnets CIDR to be created inside the VPC | `list(any)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | A list of public subnets CIDR to be created inside the VPC | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Specify the region in which VPC will be created | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block of the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpn_key_pair"></a> [vpn\_key\_pair](#input\_vpn\_key\_pair) | Specify the name of AWS Keypair to be used for VPN Server | `string` | `""` | no |
| <a name="input_vpn_server_enabled"></a> [vpn\_server\_enabled](#input\_vpn\_server\_enabled) | Set to true if you want to deploy VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| <a name="input_vpn_server_instance_type"></a> [vpn\_server\_instance\_type](#input\_vpn\_server\_instance\_type) | EC2 instance Type for VPN Server, Only amd64 based instance type are supported eg. t2.medium, t3.micro, c5a.large etc. | `string` | `"t3a.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_intra_subnets"></a> [intra\_subnets](#output\_intra\_subnets) | Intra Subnet IDs |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_region"></a> [region](#output\_region) | AWS Region for the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | IPV4 CIDR Block for this VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpn_host_public_ip"></a> [vpn\_host\_public\_ip](#output\_vpn\_host\_public\_ip) | IP Address of VPN Server |
| <a name="output_vpn_security_group"></a> [vpn\_security\_group](#output\_vpn\_security\_group) | Security Group ID of VPN Server |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.14.4 |
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_instance_type.arch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of Availability Zone to be used by VPC | `list(any)` | `[]` | no |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | Database Tier subnet CIDRs to be created | `list(any)` | `[]` | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "rule_no": 98,<br>    "to_port": 22<br>  },<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 3389,<br>    "protocol": "tcp",<br>    "rule_no": 99,<br>    "to_port": 3389<br>  },<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_enable_database_subnet"></a> [enable\_database\_subnet](#input\_enable\_database\_subnet) | Set true to enable database subnets | `bool` | `false` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_intra_subnet"></a> [enable\_intra\_subnet](#input\_enable\_intra\_subnet) | Set true to enable intra subnets | `bool` | `false` | no |
| <a name="input_enable_private_subnet"></a> [enable\_private\_subnet](#input\_enable\_private\_subnet) | Set true to enable private subnets | `bool` | `false` | no |
| <a name="input_enable_public_subnet"></a> [enable\_public\_subnet](#input\_enable\_public\_subnet) | Set true to enable public subnets | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Specify the environment indentifier for the VPC | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs. | `number` | `null` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds. | `number` | `60` | no |
| <a name="input_intra_subnet_cidrs"></a> [intra\_subnet\_cidrs](#input\_intra\_subnet\_cidrs) | A list of intra subnets CIDR to be created | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the VPC | `string` | `""` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Set to true if a NAT Gateway is required per availability zone for Private Subnet Tier | `bool` | `false` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | A list of private subnets CIDR to be created inside the VPC | `list(any)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | A list of public subnets CIDR to be created inside the VPC | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Specify the region in which VPC will be created | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block of the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpn_key_pair"></a> [vpn\_key\_pair](#input\_vpn\_key\_pair) | Specify the name of AWS Keypair to be used for VPN Server | `string` | `""` | no |
| <a name="input_vpn_server_enabled"></a> [vpn\_server\_enabled](#input\_vpn\_server\_enabled) | Set to true if you want to deploy VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| <a name="input_vpn_server_instance_type"></a> [vpn\_server\_instance\_type](#input\_vpn\_server\_instance\_type) | EC2 instance Type for VPN Server, Only amd64 based instance type are supported eg. t2.medium, t3.micro, c5a.large etc. | `string` | `"t3a.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_intra_subnets"></a> [intra\_subnets](#output\_intra\_subnets) | Intra Subnet IDs |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_region"></a> [region](#output\_region) | AWS Region for the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | IPV4 CIDR Block for this VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpn_host_public_ip"></a> [vpn\_host\_public\_ip](#output\_vpn\_host\_public\_ip) | IP Address of VPN Server |
| <a name="output_vpn_security_group"></a> [vpn\_security\_group](#output\_vpn\_security\_group) | Security Group ID of VPN Server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
