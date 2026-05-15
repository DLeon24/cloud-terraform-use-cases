locals {
  full_prefix          = "${var.project}-${var.environment}-${var.region}"
  instance_name        = "${local.full_prefix}-ec2"
  launch_template_name = "${local.full_prefix}-lt"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  instance_tags        = merge(local.common_tags, { Name = local.instance_name })
  launch_template_tags = merge(local.common_tags, { Name = local.launch_template_name })
  user_data_base64     = var.user_data != null ? base64encode(var.user_data) : null
}
