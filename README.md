# Secure AWS Web Application Infrastructure with Terraform

![Alt text](/cognito1.jpg)

This project demonstrates how to design, deploy, and secure a production-grade web application on AWS using Terraform.
The primary focus is security-first cloud architecture, applying defense-in-depth principles across networking, identity, data, and access layers.

- All infrastructure is provisioned using Infrastructure as Code (IaC) to ensure repeatability, auditability, and compliance.

- Security-First Architecture Overview

- This infrastructure is built around zero-trust and least-privilege principles:

- Private-by-default networking

- No direct SSH exposure

- Secrets never hardcoded

- Encrypted traffic end-to-end

- Controlled IAM permissions

- Auditable, version-controlled infrastructure

---


## High-Level Architecture:

- Custom VPC with isolated public, application, and data subnet tiers

- Application Load Balancer (ALB) with HTTPS enforced

- Auto Scaling EC2 application servers in private subnets

- RDS MySQL in private data subnets

- Secrets Manager for credential storage

- EC2 Instance Connect Endpoint (EICE) for secure access

- ACM-managed TLS certificates

- Route 53 DNS with ALB alias

- SNS notifications for scaling events

- Remote Terraform state with locking

- Terraform modules for reusability, consistency, scalability, and collaboration


---


## Security-Focused Implementation Breakdown:
1️⃣ **Provider Configuration**

Security Objective: Controlled AWS access and consistency

AWS provider scoped to region and profile

Provider version pinning to prevent breaking changes

Default resource tagging for ownership and auditing

---

2️⃣ **Remote Backend (State Security)**

Security Objective: Protect Terraform state

S3 backend for centralized state storage

DynamoDB table for state locking (prevents race conditions)

Prevents local state leaks and enables team collaboration

---

3️⃣ **Network Segmentation (VPC)**

Security Objective: Network isolation and blast-radius reduction

Custom VPC with DNS enabled

Multi-AZ architecture

Public subnets for internet-facing resources only

Private application subnets (no public IPs)

Private data subnets for databases

---

4️⃣ **NAT Gateway**

Security Objective: Controlled outbound access

NAT Gateway placed in public subnet

Private subnets route outbound traffic without inbound exposure

Prevents direct internet access to application and database tiers

---

5️⃣ **Security Groups (Layered Firewalling)**

Security Objective: Least-privilege network access

Dedicated security groups for:

ALB (HTTPS only)

Application servers

RDS database

Data migration server

EC2 Instance Connect Endpoint (EICE)

Explicit inbound and outbound rules

No wide-open 0.0.0.0/0 access to private resources

---

6️⃣ **Secure Instance Access (EICE)**

Security Objective: Eliminate bastion hosts and exposed SSH

EC2 Instance Connect Endpoint deployed in private subnet

SSH access without public IPs

Access controlled via IAM and security groups

---

7️⃣ **Secrets Management**

Security Objective: Protect sensitive credentials

Database credentials stored in AWS Secrets Manager

Terraform references secrets using data sources

JSON secrets parsed securely using jsondecode()

No plaintext secrets in code or state files

---


8️⃣ **RDS (MySQL)**

Security Objective: Secure data storage

RDS deployed in private data subnets

Credentials sourced from Secrets Manager

Security group restricts access to application layer only

Managed backups and patching

---


9️⃣ **IAM Roles & Instance Profiles**

Security Objective: Least-privilege access control

IAM role scoped to EC2 service

Explicit trust policy

S3 access via managed policy

No static credentials on EC2 instances

---


🔟 **TLS & Certificate Management (ACM)**

Security Objective: Encrypt data in transit

ACM-provisioned SSL/TLS certificates

DNS validation via Route 53

Automated certificate validation using for_each

---


1️⃣1️⃣ **Application Load Balancer**

Security Objective: Secure traffic entry point

Public ALB as the only internet-facing component

HTTP redirected to HTTPS

TLS termination at ALB

Health checks for availability and resilience

---


1️⃣2️⃣ **DNS Security (Route 53)**

Security Objective: Controlled traffic routing

Alias A record pointing directly to ALB

No IP exposure

---


1️⃣3️⃣ **SNS Notifications**

Security Objective: Operational awareness

SNS topic for Auto Scaling events

Email notifications for scaling activity

---


1️⃣4️⃣ **Auto Scaling Group**

Security Objective: Resilience and availability

EC2 instances launched in private subnets

Immutable infrastructure via launch templates

User data scripts injected securely using templatefile()

ALB target group integration

---


1️⃣5️⃣ **Secure Data Migration**

Security Objective: Controlled data access

Dedicated EC2 migration server

Short-lived access pattern

Migration scripts parameterized securely

Explicit dependency on RDS readiness

---


1️⃣6️⃣ **Outputs**

Security Objective: Controlled information exposure

Outputs limited to non-sensitive metadata

No secrets exposed

Includes ALB DNS and application URL

## Deployment & Validation:
terraform fmt
terraform validate
terraform plan
terraform apply


## Post-deployment:

Confirm SNS email subscription

Verify HTTPS-only access via custom domain

---


# Summary

This project highlights secure cloud infrastructure design on AWS using Terraform, emphasizing defense in depth, least privilege, and automation.
It reflects real-world security patterns used in enterprise and regulated environments.
