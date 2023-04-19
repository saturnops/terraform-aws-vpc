variable "accepter_vpc_id" {
  type        = string
  description = "The ID of Acceptor VPC"
  default     = ""
}

variable "accepter_vpc_region" {
  type        = string
  description = "The region of Acceptor VPC"
  default     = ""
}

variable "requester_vpc_id" {
  type        = string
  description = "The ID of Requester VPC"
  default     = ""
}

variable "requester_vpc_region" {
  type        = string
  description = "The region Requester VPC"
  default     = ""
}


variable "create" {
  description = "Set it to true to create VPC peering"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name for the VPC peering"
  type        = string
  default     = ""
}
