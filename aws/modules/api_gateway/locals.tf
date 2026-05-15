locals {
  api_gateway_name = "${var.environment}-${var.project}-${var.region}-apigw"
  uri_integration  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}:$${stageVariables.lambdaAlias}/invocations"

  # Do not gate this local on the certificate ARN (unknown on first plan). enable_custom_domain defers the custom domain
  # until ACM is ISSUED without blocking the rest of the API.
  custom_domain_enabled = var.custom_domain_name != null && var.enable_custom_domain

  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
      Name        = local.api_gateway_name
    },

  )
}
