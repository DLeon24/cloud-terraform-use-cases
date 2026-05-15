region            = "us-east-1"
aws_profile       = "<your-aws-profile>"
runtime           = "python3.14"
handler           = "lambda_function.lambda_handler"
iam_role_name     = "LambdaOrderRole"
api_resource_path = "orders"
http_method       = "GET"
domain_name       = "<your-domain-name>"
# By default the custom domain is not created until you set true (with ACM already Issued).
# enable_custom_domain = true

tags = {
  Team  = "Infrastructure"
  Owner = "dleon24"
}

managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
principal           = "apigateway.amazonaws.com"
action              = "lambda:InvokeFunction"
aliases = {
  dev  = "$LATEST" // first $LATEST then the version number "2" changing the code in lambda_function.py.
  prod = "1"
}
