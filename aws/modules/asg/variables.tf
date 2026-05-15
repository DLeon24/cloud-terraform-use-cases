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

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version ($Latest or numeric string)"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "Subnet IDs for the Auto Scaling group"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Target group ARNs for the ASG (optional)"
  type        = list(string)
}

variable "health_check_type" {
  description = "EC2 or ELB"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
