locals {
  lambda_name = "${var.environment}-${var.project}-lambda-${var.region}"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
      Name        = local.lambda_name
    },
  )
}
