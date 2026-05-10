resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy = "default"

  tags = local.common_tags
}