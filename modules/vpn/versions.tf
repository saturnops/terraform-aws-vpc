terraform {
  required_version = ">= 1.0"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.23"
    }
  }
}
