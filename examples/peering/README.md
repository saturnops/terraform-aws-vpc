# VPC Peering

Configuration in this directory creates a VPC peering connection between two VPCs.

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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | saturnops/vpc/aws//modules/vpc-peering | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_peering_accept_status"></a> [vpc\_peering\_accept\_status](#output\_vpc\_peering\_accept\_status) | Accept status for the connection |
| <a name="output_vpc_peering_connection_id"></a> [vpc\_peering\_connection\_id](#output\_vpc\_peering\_connection\_id) | Peering connection ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
