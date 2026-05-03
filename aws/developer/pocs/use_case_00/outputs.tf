output "lambda_name" {
  description = "Lambda function name from module lambda_orders"
  value       = module.lambda_orders.function_name
}

output "lambda_arn" {
  description = "Lambda function ARN from module lambda_orders"
  value       = module.lambda_orders.arn
}

output "lambda_version" {
  description = "Latest published version from module lambda_orders"
  value       = module.lambda_orders.version
}

output "lambda_aliases" {
  description = "Map of alias name to ARN from module lambda_orders"
  value       = module.lambda_orders.aliases
}

output "api_custom_domain_url" {
  description = "HTTPS base URL for the custom domain; resources live under /dev/... and /prod/... per custom_domain_base_path_mappings"
  value       = module.api_gateway_orders.custom_domain_name != null ? "https://${module.api_gateway_orders.custom_domain_name}" : null
}

output "api_custom_domain_dns_target" {
  description = "Create in your DNS service (e.g. Cloudflare, Route 53) ALIAS A/AAAA (or CNAME) to this name in the hosted zone for domain_name"
  value = module.api_gateway_orders.custom_domain_regional_domain_name != null ? {
    name                   = module.api_gateway_orders.custom_domain_regional_domain_name
    zone_id                = module.api_gateway_orders.custom_domain_regional_zone_id
    evaluate_target_health = false
  } : null
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN attached to the custom domain"
  value       = module.acm_certificate.arn
}
