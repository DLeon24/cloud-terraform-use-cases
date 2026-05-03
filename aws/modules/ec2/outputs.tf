output "id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "instance_name" {
  description = "Instance name tag"
  value       = aws_instance.app.tags["Name"]
}