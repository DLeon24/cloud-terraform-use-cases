## UC-00: Secure Internet access for private EC2 instances using NAT Gateway

## Goal  

Demonstrate how to allow **EC2 instances in private subnets** (behind an **Application Load Balancer** and connected to **RDS** in other private subnets) to have **outbound Internet access to download patches**, without exposing them directly, using a **NAT Gateway** in a public subnet.

## Scenario  

- A VPC with three tiers separated by subnet:
  - **Public subnet**: Application Load Balancer (ALB).
  - **Private application subnet**: EC2 instances in an Auto Scaling Group.
  - **Private database subnet**: RDS instance.
- EC2 instances need:
  - To connect to RDS via the VPC internal network.
  - To reach the Internet to download system/package updates.
- A **NAT Gateway is created in the public subnet** and the route tables for the private application subnets are updated.

## Terraform (summary)
Coming soon

## Minimum resources  

- 1 VPC `10.0.0.0/16`.  
- 1 public subnet (e.g. `10.0.1.0/24`) with route `0.0.0.0/0 → Internet Gateway`.  
- 1 private application subnet (e.g. `10.0.2.0/24`) for EC2.  
- 1 private database subnet (e.g. `10.0.3.0/24`) for RDS.  
- 1 ALB in the public subnet (HTTP 80 listener) with target group pointing to EC2.  
- 1 ASG with `t2.micro` EC2 instances (free tier) in the private application subnet.  
- 1 small RDS instance in a private subnet (free tier, e.g. `db.t3.micro`).  
- 1 **NAT Gateway** in the public subnet.  

## Test flow  

1. **Configure subnets and routes**  
   - Public subnet:
     - Route table with `0.0.0.0/0 → Internet Gateway`.
   - Private application subnet:
     - Route table with:
       - `10.0.0.0/16 → local` (default).
       - `0.0.0.0/0 → NAT Gateway`.
   - Private database subnet:
     - Only `10.0.0.0/16 → local` (no direct Internet egress).

2. **Deploy ALB, EC2, and RDS**  
   - ALB in public subnet, listening on HTTP 80, pointing to the EC2 target group.  
   - ASG launching `t2.micro` instances in the private application subnet.  
   - RDS in the private database subnet, without public access.

3. **Configure security groups**  
   - SG-ALB: allows inbound HTTP from the Internet and egress to SG-APP.  
   - SG-APP (EC2): allows inbound traffic from SG-ALB and egress to SG-DB and NAT.  
   - SG-DB (RDS): allows DB port (e.g. 5432/3306) only from SG-APP.

4. **Test connectivity**  
   - Access the app via ALB (ALB DNS name).  
   - From an EC2 instance, test:
     - Connection to RDS using the private endpoint.  
     - Internet access, for example:
       - `curl https://aws.amazon.com`  
       - `sudo yum update` or `sudo dnf update`  
     - Verify that traffic egresses via NAT Gateway (no public IP on the EC2 instances).

## Portfolio value  

- Shows the recommended **three-tier** pattern: ALB in a public subnet, EC2 and RDS in private subnets.  
- Demonstrates how to provide **outbound Internet access** to private instances via **NAT Gateway**, while maintaining security and isolation.  
- Uses minimal **free tier** resources (basic ALB, small EC2 and RDS).

