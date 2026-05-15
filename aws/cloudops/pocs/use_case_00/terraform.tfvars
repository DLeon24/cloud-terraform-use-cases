region      = "us-east-1"
aws_profile = "<your-aws-profile>"
tags = {
  Team  = "Infrastructure"
  Owner = "dleon24"
}

# VPC
cidr_block = "10.0.0.0/16"
subnets = {
  public-a = {
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    type                    = "public"
    map_public_ip_on_launch = true
  }
  private-app-a = {
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1a"
    type                    = "private"
    map_public_ip_on_launch = false
    nat_gateway_egress      = true
  }
  private-data-a = {
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "us-east-1a"
    type                    = "private",
    map_public_ip_on_launch = false
    nat_gateway_egress      = false
  }
  public-b = {
    cidr_block              = "10.0.4.0/24"
    availability_zone       = "us-east-1b"
    type                    = "public"
    map_public_ip_on_launch = true
  }
  private-app-b = {
    cidr_block              = "10.0.5.0/24"
    availability_zone       = "us-east-1b"
    type                    = "private"
    map_public_ip_on_launch = false
    nat_gateway_egress      = true
  }
  private-data-b = {
    cidr_block              = "10.0.6.0/24"
    availability_zone       = "us-east-1b"
    type                    = "private",
    map_public_ip_on_launch = false
    nat_gateway_egress      = false
  }
}
enable_dns_hostnames    = true
enable_dns_support      = true
create_internet_gateway = true
create_nat_gateway      = true


# Security groups
security_groups = [
  {
    name        = "alb",
    description = "Allows inbound HTTP from the Internet and egress to App SG",
    ingress_rules = [
      {
        name        = "alb-http-from-internet"
        description = "HTTP from Internet to ALB"
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"

      }
    ],
    egress_rules = [
      {
        name        = "alb-http-egress"
        description = "HTTP egress to the Internet"
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0" #optional
      },
    ]
  },
  {
    name        = "app",
    description = "Allows inbound traffic from SG-ALB and egress to Data SG and NAT",
    ingress_rules = [
      {
        name                          = "app-http-from-alb"
        description                   = "HTTP from ALB to app instances (health checks and forwarded traffic)"
        from_port                     = 80
        to_port                       = 80
        ip_protocol                   = "tcp"
        referenced_security_group_key = "alb" #optional
      }
    ],
    egress_rules = [
      {
        name        = "app-http-egress"
        description = "HTTP egress to the Internet"
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      },
      {
        name        = "app-https-egress"
        description = "HTTPS egress to the Internet"
        from_port   = 443
        to_port     = 443
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      },
      {
        name        = "app-db-egress"
        description = "DB port egress to RDS inside VPC"
        from_port   = 5432
        to_port     = 5432
        ip_protocol = "tcp"
        cidr_ipv4   = "10.0.0.0/16"
      }
    ]
  },
  {
    name        = "data",
    description = "Allows DB port only from App SG"
    ingress_rules = [
      {
        name                          = "data-db-port-from-app"
        description                   = "DB port from app instances"
        from_port                     = 5432
        to_port                       = 5432
        ip_protocol                   = "tcp"
        referenced_security_group_key = "app"
      }
    ],
    egress_rules = [
      {
        name        = "data-db-port-egress"
        description = "DB port to the Internet"
        from_port   = 5432
        to_port     = 5432
        ip_protocol = "tcp"
        cidr_ipv4   = "10.0.0.0/16"
      }
    ]
  }
]

# EC2
# Launch Template
compute_mode            = "launch_template"
instance_type           = "t3.micro"
ami_id                  = "ami-0a59ec92177ec3fad"
ec2_security_group_name = "app"
# IAM for SSM testing purposes
create_instance_profile = true
iam_role_name           = "SSM-Role"
managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
# Minimal web server so ALB target health checks to / succeed (Amazon Linux 2 style).
ec2_user_data = <<-EOT
#!/bin/bash
set -e
yum install -y nginx
systemctl enable nginx
systemctl start nginx
EOT

# Auto Scaling (launch_template mode only)
asg_min_size            = 2
asg_max_size            = 4
asg_desired_capacity    = 2
health_check_type       = "ELB" # EC2 + ELB
asg_vpc_zone_identifier = ["private-app-a", "private-app-b"]

# Load Balancer
load_balancer_type      = "application"
ip_address_type         = "ipv4"
target_type             = "instance"
port                    = 80
protocol                = "HTTP"
protocol_version        = "HTTP1"
health_check_path       = "/"
elb_security_group_name = "alb"
elb_subnet_names        = ["public-a", "public-b"]

# RDS
engine                  = "postgres"
engine_version          = "16.14"
instance_class          = "db.t3.micro"
allocated_storage       = 20
storage_type            = "gp2"
rds_security_group_name = "data"
multi_az                = true
rds_subnet_ids          = ["private-data-a", "private-data-b"]
rds_db_name             = "uc00db"
rds_username            = "user00"
rds_password            = "1234567890"
