<<<<<<< HEAD
# vpc-with-private-sub
=======
# VPC with Private Subnets


A public and private subnet will be created per availability zone in addition to single NAT Gateway shared between all availability zones.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.

>>>>>>> 2c8b0b1786837923aa83804660386faa61ead176

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
<<<<<<< HEAD
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git@gitlab.com:saturnops/sal/terraform/aws/network.git | qa |
=======
| <a name="module_vpc"></a> [vpc](#module\_vpc) | saturnops/vpc/aws | n/a |
>>>>>>> 2c8b0b1786837923aa83804660386faa61ead176

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
<<<<<<< HEAD
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
=======
>>>>>>> 2c8b0b1786837923aa83804660386faa61ead176

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_region"></a> [region](#output\_region) | AWS Region |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | AWS Region |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
