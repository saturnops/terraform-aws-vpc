# Complete VPC with VPN

This configuration is suitable for production environments

A NAT Gateway, Public and Private subnet will be created per availability zone. 


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_pair_vpn"></a> [key\_pair\_vpn](#module\_key\_pair\_vpn) | git@gitlab.com:saturnops/sal/terraform/aws/ec2-keypair.git | qa |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git@gitlab.com:saturnops/sal/terraform/aws/network.git | qa |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_intra_subnets"></a> [intra\_subnets](#output\_intra\_subnets) | List of IDs of Intra subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_region"></a> [region](#output\_region) | AWS Region |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | AWS Region |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpn_host_public_ip"></a> [vpn\_host\_public\_ip](#output\_vpn\_host\_public\_ip) | IP Adress of VPN Server |
| <a name="output_vpn_security_group"></a> [vpn\_security\_group](#output\_vpn\_security\_group) | Security Group ID of VPN Server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


