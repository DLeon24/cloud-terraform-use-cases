locals {
  prefix      = "${var.project}-${var.environment}"
  full_prefix = "${local.prefix}-${var.region}"
  asg_name    = "${local.full_prefix}-asg"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  asg_tags = merge(local.common_tags, { Name = local.asg_name })
}
