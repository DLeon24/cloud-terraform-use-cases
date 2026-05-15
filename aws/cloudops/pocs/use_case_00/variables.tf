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

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create"
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
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
}

variable "create_internet_gateway" {
  description = "Create an Internet Gateway for the VPC"
  type        = bool
}

variable "create_nat_gateway" {
  description = "Create a NAT Gateway in the public subnet"
  type        = bool
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of load balancer"
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
}

variable "protocol_version" {
  description = "Protocol version"
  type        = string
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
}

variable "security_groups" {
  description = "Security groups to create (passed to module.vpc; must match module input shape including ingress/egress rules)"
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

variable "ec2_security_group_name" {
  description = "Name of the security group to attach to the EC2 instance"
  type        = string
}

variable "elb_security_group_name" {
  description = "Name of the security group to attach to the ELB"
  type        = string
}

variable "compute_mode" {
  description = "instance = single EC2; launch_template = launch template + ASG (no standalone instance)"
  type        = string
}

variable "asg_min_size" {
  description = "ASG minimum size (used when compute_mode is launch_template)"
  type        = number
}

variable "asg_max_size" {
  description = "ASG maximum size (used when compute_mode is launch_template)"
  type        = number
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity (used when compute_mode is launch_template)"
  type        = number
}

variable "health_check_type" {
  description = "Health check type"
  type        = string
}

variable "asg_vpc_zone_identifier" {
  description = "VPC zone identifier"
  type        = list(string)
}

variable "elb_subnet_names" {
  description = "Subnet keys (see var.subnets) for the ALB. Application load balancers require at least two subnets in two different availability zones."
  type        = list(string)

  validation {
    condition     = length(var.elb_subnet_names) >= 2
    error_message = "elb_subnet_names must contain at least two subnet keys for an application load balancer (AWS requires two AZs)."
  }
}

variable "ec2_user_data" {
  description = "Optional bootstrap script for instances from the launch template (plain text; Terraform base64-encodes for AWS)."
  type        = string
}

variable "engine" {
  description = "Engine"
  type        = string
}

variable "engine_version" {
  description = "Engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage"
  type        = number
}

variable "storage_type" {
  description = "Storage type"
  type        = string
}

variable "rds_security_group_name" {
  description = "RDS security group name"
  type        = string
}

variable "multi_az" {
  description = "Multi-AZ"
  type        = bool
}

variable "rds_subnet_ids" {
  description = "Subnet IDs for the RDS instance"
  type        = list(string)
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
}

variable "rds_username" {
  description = "RDS master username (aws_db_instance.username)"
  type        = string
}

variable "rds_password" {
  description = "RDS master password; only used when rds_manage_master_user_password is false. Prefer Secrets Manager (default) or -var for one-off applies."
  type        = string
  sensitive   = true
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "managed_policy_arns" {
  description = "Managed policy ARNs"
  type        = list(string)
}

variable "create_instance_profile" {
  description = "Create an instance profile for the IAM role"
  type        = bool
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
