resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = "default"
  tags                 = local.vpc_tags
}

resource "aws_subnet" "this" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${each.value.availability_zone}-${each.key}-subnet"
  })
}

resource "aws_route_table" "this" {
  for_each = var.subnets
  vpc_id   = aws_vpc.this.id
  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${each.value.availability_zone}-${each.key}-rtb"
  })
}

resource "aws_route_table_association" "this" {
  for_each       = var.subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.key].id
}

resource "aws_internet_gateway" "this" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = local.igw_tags
}

resource "aws_route" "public_internet" {
  for_each = {
    for k, v in var.subnets :
    k => v if var.create_internet_gateway && v.type == "public"
  }
  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_eip" "this" {
  for_each             = var.create_nat_gateway ? local.public_subnet_key_by_az : {}
  domain               = "vpc"
  network_border_group = var.region
  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${each.key}-eip"
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.create_nat_gateway ? local.public_subnet_key_by_az : {}
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.this[each.value].id
  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${each.key}-ngw"
  })
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat" {
  for_each = {
    for k, v in var.subnets :
    k => v if var.create_nat_gateway && v.type == "private" && v.nat_gateway_egress
  }
  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.availability_zone].id
}

resource "aws_security_group" "this" {
  for_each    = { for sg in var.security_groups : sg.name => sg }
  name        = "${local.full_prefix}-${each.key}-sg"
  description = each.value.description
  vpc_id      = aws_vpc.this.id
  tags = merge(local.common_tags, {
    Name = "${local.full_prefix}-${each.key}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for item in local.security_group_inline_ingress : item.key => item }

  security_group_id = aws_security_group.this[each.value.security_group_key].id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

  cidr_ipv4 = each.value.cidr_ipv4

  referenced_security_group_id = (
    each.value.referenced_security_group_key != null
    ? aws_security_group.this[each.value.referenced_security_group_key].id
    : null
  )
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for item in local.security_group_inline_egress : item.key => item }

  security_group_id = aws_security_group.this[each.value.security_group_key].id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
}

