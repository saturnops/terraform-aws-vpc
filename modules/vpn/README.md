# VPN

Terraform module to create Pritunl VPN server on AWS.

Pritunl is an VPN software with features including but not limited to:
- Open Source
- Supports multiple protocols
- Supports Single Sign-On
- Highly secure

Refer [this](https://pritunl.com/) for more information.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.29.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group_vpn"></a> [security\_group\_vpn](#module\_security\_group\_vpn) | terraform-aws-modules/security-group/aws | 4.13.0 |
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | terraform-aws-modules/ec2-instance/aws | 4.1.4 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.vpn_SSM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.vpn_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.SecretsManagerReadWrite_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_association.ssm_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.ssm_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [time_sleep.wait_2_min](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_ami.ubuntu_20_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.SecretsManagerReadWrite](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [template_file.pritunl](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Specify the environment indentifier for the VPC | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the VPC | `string` | `""` | no |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | The VPC Subnet ID to launch in | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Specify the region in which VPC will be created | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block of the Default VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | `""` | no |
| <a name="input_vpn_key_pair"></a> [vpn\_key\_pair](#input\_vpn\_key\_pair) | Specify the name of AWS Keypair to be used for VPN Server | `string` | `""` | no |
| <a name="input_vpn_server_instance_type"></a> [vpn\_server\_instance\_type](#input\_vpn\_server\_instance\_type) | EC2 instance Type for VPN Server, Only amd64 based instance type are supported eg. t2.medium, t3.micro, c5a.large etc. | `string` | `"t3a.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region"></a> [region](#output\_region) | AWS Region for the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpn_host_public_ip"></a> [vpn\_host\_public\_ip](#output\_vpn\_host\_public\_ip) | IP Address of VPN Server |
| <a name="output_vpn_security_group"></a> [vpn\_security\_group](#output\_vpn\_security\_group) | Security Group ID of VPN Server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
