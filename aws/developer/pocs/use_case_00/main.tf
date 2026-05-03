terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = "terraform"
}

module "iam_lambda_orders" {
  source             = "../../../modules/iam"
  iam_role_name      = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

module "lambda_orders" {
  source = "../../../modules/lambda"

  filename         = data.archive_file.lambda_function.output_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = var.runtime
  handler          = var.handler
  publish          = true

  role_arn = module.iam_lambda_orders.arn

  aliases = {
    dev  = "$LATEST" // first $LATEST then the version number "2" changing the code in lambda_function.py.
    prod = "1"
  }

  principal  = "apigateway.amazonaws.com"
  action     = "lambda:InvokeFunction"
  source_arn = module.api_gateway_orders.execution_arn

  environment = var.environment
  project     = var.project
  region      = var.region
  tags        = var.tags
}

module "acm_certificate" {
  source = "../../../modules/acm-certificate"

  domain_name = var.domain_name
  environment = var.environment
  project     = var.project
  region      = var.region
  tags        = var.tags
}

module "api_gateway_orders" {
  source = "../../../modules/api_gateway"

  api_description                  = var.api_description
  api_resource_path                = var.api_resource_path
  http_method                      = var.http_method
  lambda_arn                       = module.lambda_orders.arn
  stages                           = local.api_gateway_stages
  custom_domain_name               = var.domain_name
  custom_domain_certificate_arn    = module.acm_certificate.arn
  enable_custom_domain             = var.enable_custom_domain
  custom_domain_base_path_mappings = local.custom_domain_base_path_mappings

  environment = var.environment
  project     = var.project
  region      = var.region
  tags        = var.tags
}