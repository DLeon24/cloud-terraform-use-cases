output "id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "cidr_block" {
  description = "IPv4 CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "route_table_ids" {
  description = "Map of subnet keys to explicit aws_route_table IDs (matches var.subnets keys)"
  value       = { for k, rt in aws_route_table.this : k => rt.id }
}

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs (matches var.subnets keys)"
  value       = { for k, s in aws_subnet.this : k => s.id }
}
