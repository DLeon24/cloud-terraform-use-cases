resource "aws_lambda_function" "this" {
  filename         = var.filename
  function_name    = local.lambda_name
  role             = var.role_arn
  handler          = var.handler
  source_code_hash = var.source_code_hash
  publish          = var.publish

  runtime = var.runtime

  environment {
    variables = {
      ENVIRONMENT = var.environment
      LOG_LEVEL   = "info"
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_alias" "this" {
  for_each         = var.aliases
  name             = each.key
  function_name    = aws_lambda_function.this.function_name
  function_version = each.value
}

resource "aws_lambda_permission" "alias_invoke" {
  for_each = var.aliases

  statement_id  = "AllowInvokeLambda-${each.key}"
  action        = var.action
  function_name = aws_lambda_function.this.function_name
  qualifier     = each.key
  principal     = var.principal
  source_arn    = var.source_arn
}
