output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.name.id
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.name.endpoint
}

output "rds_db_name" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.name.db_name
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "db_subnet_group_id" {
  description = "The ID of the DB subnet group"
  value       = aws_db_subnet_group.this.id
}
