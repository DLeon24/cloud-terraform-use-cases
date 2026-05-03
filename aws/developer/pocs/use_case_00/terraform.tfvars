region            = "us-east-1"
runtime           = "python3.14"
handler           = "lambda_function.lambda_handler"
iam_role_name     = "LambdaOrderRole"
api_resource_path = "orders"
http_method       = "GET"
domain_name       = "uc-00.dleoncloud.com"
# By default the custom domain is not created until you set true (with ACM already Issued).
# enable_custom_domain = true

tags = {
  Team  = "Infrastructure"
  Owner = "dleon24"
}
