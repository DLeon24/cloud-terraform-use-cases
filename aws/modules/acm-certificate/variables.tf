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

variable "domain_name" {
  description = "FQDN for the public ACM certificate"
  type        = string
}

variable "tags" {
  description = "Tags for the certificate"
  type        = map(string)
  default     = {}
}
