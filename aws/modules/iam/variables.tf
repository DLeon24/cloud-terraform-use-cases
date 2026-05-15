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

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy for the IAM role"
  type        = string
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the role"
  type        = map(string)
  default     = {}
}

variable "managed_policy_arns" {
  description = "List of AWS managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

