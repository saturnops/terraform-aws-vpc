resource "aws_eip" "vpn" {
  vpc      = true
  instance = module.vpn_server.id[0]
}

module "security_group_vpn" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "template_file" "pritunl" {
  template = file("${path.module}/scripts/pritunl-vpn.sh")
}

module "vpn_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.17.0"
  name                        = format("%s-%s-%s", var.environment, var.name, "vpn-ec2-instance")
  instance_count              = 1
  ami                         = data.aws_ami.ubuntu_20_ami.image_id
  instance_type               = var.vpn_server_instance_type
  subnet_ids                  = var.public_subnets
  key_name                    = var.vpn_key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  user_data                   = join("", data.template_file.pritunl.*.rendered)
  iam_instance_profile        = join("", aws_iam_instance_profile.vpn_SSM.*.name)

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
  role       = join("", aws_iam_role.vpn_role.*.name)
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "vpn_SSM" {
  name = format("%s-%s-%s", var.environment, var.name, "vpnEC2InstanceProfile")
  role = join("", aws_iam_role.vpn_role.*.name)
}

resource "time_sleep" "wait_2_min" {
  depends_on      = [module.vpn_server]
  create_duration = "2m"
}

data "aws_iam_policy" "SecretsManagerReadWrite" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite_attachment" {
  role       = join("", aws_iam_role.vpn_role.*.name)
  policy_arn = data.aws_iam_policy.SecretsManagerReadWrite.arn
}

resource "aws_ssm_association" "ssm_association" {
  name       = aws_ssm_document.ssm_document.name
  depends_on = [time_sleep.wait_2_min]
  targets {
    key    = "InstanceIds"
    values = ["${join("", module.vpn_server.id)}"]
  }
}

resource "aws_ssm_document" "ssm_document" {
  name          = format("%s-%s-%s", var.environment, var.name, "ssm_document_create_secret")
  depends_on    = [time_sleep.wait_2_min]
  document_type = "Command"
  content       = <<DOC
  {
   "schemaVersion": "2.2",
   "description": "to create pritunl keys",
   "parameters": {
      "Message": {
         "type": "String",
         "description": "to staore pritunl key and password",
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
               "PASSWORD=$(sudo pritunl default-password | grep password | awk '{ print $2 }' | tail -n1)",               
               "aws secretsmanager create-secret --region ${var.region} --name ${var.environment}-${var.name}-vpn --secret-string \"{\\\"user\\\": \\\"pritunl\\\", \\\"password\\\": $PASSWORD, \\\"setup-key\\\": \\\"$SETUPKEY\\\"}\""
            ]
         }
      }
   ]
}
DOC
}
