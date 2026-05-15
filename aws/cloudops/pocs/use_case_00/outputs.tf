output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.id
}

output "vpc_subnet_ids" {
  description = "Map of subnet keys to subnet IDs (matches var.subnets keys)"
  value       = module.vpc.subnet_ids
}

output "vpc_route_table_ids" {
  description = "Map of subnet keys to route table IDs (matches var.subnets keys)"
  value       = module.vpc.route_table_ids
}

output "vpc_internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC"
  value       = module.vpc.internet_gateway_id
}

output "vpc_nat_gateway_id" {
  description = "Map of AZ to NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "vpc_eip_public_ip" {
  description = "Map of AZ to NAT Elastic IP public IP"
  value       = module.vpc.eip_public_ip
}

output "vpc_security_group_ids" {
  description = "Map of logical security group names to SG IDs"
  value       = module.vpc.security_group_ids
}


output "ec2_launch_template_id" {
  description = "Launch template ID"
  value       = module.ec2.launch_template_id
}

output "ec2_launch_template_latest_version" {
  description = "Launch template latest version"
  value       = module.ec2.launch_template_latest_version
}

output "ec2_launch_template_name" {
  description = "Name of the EC2 launch template"
  value       = module.ec2.launch_template_name
}

output "asg_id" {
  description = "Auto Scaling Group ARN"
  value       = module.asg.id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.name
}

output "elb_id" {
  description = "ELB ID"
  value       = module.elb.id
}

output "elb_arn" {
  description = "ELB ARN"
  value       = module.elb.arn
}

output "elb_dns_name" {
  description = "ELB DNS name"
  value       = module.elb.dns_name
}

output "vpc_security_group_ingress_rule_ids" {
  description = "Map of inline ingress rule keys to aws_vpc_security_group_ingress_rule IDs"
  value       = module.vpc.security_group_ingress_rule_ids
}

output "vpc_security_group_egress_rule_ids" {
  description = "Map of inline egress rule keys to aws_vpc_security_group_egress_rule IDs"
  value       = module.vpc.security_group_egress_rule_ids
}

output "rds_id" {
  description = "RDS ID"
  value       = module.db.rds_instance_id
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.db.rds_db_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.db.rds_endpoint
}

output "rds_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.db.db_subnet_group_name
}

output "rds_subnet_group_id" {
  description = "RDS subnet group ID"
  value       = module.db.db_subnet_group_id
}

output "ssm_role_name" {
  description = "SSM role name"
  value       = module.ssm_role.name
}

output "ssm_role_instance_profile_name" {
  description = "SSM role instance profile name"
  value       = module.ssm_role.instance_profile_name
}

