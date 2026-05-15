variable "environment" {
  description = "Environment to deploy the resources"
  type        = string
  default     = "dev"
}

variable "aws_profile" {
  description = "AWS CLI profile name; leave empty to use the default credential chain (e.g. AWS_PROFILE)."
  type        = string
}

variable "project" {
  description = "Project or use case identifier"
  type        = string
  default     = "uc-00"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "api_description" {
  description = "Description of the API"
  type        = string
  default     = "API Gateway for Orders API"
}

variable "api_resource_path" {
  description = "Path of the API resource"
  type        = string
}

variable "http_method" {
  description = "HTTP method for the API resource"
  type        = string
}

variable "domain_name" {
  description = "FQDN for the ACM certificate and API Gateway custom domain"
  type        = string
}

variable "enable_custom_domain" {
  description = "If true, creates API Gateway custom domain (requires ACM ISSUED). Default false so first apply can succeed while the cert is PENDING_VALIDATION."
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  description = "Managed policy ARNs"
  type        = list(string)
}

variable "principal" {
  description = "Principal for the IAM role"
  type        = string
}

variable "action" {
  description = "Action for the IAM role"
  type        = string
}

variable "aliases" {
  description = "Aliases for the Lambda function"
  type        = map(string)
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
