locals {
  prefix      = "${var.project}-${var.environment}"
  full_prefix = "${local.prefix}-${var.region}"
  vpc_name    = "${local.full_prefix}-vpc"
  # One public subnet key per AZ; used to create one NAT per AZ.
  public_subnet_key_by_az = {
    for k, v in var.subnets : v.availability_zone => k if v.type == "public"
  }
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project
      Region      = var.region
    },
  )
  vpc_tags = merge(local.common_tags, { Name = local.vpc_name })
  igw_tags = merge(local.common_tags, { Name = "${local.full_prefix}-igw" })

  # Flatten per-SG ingress_rules / egress_rules into maps keyed for for_each.
  security_group_inline_ingress = flatten([
    for sg in var.security_groups : [
      for rule in sg.ingress_rules : {
        key                           = "${sg.name}-${rule.name}"
        security_group_key            = sg.name
        description                   = rule.description
        from_port                     = rule.from_port
        to_port                       = rule.to_port
        ip_protocol                   = rule.ip_protocol
        cidr_ipv4                     = rule.cidr_ipv4
        referenced_security_group_key = rule.referenced_security_group_key
      }
    ]
  ])
  security_group_inline_egress = flatten([
    for sg in var.security_groups : [
      for rule in sg.egress_rules : {
        key                = "${sg.name}-${rule.name}"
        security_group_key = sg.name
        description        = rule.description
        from_port          = rule.from_port
        to_port            = rule.to_port
        ip_protocol        = rule.ip_protocol
        cidr_ipv4          = rule.cidr_ipv4
      }
    ]
  ])
}
