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

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ip_address_type" {
  description = "IP address type"
  type        = string
}

variable "target_type" {
  description = "Target type"
  type        = string
}

variable "port" {
  description = "Port"
  type        = number
}

variable "protocol" {
  description = "Protocol"
  type        = string
  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "Invalid protocol. Valid protocols are: HTTP, HTTPS"
  }
}

variable "protocol_version" {
  description = "Protocol version"
  type        = string
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "Security groups to attach to the ELB"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets to attach to the ELB"
  type        = list(string)
}

variable "default_action_type" {
  description = "Default action type"
  type        = string
  default     = "forward"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
