locals {
  prefix                = "${var.project}-${var.environment}"
  full_prefix           = "${local.prefix}-${var.region}"
  instance_profile_name = "${local.full_prefix}-instance-profile"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  instance_profile_tags = merge(local.common_tags, { Name = local.instance_profile_name })
}
