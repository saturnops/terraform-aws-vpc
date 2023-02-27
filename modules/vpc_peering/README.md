# VPC Peering

Module to create a VPC peering connection between two VPCs. Routes are also added to the route tables of both VPC to establish connection with peered VPC. Public DNS hostnames will be resolved to private IP addresses when queried from instances in the peer VPC.

Supported peering configurations:
* Same account same region
* Same account cross region

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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | >= 4.23 |
| <a name="provider_aws.peer"></a> [aws.peer](#provider\_aws.peer) | >= 4.23 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_route_tables.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | The ID of Acceptor VPC | `string` | `""` | no |
| <a name="input_accepter_vpc_region"></a> [accepter\_vpc\_region](#input\_accepter\_vpc\_region) | The region of Acceptor VPC | `string` | `""` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | The ID of Requester VPC | `string` | `""` | no |
| <a name="input_requester_vpc_region"></a> [requester\_vpc\_region](#input\_requester\_vpc\_region) | The region Requester VPC | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_peering_accept_status"></a> [vpc\_peering\_accept\_status](#output\_vpc\_peering\_accept\_status) | Status for the connection |
| <a name="output_vpc_peering_connection_id"></a> [vpc\_peering\_connection\_id](#output\_vpc\_peering\_connection\_id) | Peering connection ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
