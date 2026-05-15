# UC-00: Three-tier VPC (ALB, private EC2/ASG, Multi-AZ RDS) with NAT egress

## Goal  

Demonstrate how to allow **EC2 instances in private subnets** (behind an **Application Load Balancer** and connected to **RDS** in other private subnets) to have **outbound Internet access to download patches**, without exposing them directly, using a **NAT Gateway** in a public subnet and a **Multi‑AZ RDS deployment** for high availability.

## Scenario  

- A VPC with three tiers separated by subnet, deployed across **Availability Zones**:
  - **Public subnet**: Application Load Balancer (ALB) and NAT Gateways
  - **Private application subnets**: EC2 instances in an Auto Scaling Group.
  - **Private database subnets**: Multi-AZ RDS instances.
- EC2 instances need:
  - To connect to RDS via the VPC internal network (using the single RDS endpoint, regardless of AZ)
  - To reach the Internet to download system/package updates.
- A **NAT Gateway is created in each public subnet** and the route tables for the private application subnets are updated so that each AZ’s private subnets egress through the NAT of the same AZ.
- RDS is deployed as a **Multi‑AZ** database instance using a DB subnet group that spans the two private database subnets.

## Terraform (summary)

- Root: [`main.tf`](main.tf), [`variables.tf`](variables.tf), [`terraform.tfvars`](terraform.tfvars), [`data.tf`](data.tf) (`assume_role_ssm` for EC2 trust policy).
- `module.vpc`: VPC `10.0.0.0/16`, six subnets from `var.subnets` (keys `public-a/b`, `private-app-a/b`, `private-data-a/b`), Internet Gateway, **NAT Gateway per AZ** (`nat_gateway_egress = true` on app subnets only), and three security groups (`alb`, `app`, `data`) from `var.security_groups`.
- `module.elb`: Application Load Balancer in `elb_subnet_names` → `["public-a", "public-b"]`; HTTP listener and target group (`health_check_path`, e.g. `/`) pointing to EC2 instances.
- `module.ec2`: `compute_mode = "launch_template"`; launch template with `user_data` (nginx for ALB health checks), SG `ec2_security_group_name` → `"app"`, and optional IAM profile via `dynamic "iam_instance_profile"` when `iam_instance_profile` is set.
- `module.asg`: Auto Scaling Group in `asg_vpc_zone_identifier` → `["private-app-a", "private-app-b"]`; uses `module.ec2.launch_template_id` and latest version; registers with `module.elb.target_group_arn`; `health_check_type = "ELB"`.
- `module.db`: PostgreSQL RDS (`engine`, `engine_version` must exist in the target region); `multi_az = true`; DB subnet group from `rds_subnet_ids` → `["private-data-a", "private-data-b"]`; SG `rds_security_group_name` → `"data"`.
- `module.ssm_role`: IAM role + instance profile (`create_instance_profile = true`) with `AmazonSSMManagedInstanceCore`; wired to EC2 as `iam_instance_profile = module.ssm_role.instance_profile_name` (Session Manager / patch egress via NAT).

### Subnets and routing

- **Public** (`public-a`, `public-b`): route `0.0.0.0/0` → Internet Gateway; host ALB and NAT Gateways.
- **Private app** (`private-app-a`, `private-app-b`): `nat_gateway_egress = true` → route `0.0.0.0/0` → NAT in the same AZ (outbound Internet for patches, SSM).
- **Private data** (`private-data-a`, `private-data-b`): `nat_gateway_egress = false` → VPC-local routes only (RDS tier, no direct Internet egress).

### Security groups (logical keys in `terraform.tfvars`)

- `alb`: HTTP from Internet; egress to `app` (and optional broad egress for ALB operation).
- `app`: HTTP from `alb`; egress to Internet (via NAT) and to `data` on the DB port.
- `data`: DB port (e.g. `5432`) from `app` only.

### RDS engine version

- Set `engine_version` to a value supported in your region (e.g. `aws rds describe-db-engine-versions --engine postgres --region <region>`). An invalid version fails at create time with `InvalidParameterCombination`.

## Minimum resources (free tier, but Multi‑AZ RDS may exceed free tier) 

- 1 VPC `10.0.0.0/16`.  
- 2 public subnets (e.g. `10.0.1.0/24, 10.0.4.0/24`) with route `0.0.0.0/0 → Internet Gateway`.  
- 2 private application subnets (e.g. `10.0.2.0/24, 10.0.5.0/24`) for EC2 (ASG).  
- 2 private database subnets (e.g. `10.0.3.0/24, 10.0.6.0/24`) for a Multi-AZ RDS instance (DB subnet group).  
- 1 ALB in the public subnets (HTTP 80 listener) with target group pointing to EC2 instances in the ASG.  
- 1 ASG with `t3.micro` EC2 instances (free tier) in the private application subnets.  
- 1 Multi-AZ RDS instance in a private database subnets (free tier, e.g. `db.t3.micro`, note that Multi‑AZ will typically go beyond strict free tier).  
- 1 **NAT Gateway** in each public subnet (one per AZ).

## Test flow  

1. **Configure subnets and routes**  
   - Public subnets (one per AZ):
     - Route table with `10.0.0.0/16 → local` and `0.0.0.0/0 → Internet Gateway`.
   - Private application subnets:
     - For each AZ, a route table with:
       - `10.0.0.0/16 → local` (default).
       - `0.0.0.0/0 → NAT Gateway` in the same AZ.
   - Private database subnets:
     - Shared route table with:
     - `10.0.0.0/16 → local` (no direct Internet egress, no route to IGW/NAT).

2. **Deploy ALB, EC2, and RDS**  
   - ALB in public subnets, listening on HTTP 80, pointing to the EC2 target group.  
   - ASG launching `t3.micro` instances in the two private application subnets (multi-AZ).  
   - RDS as a Multi-AZ database instance using a DB subnet group that includes the two private database subnets, without public access.

3. **Configure security groups**  
   - SG-ALB: allows inbound HTTP from the Internet and egress to SG-APP.  
   - SG-APP (EC2): allows inbound traffic from SG-ALB and egress to SG-DB and NAT.  
   - SG-DB (RDS): allows DB port (e.g. 5432/3306) only from SG-APP.

4. **Test connectivity**  
   - Access the app via ALB (ALB DNS name).  
   - From an EC2 instances (in either AZ), test:
     - Connection to RDS using the private Multi-AZ endpoint.  
     - Internet access, for example:
       - `curl https://aws.amazon.com`  
       - `sudo yum update` or `sudo dnf update`  
     - Verify that traffic egresses via NAT Gateway of the same AZ (no public IP on the EC2 instances).

## Portfolio value  

- Shows the recommended **three-tier** pattern with **multi-AZ** design: ALB in a public subnets, EC2 and RDS in private subnets across two Availability Zones.
- Demonstrates how to provide **outbound Internet access** to private instances via **NAT Gateway per AZ**, while maintaining security and isolation.
- Highlights proper use of a **Multi‑AZ RDS deployment** with a DB subnet group spanning two private subnets.
- Uses mostly **free tier–compatible** resources (small ALB, small EC2); note that NAT Gateways and Multi‑AZ RDS are typically not fully covered by free tier but are included to show production-ready patterns.

