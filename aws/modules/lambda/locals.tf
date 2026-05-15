locals {
  lambda_name = "${var.environment}-${var.project}-${var.region}-lambda"
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
