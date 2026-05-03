locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
      Name        = var.domain_name
    },
  )
}
