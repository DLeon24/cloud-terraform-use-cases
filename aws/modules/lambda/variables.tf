variable "environment" {
  description = "Environment to deploy the resources"
  type        = string
}

variable "project" {
  description = "Project or use case identifier"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "filename" {
  description = "Filename for the Lambda function"
  type        = string
}

variable "source_code_hash" {
  description = "Source code hash for the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for the Lambda function"
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

variable "publish" {
  description = "Whether to publish a new version on each deploy"
  type        = bool
  default     = false
}

variable "aliases" {
  description = "Map of aliases to create. Key is alias name, value is the function version to point to. Use '$LATEST' for the latest unpublished code."
  type        = map(string)
  default     = {}
}

variable "principal" {
  description = "Principal to invoke the Lambda function"
  type        = string
}

variable "action" {
  description = "Action to invoke the Lambda function"
  type        = string
}

variable "source_arn" {
  description = "Source ARN allowed to invoke the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
