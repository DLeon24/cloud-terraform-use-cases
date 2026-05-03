locals {
  api_gateway_stages = {
    dev  = module.lambda_orders.aliases["dev"]
    prod = module.lambda_orders.aliases["prod"]
  }
  custom_domain_base_path_mappings = { for k in keys(local.api_gateway_stages) : k => k }
}