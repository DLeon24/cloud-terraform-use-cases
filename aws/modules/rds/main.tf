resource "aws_db_instance" "name" {
  identifier             = local.db_instance_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  skip_final_snapshot    = true
  tags                   = local.db_instance_name_tags
}

resource "aws_db_subnet_group" "this" {
  name        = local.db_subnet_group_name
  description = "RDS subnet group for ${local.db_instance_name}"
  subnet_ids  = var.subnet_ids
  tags        = local.db_subnet_group_tags
}
