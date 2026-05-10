locals {
  vpc_name = "${var.environment}-${var.project}-vpc-${var.region}"
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
