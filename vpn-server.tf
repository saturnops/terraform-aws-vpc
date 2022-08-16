data "aws_caller_identity" "current" {}

data "aws_ec2_instance_type" "arch" {
  instance_type = var.vpn_server_instance_type
}

locals {
  arch = data.aws_ec2_instance_type.arch.supported_architectures.0 == "arm64" ? "arm64" : "amd64"
}

resource "aws_eip" "vpn" {
  count    = var.vpn_server_enabled ? 1 : 0
  vpc      = true
  instance = module.vpn_server.0.id[0]
}

module "security_group_vpn" {
  count       = var.vpn_server_enabled && var.create_cis_vpc == false ? 1 : 0
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  create      = true
  name        = format("%s-%s-%s", var.environment, var.name, "vpn-sg")
  description = "vpn server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Public HTTPS access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10150
      to_port     = 10150
      protocol    = "udp"
      description = "VPN Server Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH Port"
      cidr_blocks = var.vpc_cidr
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = tomap(
    {
      "Name"        = format("%s-%s-%s", var.environment, var.name, "vpn-sg")
      "Environment" = var.environment
    },
  )
}

data "aws_ami" "ubuntu_20_ami" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-${local.arch}-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "template_file" "pritunl" {
  count = var.vpn_server_enabled ? 1 : 0
  template = file("${path.module}/scripts/pritunl-vpn.sh")
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "bootstrapping vpn Server"
EOF
}

module "vpn_server" {
  count                       = var.vpn_server_enabled ? 1 : 0
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.17.0"
  name                        = format("%s-%s-%s", var.environment, var.name, "vpn-ec2-instance")
  instance_count              = 1
  ami                         = data.aws_ami.ubuntu_20_ami.image_id
  instance_type               = var.vpn_server_instance_type
  subnet_ids                  = module.vpc.public_subnets
  key_name                    = var.vpn_key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = var.create_cis_vpc ? [module.security_group_vpn_cis.0.security_group_id] : [module.security_group_vpn.0.security_group_id]
  user_data                   = join("", data.template_file.pritunl.*.rendered)
  iam_instance_profile        = join("",aws_iam_instance_profile.vpn_SSM.*.name)

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2"
      volume_size = 20
    }
  ]

  tags = tomap(
    {
      "Name"        = format("%s-%s-%s", var.environment, var.name, "vpn-ec2-instance")
      "Environment" = var.environment
    },
  )
}

resource "aws_iam_role" "vpn_role" {
  count              = var.vpn_server_enabled ? 1 : 0
  name               = format("%s-%s-%s", var.environment, var.name, "vpnEC2InstanceRole")
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy" "SSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore_attachment" {
  count      = var.vpn_server_enabled ? 1 : 0
  role       = join("",aws_iam_role.vpn_role.*.name)
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "vpn_SSM" {
  count = var.vpn_server_enabled ? 1 : 0
  name = format("%s-%s-%s", var.environment, var.name, "vpnEC2InstanceProfile")
  role = join("",aws_iam_role.vpn_role.*.name)
}

module "security_group_vpn_cis" {
  count       = var.vpn_server_enabled && var.create_cis_vpc ? 1 : 0
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  create      = true
  name        = format("%s-%s-%s", var.environment, var.name, "vpn-sg")
  description = "vpn server security group"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = tomap(
    {
      "Name"        = format("%s-%s-%s", var.environment, var.name, "vpn-sg")
      "Environment" = var.environment
      "CIS-Compliant" = "True"
    },
  )
}

data "aws_iam_policy" "AmazonEC2RoleforSSM" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM_attachment" {
  count      = var.vpn_server_enabled ? 1 : 0
  role       = join("",aws_iam_role.vpn_role.*.name)
  policy_arn = data.aws_iam_policy.AmazonEC2RoleforSSM.arn
}

resource "time_sleep" "wait_2_min" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [module.vpn_server]
  create_duration = "2m"
}

resource "null_resource" "run_ssm_command" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [time_sleep.wait_2_min]
  provisioner "local-exec" {
    command = "aws ssm send-command --instance-ids '${join("",module.vpn_server[0].id)}'  --region ${var.region} --document-name 'AWS-RunShellScript' --parameters commands=['sudo pritunl setup-key','sudo pritunl default-password']"
  }
}

resource "time_sleep" "wait_30_sec" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [null_resource.run_ssm_command]
  create_duration = "30s"
}

resource "null_resource" "key_file" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [null_resource.run_ssm_command]
  provisioner "local-exec" {
    command = "echo Keys:   >> pritunl-info.txt"
  }
}

resource "null_resource" "get_ssm_output" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [time_sleep.wait_30_sec]
  provisioner "local-exec" {
    command = "aws ssm list-command-invocations --region ${var.region}  --instance-id '${join("",module.vpn_server[0].id)}' --details | jq --raw-output '.CommandInvocations[].CommandPlugins[].Output' >> pritunl-info.txt"
  }
}

resource "null_resource" "pritunl_file" {
  count = var.vpn_server_enabled ? 1 : 0
  depends_on = [null_resource.get_ssm_output]
  provisioner "local-exec" {
    command = "sed -i '3d' pritunl-info.txt"
  }
}
