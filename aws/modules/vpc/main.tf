resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = "default"
  tags                 = local.common_tags
}

resource "aws_subnet" "this" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
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
