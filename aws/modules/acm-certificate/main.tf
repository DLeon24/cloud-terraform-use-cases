resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"

  options {
    export = "DISABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}
