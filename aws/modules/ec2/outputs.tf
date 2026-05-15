output "id" {
  description = "ID of the EC2 instance (null when compute_mode is launch_template)"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].id : null
}

output "public_ip" {
  description = "Public IP of the EC2 instance (null when compute_mode is launch_template)"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].public_ip : null
}

output "instance_name" {
  description = "Instance Name tag (null when compute_mode is launch_template)"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].tags["Name"] : null
}

output "launch_template_id" {
  description = "Launch template ID (null when compute_mode is instance)"
  value       = length(aws_launch_template.this) > 0 ? aws_launch_template.this[0].id : null
}

output "launch_template_latest_version" {
  description = "Launch template latest version number (null when compute_mode is instance)"
  value       = length(aws_launch_template.this) > 0 ? aws_launch_template.this[0].latest_version : null
}

output "launch_template_name" {
  description = "Launch template name (null when compute_mode is instance)"
  value       = length(aws_launch_template.this) > 0 ? aws_launch_template.this[0].name : null
}
