locals {
  prefix            = "${var.project}-${var.environment}"
  full_prefix       = "${local.prefix}-${var.region}"
  alb_name          = "${local.full_prefix}-alb"
  target_group_name = "${local.full_prefix}-${lower(var.protocol)}-tg"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  alb_tags          = merge(local.common_tags, { Name = local.alb_name })
  target_group_tags = merge(local.common_tags, { Name = local.target_group_name })
}
