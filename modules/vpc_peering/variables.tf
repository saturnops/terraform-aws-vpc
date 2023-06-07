variable "accepter_vpc_id" {
  type        = string
  description = "Specify the unique identifier of the VPC that will act as the Acceptor in the VPC peering connection."
  default     = ""
}

variable "accepter_vpc_region" {
  type        = string
  description = "Provide the AWS region where the Acceptor VPC is located. This helps in identifying the correct region for establishing the VPC peering connection."
  default     = ""
}

variable "requester_vpc_id" {
  type        = string
  description = "Specify the unique identifier of the VPC that will act as the Reqester in the VPC peering connection."
  default     = ""
}

variable "requester_vpc_region" {
  type        = string
  description = "Specify the AWS region where the Requester VPC resides. It ensures the correct region is used for setting up the VPC peering."
  default     = ""
}

variable "requester_name" {
  type        = string
  description = "Provide a descriptive name or label for the VPC Requester. This helps identify and differentiate the Requester VPC in the peering connection."
  default     = ""
}

variable "accepter_name" {
  type        = string
  description = "Assign a meaningful name or label to the VPC Accepter. This aids in distinguishing the Accepter VPC within the VPC peering connection."
  default     = ""
}

variable "peering_enabled" {
  type        = bool
  description = "Set this variable to true if you want to create the VPC peering connection. Set it to false if you want to skip the creation process."
  default     = true
}
