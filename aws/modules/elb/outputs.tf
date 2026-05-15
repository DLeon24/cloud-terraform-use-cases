output "id" {
  description = "ELB ID"
  value       = aws_lb.this.id
}

output "arn" {
  description = "ELB ARN"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "ELB DNS name"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.this.arn
}