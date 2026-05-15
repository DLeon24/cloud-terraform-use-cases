locals {
  prefix               = "${var.project}-${var.environment}"
  full_prefix          = "${local.prefix}-${var.region}"
  db_instance_name     = "${local.full_prefix}-db"
  db_subnet_group_name = "${local.full_prefix}-db-subnet-group"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  db_instance_name_tags = merge(local.common_tags, { Name = local.db_instance_name })
  rds_tags              = merge(local.common_tags, { Name = local.prefix })
  db_subnet_group_tags  = merge(local.common_tags, { Name = local.db_subnet_group_name })
}
