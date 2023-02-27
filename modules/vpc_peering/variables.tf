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
