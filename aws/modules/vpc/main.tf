resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = "default"
  tags                 = local.common_tags
}

resource "aws_subnet" "this" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(local.common_tags, {
    Name = "subnet-${var.project}-${each.key}-${each.value.availability_zone}"
  })
}

resource "aws_route_table" "this" {
  for_each = var.subnets
  vpc_id   = aws_vpc.this.id
  tags = merge(local.common_tags, {
    Name = "rtb-${var.project}-${each.key}-${each.value.availability_zone}"
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
  tags = merge(local.common_tags, {
    Name = "${local.vpc_name}-igw"
  })
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
    Name = "${var.project}-${var.environment}-${each.key}-eip"
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.create_nat_gateway ? local.public_subnet_key_by_az : {}
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.this[each.value].id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-${each.key}-ngw"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat" {
  for_each = {
    for k, v in var.subnets :
    k => v if var.create_nat_gateway && v.type == "private"
  }
  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.availability_zone].id
}

