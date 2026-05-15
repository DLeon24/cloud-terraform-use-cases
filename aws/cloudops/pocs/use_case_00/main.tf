terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc" {
  source                  = "../../../modules/vpc"
  cidr_block              = var.cidr_block
  subnets                 = var.subnets
  enable_dns_hostnames    = var.enable_dns_hostnames
  enable_dns_support      = var.enable_dns_support
  create_internet_gateway = var.create_internet_gateway
  create_nat_gateway      = var.create_nat_gateway
  security_groups         = var.security_groups
  environment             = var.environment
  project                 = var.project
  region                  = var.region
  tags                    = var.tags
}

module "ec2" {
  source                 = "../../../modules/ec2"
  compute_mode           = var.compute_mode
  instance_type          = var.instance_type
  ami_id                 = var.ami_id
  vpc_security_group_ids = [module.vpc.security_group_ids[var.ec2_security_group_name]]
  user_data              = var.ec2_user_data
  iam_instance_profile   = module.ssm_role.instance_profile_name
  environment            = var.environment
  project                = var.project
  region                 = var.region
  tags                   = var.tags
}

module "asg" {
  source                  = "../../../modules/asg"
  min_size                = var.asg_min_size
  max_size                = var.asg_max_size
  desired_capacity        = var.asg_desired_capacity
  vpc_zone_identifier     = [for k in var.asg_vpc_zone_identifier : module.vpc.subnet_ids[k]]
  health_check_type       = var.health_check_type
  target_group_arns       = [module.elb.target_group_arn]
  launch_template_id      = module.ec2.launch_template_id
  launch_template_version = tostring(module.ec2.launch_template_latest_version)
  environment             = var.environment
  project                 = var.project
  region                  = var.region
  tags                    = var.tags
}

module "elb" {
  source             = "../../../modules/elb"
  load_balancer_type = var.load_balancer_type
  security_groups    = [module.vpc.security_group_ids[var.elb_security_group_name]]
  subnets            = [for k in var.elb_subnet_names : module.vpc.subnet_ids[k]]
  target_type        = var.target_type
  port               = var.port
  protocol           = var.protocol
  protocol_version   = var.protocol_version
  ip_address_type    = var.ip_address_type
  vpc_id             = module.vpc.id
  health_check_path  = var.health_check_path
  environment        = var.environment
  project            = var.project
  region             = var.region
  tags               = var.tags
}

module "db" {
  source                 = "../../../modules/rds"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [module.vpc.security_group_ids[var.rds_security_group_name]]
  multi_az               = var.multi_az
  subnet_ids             = [for k in var.rds_subnet_ids : module.vpc.subnet_ids[k]]
  environment            = var.environment
  project                = var.project
  region                 = var.region
  tags                   = var.tags
}


module "ssm_role" {
  source                  = "../../../modules/iam"
  iam_role_name           = var.iam_role_name
  assume_role_policy      = data.aws_iam_policy_document.assume_role_ssm.json
  managed_policy_arns     = var.managed_policy_arns
  create_instance_profile = var.create_instance_profile
  environment             = var.environment
  project                 = var.project
  region                  = var.region
  tags                    = var.tags
}
