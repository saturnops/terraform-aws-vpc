rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
    enabled = true
}

rule "terraform_documented_variables" {
    enabled = true
}

rule "terraform_typed_variables" {
    enabled = true
}

rule "terraform_required_version" {
    enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "Name",
    "Environment",
  ]
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "none"

  locals {
    format = "snake_case"
  }
}

plugin "aws" {
    enabled = true
    version = "0.14.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
