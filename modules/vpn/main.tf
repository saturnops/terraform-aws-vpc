resource "aws_eip" "vpn" {
  domain   = "vpc"
  instance = module.vpn_server.id
}

module "security_group_vpn" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.13.0"
  create      = true
  name        = format("%s-%s-%s", var.environment, var.name, "vpn-sg")
  description = "vpn server security group"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Public HTTPS access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Public HTTP access"
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "template_file" "pritunl" {
  template = file("${path.module}/scripts/pritunl-vpn.sh")
}

data "aws_region" "current" {}

module "vpn_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.1.4"
  name                        = format("%s-%s-%s", var.environment, var.name, "vpn-ec2-instance")
  ami                         = data.aws_ami.ubuntu_20_ami.image_id
  instance_type               = var.vpn_server_instance_type
  subnet_id                   = var.public_subnet
  key_name                    = var.vpn_key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  user_data                   = join("", data.template_file.pritunl[*].rendered)
  iam_instance_profile        = join("", aws_iam_instance_profile.vpn_SSM[*].name)


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
  role       = join("", aws_iam_role.vpn_role[*].name)
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "vpn_SSM" {
  name = format("%s-%s-%s", var.environment, var.name, "vpnEC2InstanceProfile")
  role = join("", aws_iam_role.vpn_role[*].name)
}

resource "time_sleep" "wait_3_min" {
  depends_on      = [module.vpn_server]
  create_duration = "3m"
}

data "aws_iam_policy" "SecretsManagerReadWrite" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite_attachment" {
  role       = join("", aws_iam_role.vpn_role[*].name)
  policy_arn = data.aws_iam_policy.SecretsManagerReadWrite.arn
}

resource "aws_ssm_association" "ssm_association" {
  name       = aws_ssm_document.ssm_document.name
  depends_on = [time_sleep.wait_3_min]
  targets {
    key    = "InstanceIds"
    values = [module.vpn_server.id]
  }
}

resource "aws_ssm_document" "ssm_document" {
  name          = format("%s-%s-%s", var.environment, var.name, "ssm_document_create_secret")
  depends_on    = [time_sleep.wait_3_min]
  document_type = "Command"
  content       = <<DOC
  {
   "schemaVersion": "2.2",
   "description": "to create pritunl keys",
   "parameters": {
      "Message": {
         "type": "String",
         "description": "to store pritunl key and password",
         "default": ""
      }
   },
   "mainSteps": [
      {
         "action": "aws:runShellScript",
         "name": "example",
         "inputs": {
            "runCommand": [
               "SETUPKEY=$(sudo pritunl setup-key)",
               "sleep 60",
               "PASSWORD=$(sudo pritunl default-password | grep password | awk '{ print $2 }' | tail -n1)",
               "sleep 60",
               "vpn_host" = ${aws_eip.vpn.public_ip}
               "aws secretsmanager create-secret --region ${data.aws_region.current.name} --name ${var.environment}-${var.name}-vpn --secret-string \"{\\\"user\\\": \\\"pritunl\\\", \\\"password\\\": $PASSWORD, \\\"setup-key\\\": \\\"$SETUPKEY\\\, \\\"vpn_host\\\": $vpn_host}\""
            ]
         }
      }
   ]
}
DOC
}

resource "null_resource" "delete_secret" {
  triggers = {
    environment = var.environment
    name        = var.name
    region      = data.aws_region.current.name
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
    aws secretsmanager delete-secret --secret-id ${self.triggers.environment}-${self.triggers.name}-vpn --force-delete-without-recovery --region ${self.triggers.region}
    EOT
  }
}
