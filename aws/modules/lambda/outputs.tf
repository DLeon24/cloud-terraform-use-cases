output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.this.function_name
}

output "arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.this.arn
}

output "version" {
  description = "Latest published version"
  value       = aws_lambda_function.this.version
}

output "qualified_arn" {
  description = "ARN with version qualifier"
  value       = aws_lambda_function.this.qualified_arn
}

output "aliases" {
  description = "Map of alias name to alias ARN"
  value       = { for k, v in aws_lambda_alias.this : k => v.arn }
}