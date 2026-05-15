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

variable "engine" {
  description = "Engine for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "Engine version for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance"
  type        = number
}

variable "storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs for the RDS instance"
  type        = list(string)
}

variable "multi_az" {
  description = "Multi-AZ deployment for the RDS instance"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Subnet IDs for the RDS instance"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password; required when manage_master_user_password is false. Ignored when manage_master_user_password is true."
  type        = string
  sensitive   = true
  default     = null
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}


