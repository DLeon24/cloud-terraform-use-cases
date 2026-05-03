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

variable "api_description" {
  description = "Description of the API"
  type        = string
}

variable "api_resource_path" {
  description = "Path of the API resource"
  type        = string
}

variable "http_method" {
  description = "HTTP method for the API resource"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "stages" {
  description = "Map of stages to create. Key = stage name, value = lambda alias ARN"
  type        = map(string)
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

variable "custom_domain_name" {
  description = "Public hostname for the regional custom domain (e.g. api.example.com). Must be covered by the ACM certificate. Leave null to skip."
  type        = string
  default     = null
}

variable "custom_domain_certificate_arn" {
  description = "ACM certificate ARN in the same region as the API. Must be ISSUED before apply when enable_custom_domain is true (AWS rejects otherwise)."
  type        = string
  default     = null
}

variable "enable_custom_domain" {
  description = "Create API Gateway custom domain and base path mappings. Should be true only when ACM is ISSUED."
  type        = bool
  default     = false
}

variable "custom_domain_base_path_mappings" {
  description = "Map of API base path -> API Gateway stage (e.g. dev = dev, prod = prod). Used when custom_domain_name is set (same count gate as the domain resource)."
  type        = map(string)
  default     = {}
}
