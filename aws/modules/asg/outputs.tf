output "id" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.this.arn
}

output "name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}
