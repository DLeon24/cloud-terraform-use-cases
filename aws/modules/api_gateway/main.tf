resource "aws_api_gateway_rest_api" "this" {
  name        = local.api_gateway_name
  description = var.api_description
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.api_resource_path
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = local.uri_integration
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.this,
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    # Force a new deployment whenever method/integration contracts change.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this.id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_integration.this.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  for_each = var.stages

  stage_name    = each.key
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id

  variables = {
    lambdaAlias = each.key
  }
}

resource "aws_api_gateway_domain_name" "this" {
  count = local.custom_domain_enabled ? 1 : 0

  domain_name              = var.custom_domain_name
  regional_certificate_arn = var.custom_domain_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = local.common_tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  for_each = local.custom_domain_enabled ? var.custom_domain_base_path_mappings : {}

  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = each.value
  base_path   = each.key

  depends_on = [aws_api_gateway_stage.this]

  lifecycle {
    precondition {
      condition     = contains(keys(var.stages), each.value)
      error_message = "Each mapped stage (${each.value}) must be a key in var.stages."
    }
  }
}
