output "arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Primary domain name on the certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "DNS validation records to create (e.g. in Cloudflare, Route 53) before the certificate can be issued"
  value       = aws_acm_certificate.this.domain_validation_options
}

output "status" {
  description = "Certificate status (e.g. PENDING_VALIDATION, ISSUED)"
  value       = aws_acm_certificate.this.status
}
