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

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "Subnets for the VPC"
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    type                    = string
    map_public_ip_on_launch = bool
    nat_gateway_egress      = optional(bool)
  }))
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Create an Internet Gateway for the VPC"
  type        = bool
}

variable "create_nat_gateway" {
  description = "Create a NAT Gateway in the public subnet"
  type        = bool
  default     = false
}


variable "security_groups" {
  description = "Security groups to create in the VPC module"
  type = list(object({
    name        = string
    description = string
    ingress_rules = optional(list(object({
      name                          = string
      description                   = string
      from_port                     = number
      to_port                       = number
      ip_protocol                   = string
      cidr_ipv4                     = optional(string, null)
      referenced_security_group_key = optional(string, null)
    })), [])
    egress_rules = optional(list(object({
      name        = string
      description = string
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = optional(string, null)
    })), [])
  }))
}


variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}


