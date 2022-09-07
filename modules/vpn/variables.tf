
variable "vpn_server_instance_type" {
  description = "EC2 instance Type for VPN Server, Only amd64 based instance type are supported eg. t2.medium, t3.micro, c5a.large etc. "
  default     = "t3a.small"
  type        = string
}

variable "environment" {
  description = "Specify the environment indentifier for the VPC"
  default     = ""
  type        = string
}

variable "name" {
  description = "Specify the name of the VPC"
  default     = ""
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets CIDR inside the VPC"
  default     = []
  type        = list(any)
}

variable "region" {
  description = "Specify the region in which VPC will be created"
  default     = "us-east-1"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the Default VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  default     = ""
  type        = string
}

variable "vpn_key_pair" {
  description = "Specify the name of AWS Keypair to be used for VPN Server"
  default     = ""
  type        = string
}
