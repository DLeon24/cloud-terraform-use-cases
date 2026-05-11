locals {
  prefix = "${var.project}-${var.environment}"
  vpc_name = "${local.prefix}-${var.region}-vpc"
  # One public subnet key per AZ; used to create one NAT per AZ.
  public_subnet_key_by_az = {
    for k, v in var.subnets : v.availability_zone => k if v.type == "public"
  }
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
      Name        = local.vpc_name
    },
  )
}
