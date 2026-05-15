resource "aws_iam_role" "this" {
  name               = var.iam_role_name
  assume_role_policy = var.assume_role_policy
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies
  name     = each.key
  role     = aws_iam_role.this.id
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = local.instance_profile_name
  role  = aws_iam_role.this.name
  tags  = local.instance_profile_tags
}
