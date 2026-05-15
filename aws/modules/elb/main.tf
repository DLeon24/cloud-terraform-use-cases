resource "aws_lb" "this" {
  name               = local.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  tags               = local.alb_tags
}

resource "aws_lb_target_group" "this" {
  name             = local.target_group_name
  target_type      = var.target_type
  port             = var.port
  protocol         = var.protocol
  protocol_version = var.protocol_version
  ip_address_type  = var.ip_address_type
  vpc_id           = var.vpc_id
  health_check {
    path     = var.health_check_path
    protocol = var.protocol
  }
  tags = local.target_group_tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    type             = var.default_action_type
    target_group_arn = aws_lb_target_group.this.arn
  }
}
