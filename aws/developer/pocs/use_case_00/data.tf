data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/functions/orders_handler/lambda_function.py"
  output_path = "${path.module}/functions/orders_handler/orders_handler.zip"
}


