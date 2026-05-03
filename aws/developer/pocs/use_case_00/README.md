UC-00: REST API + Lambda with `dev` / `prod` stages, aligned aliases, and custom domain

Goal  
Show a REST API on Amazon API Gateway with:

- **Two stages**: `dev` and `prod`.
- **Two Lambda aliases** with the same names: `dev` and `prod`.
- **1:1 mapping**: stage `dev` → alias `dev`; stage `prod` → alias `prod`.
- Stage variable **`lambdaAlias`** in API Gateway set to the stage name so the integration calls `…:${stageVariables.lambdaAlias}` and resolves the correct alias.
- **Custom domain** (optional via `enable_custom_domain`) with **base path mappings**: `/dev` → stage `dev`, `/prod` → stage `prod`.
- DNS (e.g. Cloudflare): CNAME to the regional **API Gateway domain name** (`d-xxxx.execute-api…`), not the invoke URL (`{api-id}.execute-api…`).

Scenario  

- `GET /orders` resource on a regional REST API.
- One published Lambda function; aliases `dev` and `prod` point to different versions per configuration in `main.tf`.
- Typical URLs with your own domain:
  - `https://<your-host>/dev/orders` → **dev** stage → Lambda alias **dev**
  - `https://<your-host>/prod/orders` → **prod** stage → Lambda alias **prod**

Native `execute-api` URLs:

- `https://{api-id}.execute-api.{region}.amazonaws.com/dev/orders`
- `https://{api-id}.execute-api.{region}.amazonaws.com/prod/orders`

Terraform (summary)

- Lambda source for this POC: [`functions/orders_handler/`](functions/orders_handler/) (`lambda_function.py`; `archive_file` builds `orders_handler.zip` next to it).
- `module.lambda_orders`: `aliases = { dev = "<version>", prod = "<version>" }` (published version numbers).
- `locals.api_gateway_stages`: same keys `dev` / `prod`; values = corresponding alias ARN.
- `locals.custom_domain_base_path_mappings`: `{ for k in keys(api_gateway_stages) : k => k }` → path prefix = stage name = alias name.

Custom domain and ACM

- `enable_custom_domain` (default `false`): lets you apply while the ACM certificate is `PENDING_VALIDATION`; when it is **Issued**, set `true` and apply again.
- In Cloudflare (or another DNS provider), the subdomain CNAME must point to the custom domain’s **regional target** in the API Gateway console (`d-….execute-api…`), not the invoke URL hostname.

Test flow

1. `GET …/dev/orders` → stage `dev` → variable `lambdaAlias=dev` → Lambda alias **dev**.
2. `GET …/prod/orders` → stage `prod` → variable `lambdaAlias=prod` → Lambda alias **prod**.

Minimal resources (free tier)  

- 1 REST API, 1 Lambda, 2 versions/aliases, optionally custom domain + ACM + DNS.

Portfolio value  

- Stages and aliases with **aligned names** (`dev` / `prod`), clear base paths, and environment separation without duplicating the function.
