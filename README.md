# Secure AWS Web Application Infrastructure with Terraform

![Alt text](/terraform_ec2.png)

## This project demonstrates how to design, deploy, and secure a production-grade web application on AWS using Terraform.
## The primary focus is security-first cloud architecture, applying defense-in-depth principles across networking, identity, data, and access layers.

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

<img width="677" height="490" alt="Screenshot 2026-01-08 203519" src="https://github.com/user-attachments/assets/d70b0456-a383-4af2-acab-4175674020f3" />


---

2️⃣ **Remote Backend (State Security)**

Security Objective: Protect Terraform state

S3 backend for centralized state storage

DynamoDB table for state locking (prevents race conditions)

Prevents local state leaks and enables team collaboration

<img width="885" height="530" alt="Screenshot 2026-01-08 203713" src="https://github.com/user-attachments/assets/0f67ba3a-23a1-4d8d-8408-017e1b5b1ada" />


---

3️⃣ **Network Segmentation (VPC)**

Security Objective: Network isolation and blast-radius reduction

Custom VPC with DNS enabled

Multi-AZ architecture

Public subnets for internet-facing resources only

Private application subnets (no public IPs)

Private data subnets for databases

<img width="1893" height="880" alt="Screenshot 2026-01-08 203123" src="https://github.com/user-attachments/assets/f4d6d23c-c5ea-4add-8bb4-7c30b8a87456" />


---

4️⃣ **NAT Gateway**

Security Objective: Controlled outbound access

NAT Gateway placed in public subnet

Private subnets route outbound traffic without inbound exposure

Prevents direct internet access to application and database tiers

<img width="1391" height="938" alt="Screenshot 2026-01-08 203541" src="https://github.com/user-attachments/assets/b0ca61db-08a7-4f41-bfed-e7c79c616bf0" />


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

<img width="1429" height="931" alt="Screenshot 2026-01-08 203437" src="https://github.com/user-attachments/assets/1d4e20fc-5e20-40f3-aba7-76db19fae56b" />



---

6️⃣ **Secure Instance Access (EICE)**

Security Objective: Eliminate bastion hosts and exposed SSH

EC2 Instance Connect Endpoint deployed in private subnet

SSH access without public IPs

Access controlled via IAM and security groups

<img width="954" height="470" alt="Screenshot 2026-01-08 203550" src="https://github.com/user-attachments/assets/1d7500dd-db71-4c72-995c-10a032eb3e57" />


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

<img width="1145" height="830" alt="Screenshot 2026-01-08 203506" src="https://github.com/user-attachments/assets/b0c5c66c-0071-463a-8351-d0afc4858882" />


---


9️⃣ **IAM Roles & Instance Profiles**

Security Objective: Least-privilege access control

IAM role scoped to EC2 service

Explicit trust policy

S3 access via managed policy

No static credentials on EC2 instances

<img width="1383" height="933" alt="Screenshot 2026-01-08 203605" src="https://github.com/user-attachments/assets/b9f52fa6-2258-4be2-99f3-e1c1048a7374" />


---


🔟 **TLS & Certificate Management (ACM)**

Security Objective: Encrypt data in transit

ACM-provisioned SSL/TLS certificates

DNS validation via Route 53

Automated certificate validation using for_each

<img width="1393" height="938" alt="Screenshot 2026-01-08 203752" src="https://github.com/user-attachments/assets/d6283b91-776a-4cfd-85e0-9ebbe2fbe999" />


---


1️⃣1️⃣ **Application Load Balancer**

Security Objective: Secure traffic entry point

Public ALB as the only internet-facing component

HTTP redirected to HTTPS

TLS termination at ALB

Health checks for availability and resilience

<img width="1389" height="933" alt="Screenshot 2026-01-08 203743" src="https://github.com/user-attachments/assets/67442ff2-dd77-49bc-92d2-f5be317b39e0" />


---


1️⃣2️⃣ **DNS Security (Route 53)**

Security Objective: Controlled traffic routing

Alias A record pointing directly to ALB

No IP exposure

<img width="920" height="500" alt="Screenshot 2026-01-08 203458" src="https://github.com/user-attachments/assets/284040fa-264e-4110-b817-fed4cbfc758d" />


---


1️⃣3️⃣ **SNS Notifications**

Security Objective: Operational awareness

SNS topic for Auto Scaling events

Email notifications for scaling activity

<img width="1118" height="574" alt="Screenshot 2026-01-08 203407" src="https://github.com/user-attachments/assets/65208291-60de-463e-8ecb-c763e8410cc9" />


---


1️⃣4️⃣ **Auto Scaling Group**

Security Objective: Resilience and availability

EC2 instances launched in private subnets

Immutable infrastructure via launch templates

User data scripts injected securely using templatefile()

ALB target group integration

<img width="1392" height="937" alt="Screenshot 2026-01-08 203731" src="https://github.com/user-attachments/assets/ccce2042-55fe-4b65-9b6d-5a4784310955" />


---


1️⃣5️⃣ **Secure Data Migration**

Security Objective: Controlled data access

Dedicated EC2 migration server

Short-lived access pattern

Migration scripts parameterized securely

Explicit dependency on RDS readiness

<img width="1077" height="659" alt="Screenshot 2026-01-08 203622" src="https://github.com/user-attachments/assets/41cbf0f6-748f-4d95-bbbf-3be94f0eabd1" />
<img width="1387" height="935" alt="Screenshot 2026-01-08 203642" src="https://github.com/user-attachments/assets/a2b74933-c250-4ebb-827c-eee77d443bb3" />
<img width="1367" height="857" alt="Screenshot 2026-01-08 203705" src="https://github.com/user-attachments/assets/ea856cfc-0dad-48da-b353-66816612b8fe" />


---


1️⃣6️⃣ **Outputs**

Security Objective: Controlled information exposure

Outputs limited to non-sensitive metadata

No secrets exposed

Includes ALB DNS and application URL

<img width="879" height="419" alt="Screenshot 2026-01-08 203526" src="https://github.com/user-attachments/assets/df862678-ad8d-4312-a2a7-ed4a4a4c391b" />
<img width="830" height="183" alt="Screenshot 2026-01-08 203823" src="https://github.com/user-attachments/assets/a851b2ab-05b7-4bc9-ba4c-91de5854ed6e" />


---

## Deployment & Validation:
- terraform fmt
- terraform validate
- terraform plan
- terraform apply


## Post-deployment:

Confirm SNS email subscription

Verify HTTPS-only access via custom domain

---


# Conclusion

This project highlights secure cloud infrastructure design on AWS using Terraform, emphasizing defense in depth, least privilege, and automation.
It reflects real-world security patterns used in enterprise and regulated environments.
