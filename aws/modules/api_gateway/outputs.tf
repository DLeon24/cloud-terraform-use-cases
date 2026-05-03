output "execution_arn" {
  description = "Execution ARN of the REST API for lambda permission (all stages, specific method/resource)"
  value       = "${aws_api_gateway_rest_api.this.execution_arn}/*/${var.http_method}/${var.api_resource_path}"
}

output "rest_api_id" {
  description = "REST API id"
  value       = aws_api_gateway_rest_api.this.id
}

output "custom_domain_name" {
  description = "Custom domain hostname if configured"
  value       = try(aws_api_gateway_domain_name.this[0].domain_name, null)
}

output "custom_domain_regional_domain_name" {
  description = "Regional domain name for DNS alias (Route 53 ALIAS target)"
  value       = try(aws_api_gateway_domain_name.this[0].regional_domain_name, null)
}

output "custom_domain_regional_zone_id" {
  description = "Route 53 hosted zone id for regional custom domain alias"
  value       = try(aws_api_gateway_domain_name.this[0].regional_zone_id, null)
}