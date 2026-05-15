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

output "internet_gateway_id" {
  description = "ID of the Internet Gateway (null if create_internet_gateway is false)"
  value       = var.create_internet_gateway ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "Map of AZ to NAT Gateway ID (empty if create_nat_gateway is false)"
  value       = { for az, nat in aws_nat_gateway.this : az => nat.id }
}

output "eip_public_ip" {
  description = "Map of AZ to EIP public IP (empty if create_nat_gateway is false)"
  value       = { for az, eip in aws_eip.this : az => eip.public_ip }
}

output "security_group_ids" {
  description = "Map of security group names to SG IDs"
  value       = { for k, sg in aws_security_group.this : k => sg.id }
}

output "security_group_ingress_rule_ids" {
  description = "Map of inline ingress rule keys (see local.security_group_inline_ingress) to aws_vpc_security_group_ingress_rule IDs"
  value       = { for k, r in aws_vpc_security_group_ingress_rule.this : k => r.id }
}

output "security_group_egress_rule_ids" {
  description = "Map of inline egress rule keys (see local.security_group_inline_egress) to aws_vpc_security_group_egress_rule IDs"
  value       = { for k, r in aws_vpc_security_group_egress_rule.this : k => r.id }
}
