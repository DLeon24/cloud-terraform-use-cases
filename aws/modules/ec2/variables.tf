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

variable "compute_mode" {
  description = "instance = single aws_instance; launch_template = aws_launch_template only (e.g. for ASG)"
  type        = string

  validation {
    condition     = contains(["instance", "launch_template"], var.compute_mode)
    error_message = "compute_mode must be \"instance\" or \"launch_template\"."
  }

  validation {
    condition     = var.compute_mode != "instance" || var.subnet_id != null
    error_message = "subnet_id is required when compute_mode is \"instance\"."
  }
}

variable "ami_id" {
  description = "AMI ID for EC2 in the selected region"
  type        = string
}

variable "instance_type" {
  description = "Instance type for ec2"
  type        = string

  validation {
    condition = (
      var.instance_type == "t2.micro" ||
      var.instance_type == "t3.micro"
    )
    error_message = "instance_type must be t2.micro or t3.micro for this example."
  }
}

variable "subnet_id" {
  description = "Subnet ID for standalone instance (required when compute_mode is instance; ignored for launch_template)"
  type        = string
  default     = null
  nullable    = true
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs"
  type        = list(string)
}

variable "user_data" {
  description = "Optional cloud-init / shell script for the launch template or instance (base64-encoded by Terraform when set)"
  type        = string
  default     = null
  nullable    = true
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the EC2 instance"
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
