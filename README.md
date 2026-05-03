# Cloud Terraform Use Cases

A hands-on portfolio of **Infrastructure-as-Code** use cases built with [Terraform](https://www.terraform.io/). Each use case is a self-contained proof of concept (POC) that exercises real AWS (and, in the future, Azure) services — the kind of scenarios you encounter while preparing for cloud certifications and designing production-grade architectures.

> **Audience:** Cloud engineers studying for **AWS** or **Azure** certifications, or anyone looking for practical Terraform patterns they can deploy, test, and tear down.

---

## Use case index

POCs are grouped by **track**: developer-focused scenarios under `aws/developer/pocs/` and architecture-focused scenarios under `aws/architecture/pocs/` (added as you publish them). Each POC lives in its own `use_case_NN/` folder and ships with a **`README.md`** that is the **canonical documentation** for goals, architecture, Terraform wiring, DNS, and how to test.

**Start here:** pick a row and open the linked README — the root file you are reading only summarizes the repo and links out to each use case.

### AWS Architecture (`aws/architecture/pocs/`)

No `use_case_*` folders here yet. When you add architecture-track POCs, place them under `aws/architecture/pocs/use_case_NN/` and extend the table below (same README-per-POC convention as developer).

| ID | Summary | Folder | Documentation |
|----|---------|--------|----------------|
| — | *Coming soon* | — | — |

### AWS Developer (`aws/developer/pocs/`)

| ID | Summary | Folder | Documentation |
|----|---------|--------|----------------|
| **UC-00** | Regional REST API (API Gateway) + Lambda with `dev`/`prod` stages, aligned aliases, optional ACM custom domain.<br><br>**Services:** API Gateway (REST, regional), Lambda (Python), IAM, ACM; optional custom domain + base path mappings.<br>**Pattern:** Stages `dev` / `prod` map 1:1 to Lambda aliases `dev` / `prod`; stage variable `lambdaAlias` selects the alias in the integration URI. | [`use_case_00/`](aws/developer/pocs/use_case_00/) | **[README.md](aws/developer/pocs/use_case_00/README.md)** |

### Azure (planned)

There are **no** `use_case_*` folders under `azure/` yet — only [`azure/README.md`](azure/README.md) as a placeholder. When Azure POCs are added, mirror the same pattern (e.g. `azure/pocs/use_case_00/README.md`) and extend this README with an **Azure** subsection table linking to each folder README.

---

## Repository layout

```
cloud-terraform-use-cases/
├── aws/
│   ├── modules/                            # shared Terraform modules (all tracks)
│   │   ├── acm-certificate/
│   │   ├── api_gateway/
│   │   ├── ec2/
│   │   ├── iam/
│   │   └── lambda/
│   ├── architecture/                       # architecture-track POCs (pocs/use_case_NN/ as you add them)
│   └── developer/
│       └── pocs/
│           └── use_case_00/
│               ├── README.md               # UC-00 detailed docs (canonical)
│               ├── main.tf                 # source = ../../../modules/...
│               ├── ...
│               └── functions/
├── azure/
│   └── README.md                           # placeholder (“coming soon”)
├── .gitignore
└── README.md                               ← index + repo-wide notes
```

### Conventions

| Convention | Detail |
|---|---|
| **Module path** | `aws/modules/<service>` — shared, composable building blocks for AWS POCs. |
| **POC path** | `aws/<track>/pocs/use_case_NN/` where `<track>` is `developer` or `architecture` — each POC is a root module; **each must have `README.md`**. |
| **Module source** | From `aws/<track>/pocs/use_case_NN/`, reference shared code as `source = "../../../modules/<name>"`. |
| **Provider** | AWS provider **v6.x** (`hashicorp/aws ~> 6.0`), configured with a local named profile (`terraform`). |
| **Tagging** | Modules merge `var.tags` with `Environment`, `Project`, and `Region` where applicable. |
| **Lambda packaging** | `data.archive_file` builds a `.zip` at plan time; `*.zip` is git-ignored. |
| **Lock file** | `.terraform.lock.hcl` is committed for reproducible applies. State files (`*.tfstate`) are git-ignored. |

---

## Reusable modules

All AWS modules live under `aws/modules/` and follow `main.tf` / `variables.tf` / `outputs.tf` / `locals.tf` where present.

### `iam`

Creates an IAM role with an assume-role policy, optional inline policies (`map(string)`), and optional managed policy ARN attachments.

| Input | Description |
|---|---|
| `iam_role_name` | Name for the IAM role |
| `assume_role_policy` | JSON assume-role policy document |
| `inline_policies` | Map of inline policy name → JSON body (default `{}`) |
| `managed_policy_arns` | List of managed policy ARNs to attach (default `[]`) |

### `lambda`

Creates a Lambda function from a local zip, publishes versions, creates aliases (`for_each`), and grants invoke permissions per alias.

| Input | Description |
|---|---|
| `filename` / `source_code_hash` | Zip path and hash for change detection |
| `runtime` / `handler` | Lambda runtime and entry point |
| `role_arn` | Execution role ARN |
| `publish` | Whether to publish a new version on each deploy |
| `aliases` | Map of alias name → version (`"$LATEST"` or a version number) |
| `principal` / `source_arn` | Invoke permission grant (e.g. API Gateway) |

### `api_gateway`

Creates a regional REST API with a single resource and method, `AWS_PROXY` integration to Lambda using `$stageVariables.lambdaAlias`, dynamic stages via `for_each`, and optional custom domain with base-path mappings.

| Input | Description |
|---|---|
| `api_resource_path` / `http_method` | Resource path part and HTTP verb |
| `lambda_arn` | Target Lambda function ARN (alias resolved at runtime via stage variable) |
| `stages` | Map of stage name → Lambda alias ARN |
| `enable_custom_domain` | Toggle for custom domain creation |
| `custom_domain_base_path_mappings` | Map of base path → stage name |

### `acm-certificate`

Requests a DNS-validated ACM certificate (RSA 2048) with `create_before_destroy` lifecycle.

| Input | Description |
|---|---|
| `domain_name` | FQDN for the certificate |

### `ec2`

Provisions a single EC2 instance with validation that restricts `instance_type` to `t2.micro` or `t3.micro` (free-tier friendly).

| Input | Description |
|---|---|
| `ami_id` | AMI to launch |
| `instance_type` | Instance type (constrained to `t2.micro` / `t3.micro`) |

> **Note:** The EC2 module is not referenced by any POC yet — it is available as a building block for future use cases (document each new consumption in the corresponding `use_case_NN/README.md`).

---

## Prerequisites

| Requirement | Version / Detail |
|---|---|
| **Terraform** | >= 1.x (provider lock pins `hashicorp/aws 6.43.0` in UC-00) |
| **AWS CLI** | Configured with a named profile `terraform` that has sufficient permissions |
| **Python** | 3.x (Lambda runtime is set per POC in `terraform.tfvars`) |
| **DNS provider** | Required only for POCs that enable custom domains (per use case README) |

---

## Azure

> **Status:** Coming soon. See [`azure/README.md`](azure/README.md). No Terraform modules or `use_case_*` stacks exist under `azure/` yet.

---

## Cost considerations

Use cases are aimed at **AWS Free Tier**–friendly footprints where applicable:

- API Gateway: REST API free tier allowances (see current AWS pricing docs).
- Lambda: free tier for requests and compute (see current AWS pricing docs).
- ACM: public certificates are free; DNS provider costs may apply.
- EC2 module: constrained to `t2.micro` / `t3.micro` when used.

> **Assumption:** The `terraform` AWS CLI profile targets a personal or sandbox account. UC-00 uses **local** Terraform state — no remote backend is configured in-repo. For collaboration, consider S3 + DynamoDB locking.

---

## License

Not specified. If you plan to share this portfolio publicly, consider adding an [MIT](https://opensource.org/licenses/MIT) or [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license file.
