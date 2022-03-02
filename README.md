# AWS Virtual Private Cloud (VPC) Terraform Module

Terraform module which creates Network resources on AWS.

## Usage Example

```hcl
module "vpc" {
  source = "git::https://{GIT_USER}:{GIT_TOKEN}@gitlab.com/saturnops/sal/terraform/aws/network.git?ref=dev"

  environment                                     = var.environment
  name                                            = var.name
  region                                          = var.region
  additional_tags                                 = var.additional_tags
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.43.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group_vpn"></a> [security\_group\_vpn](#module\_security\_group\_vpn) | terraform-aws-modules/security-group/aws | ~> 4 |
| <a name="module_security_group_vpn_cis"></a> [security\_group\_vpn\_cis](#module\_security\_group\_vpn\_cis) | terraform-aws-modules/security-group/aws | ~> 4 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.77.0 |
| <a name="module_vpn_key_pair"></a> [vpn\_key\_pair](#module\_vpn\_key\_pair) | terraform-aws-modules/key-pair/aws | 0.6.0 |
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | terraform-aws-modules/ec2-instance/aws | 2.17.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.vpn](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/eip) | resource |
| [aws_iam_instance_profile.vpn_SSM](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.vpn_role](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2RoleforSSM_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [local_file.vpn_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.get_ssm_output](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.key_file](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pritunl_file](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.run_ssm_command](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_2_min](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_sec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.vpn](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu_18_ami](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.AmazonEC2RoleforSSM](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/iam_policy) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/region) | data source |
| [template_file.pritunl](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags for resources | `map(string)` | <pre>{<br>  "automation": "true"<br>}</pre> | no |
| <a name="input_application_subnets"></a> [application\_subnets](#input\_application\_subnets) | n/a | `list(any)` | `[]` | no |
| <a name="input_create_cis_vpc"></a> [create\_cis\_vpc](#input\_create\_cis\_vpc) | n/a | `bool` | `false` | no |
| <a name="input_create_database_nat_gateway_route"></a> [create\_database\_nat\_gateway\_route](#input\_create\_database\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the database subnets | `bool` | `false` | no |
| <a name="input_create_database_subnet_route_table"></a> [create\_database\_subnet\_route\_table](#input\_create\_database\_subnet\_route\_table) | Controls if separate route table for database should be created | `bool` | `false` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | n/a | `list(any)` | `[]` | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_network_acl_ingress_cis"></a> [default\_network\_acl\_ingress\_cis](#input\_default\_network\_acl\_ingress\_cis) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "rule_no": 98,<br>    "to_port": 22<br>  },<br>  {<br>    "action": "deny",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 3389,<br>    "protocol": "tcp",<br>    "rule_no": 99,<br>    "to_port": 3389<br>  },<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_network_acl_tags"></a> [default\_network\_acl\_tags](#input\_default\_network\_acl\_tags) | Additional tags for the Default Network ACL | `map(string)` | `{}` | no |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress) | List of maps of egress rules to set on the default security group | `list(map(string))` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_security_group_egress_cis"></a> [default\_security\_group\_egress\_cis](#input\_default\_security\_group\_egress\_cis) | List of maps of egress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | List of maps of ingress rules to set on the default security group | `list(map(string))` | <pre>[<br>  {<br>    "from_port": 0,<br>    "protocol": -1,<br>    "self": true,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_security_group_ingress_cis"></a> [default\_security\_group\_ingress\_cis](#input\_default\_security\_group\_ingress\_cis) | List of maps of ingress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_tags"></a> [default\_security\_group\_tags](#input\_default\_security\_group\_tags) | Additional tags for the default security group | `map(string)` | `{}` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs. | `number` | `null` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds. | `number` | `600` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | n/a | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `""` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | n/a | `bool` | `false` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(any)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ap-south-1"` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | n/a | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpn_server_enabled"></a> [vpn\_server\_enabled](#input\_vpn\_server\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_vpn_server_instance_type"></a> [vpn\_server\_instance\_type](#input\_vpn\_server\_instance\_type) | n/a | `string` | `"t3a.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__1_region"></a> [\_1\_region](#output\_\_1\_region) | AWS Region |
| <a name="output__2_vpc_id"></a> [\_2\_vpc\_id](#output\_\_2\_vpc\_id) | The ID of the VPC |
| <a name="output__3_vpc_cidr_block"></a> [\_3\_vpc\_cidr\_block](#output\_\_3\_vpc\_cidr\_block) | AWS Region |
| <a name="output__4_private_subnets"></a> [\_4\_private\_subnets](#output\_\_4\_private\_subnets) | List of IDs of private subnets |
| <a name="output__4_public_subnets"></a> [\_4\_public\_subnets](#output\_\_4\_public\_subnets) | List of IDs of public subnets |
| <a name="output__5_application_subnets"></a> [\_5\_application\_subnets](#output\_\_5\_application\_subnets) | List of IDs of application subnets |
| <a name="output__6_database_subnets"></a> [\_6\_database\_subnets](#output\_\_6\_database\_subnets) | List of IDs of database subnets |
| <a name="output__7_vpn-host-public-ip"></a> [\_7\_vpn-host-public-ip](#output\_\_7\_vpn-host-public-ip) | IP Adress of VPN Server |
| <a name="output__8_vpn_server_info_pem"></a> [\_8\_vpn\_server\_info\_pem](#output\_\_8\_vpn\_server\_info\_pem) | VPN PEM file Info |
| <a name="output__9_local_file"></a> [\_9\_local\_file](#output\_\_9\_local\_file) | Path of pem file |
| <a name="output_pritunl_info"></a> [pritunl\_info](#output\_pritunl\_info) | Pritunl Info |
| <a name="output_vpn_server_pem_file"></a> [vpn\_server\_pem\_file](#output\_vpn\_server\_pem\_file) | Warning!! ! Please Save this for future use ! |
<!-- END_TF_DOCS -->