output "arn" {
  value = aws_iam_role.this.arn
}

output "name" {
  value = aws_iam_role.this.name
}

output "instance_profile_name" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}
