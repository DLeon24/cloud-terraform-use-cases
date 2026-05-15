resource "aws_instance" "this" {
  count                  = var.compute_mode == "instance" ? 1 : 0
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = local.user_data_base64
  iam_instance_profile   = var.iam_instance_profile
  tags                   = local.instance_tags
}

resource "aws_launch_template" "this" {
  count                  = var.compute_mode == "launch_template" ? 1 : 0
  name                   = local.launch_template_name
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = local.user_data_base64
  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile != null ? [1] : []
    content {
      name = var.iam_instance_profile
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags          = local.instance_tags
  }
}
