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

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}