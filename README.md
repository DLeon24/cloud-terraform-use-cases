# Cloud Terraform Use Cases

A hands-on portfolio of **Infrastructure-as-Code** use cases built with [Terraform](https://www.terraform.io/). Each use case is a self-contained proof of concept (POC) that exercises real AWS (and, in the future, Azure) services — the kind of scenarios you encounter while preparing for cloud certifications and designing production-grade architectures.

> **Audience:** Cloud engineers studying for **AWS** or **Azure** certifications, or anyone looking for practical Terraform patterns they can deploy, test, and tear down.

---

## Use case index

POCs are grouped by **track**:

| Track | Path | Focus |
|-------|------|--------|
| **Developer** | `aws/developer/pocs/` | Serverless APIs, Lambda, API Gateway |
| **CloudOps** | `aws/cloudops/pocs/` | VPC networking, load balancing, compute, databases |

Each POC lives in `use_case_NN/` and ships with a **`README.md`** that is the **canonical documentation** for goals, architecture, Terraform wiring, and how to test.

**Start here:** pick a row below and open the linked README — this file only summarizes the repo and links out to each use case.

### AWS CloudOps (`aws/cloudops/pocs/`)

| ID | Summary | Folder | Documentation |
|----|---------|--------|----------------|
| **UC-00** | Three-tier VPC (ALB, private EC2/ASG, Multi-AZ RDS) with NAT egress.<br><br>**Services:** VPC, subnets, IGW, NAT Gateway, ALB, ASG, EC2 launch template, RDS (PostgreSQL), IAM instance profile (SSM).<br>**Pattern:** Public tier (ALB + NAT), private app tier (ASG in two AZs), private data tier (RDS DB subnet group); app subnets egress via NAT per AZ. | [`use_case_00/`](aws/cloudops/pocs/use_case_00/) | **[README.md](aws/cloudops/pocs/use_case_00/README.md)** |

### AWS Developer (`aws/developer/pocs/`)

| ID | Summary | Folder | Documentation |
|----|---------|--------|----------------|
| **UC-00** | REST API + Lambda with `dev`/`prod` stages, aligned aliases, optional ACM custom domain.<br><br>**Services:** API Gateway (REST, regional), Lambda (Python), IAM, ACM; optional custom domain + base path mappings.<br>**Pattern:** Stages `dev` / `prod` map 1:1 to Lambda aliases `dev` / `prod`; stage variable `lambdaAlias` selects the alias in the integration URI. | [`use_case_00/`](aws/developer/pocs/use_case_00/) | **[README.md](aws/developer/pocs/use_case_00/README.md)** |

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
│   │   ├── asg/
│   │   ├── ec2/
│   │   ├── elb/
│   │   ├── iam/
│   │   ├── lambda/
│   │   ├── rds/
│   │   └── vpc/
│   ├── cloudops/
│   │   └── pocs/
│   │       └── use_case_00/                # Three-tier VPC + ALB + ASG + RDS
│   └── developer/
│       └── pocs/
│           └── use_case_00/                # API Gateway + Lambda stages/aliases      
├── azure/
│   └── README.md
├── .gitignore
└── README.md
```

### Conventions

| Convention | Detail |
|---|---|
| **Module path** | `aws/modules/<service>` — shared, composable building blocks for AWS POCs. |
| **POC path** | `aws/<track>/pocs/use_case_NN/` where `<track>` is `developer` or `cloudops`. |
| **Module source** | From a POC folder: `source = "../../../modules/<name>"`. |
| **Provider** | AWS **v6.x** (`hashicorp/aws ~> 6.0`), profile `terraform`. Developer UC-00 also uses `hashicorp/archive` for Lambda zip packaging. |
| **Tagging** | Modules merge `var.tags` with `Environment`, `Project`, and `Region`. |
| **Lock file** | `.terraform.lock.hcl` committed per POC. `*.tfstate` is git-ignored. |

---

## Reusable modules

All modules under `aws/modules/` use `main.tf`, `variables.tf`, `outputs.tf`, and `locals.tf` where needed.

| Module | Purpose | Used by |
|--------|---------|---------|
| `vpc` | VPC, subnets, IGW, NAT (per AZ), route tables, security groups | CloudOps UC-00 |
| `ec2` | `aws_instance` or `aws_launch_template` (`compute_mode`); optional `user_data` and IAM instance profile | CloudOps UC-00 |
| `asg` | Auto Scaling Group + launch template + target group registration | CloudOps UC-00 |
| `elb` | Application Load Balancer, listener, target group, health check | CloudOps UC-00 |
| `rds` | RDS instance + DB subnet group (Multi-AZ, engine/version, credentials) | CloudOps UC-00 |
| `iam` | IAM role, inline/managed policies, optional EC2 instance profile | Developer UC-00, CloudOps UC-00 |
| `lambda` | Lambda function, versions, aliases, invoke permissions | Developer UC-00 |
| `api_gateway` | Regional REST API, stages, Lambda proxy integration, optional custom domain | Developer UC-00 |
| `acm-certificate` | DNS-validated ACM certificate | Developer UC-00 (optional) |

### Highlights

- **`vpc`:** Subnet map with `nat_gateway_egress` per key; security groups defined in `terraform.tfvars` and referenced by logical name (`alb`, `app`, `data`).
- **`ec2`:** `compute_mode = "launch_template"` for ASG; `iam_instance_profile` optional via `dynamic` block on the launch template.
- **`iam`:** `create_instance_profile = true` in CloudOps for SSM (`AmazonSSMManagedInstanceCore`).
- **`api_gateway`:** Stage variable `lambdaAlias` routes to the matching Lambda alias per stage.

Per-module inputs and outputs: see each module’s `variables.tf` / `outputs.tf` and the POC README **Terraform (summary)** section.

---

## Prerequisites

| Requirement | Detail |
|---|---|
| **Terraform** | >= 1.x (`hashicorp/aws 6.44.0` in current lock files) |
| **AWS CLI** | Profile `terraform` with permissions for the services in each POC |
| **Python** | 3.x for Developer UC-00 Lambda |
| **DNS** | Only if Developer UC-00 custom domain is enabled |

---

## Azure

> **Status:** Coming soon. See [`azure/README.md`](azure/README.md).

---

## Cost considerations

| Track | Notes |
|-------|--------|
| **Developer** | API Gateway, Lambda; ACM certs are free (DNS may cost). |
| **CloudOps** | NAT Gateway, ALB, Multi-AZ RDS, and ASG instances often exceed strict free tier. |

> POCs use **local** Terraform state. For teams, consider S3 + DynamoDB locking.
