provider "aws" {
  region = local.region
  default_tags {
    tags = local.additional_aws_tags
  }
}
