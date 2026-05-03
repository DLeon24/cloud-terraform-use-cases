locals {
  instance_name = "${var.environment}-${var.project}-ec2-${var.region}"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
      Name        = local.instance_name
    },
  )
}