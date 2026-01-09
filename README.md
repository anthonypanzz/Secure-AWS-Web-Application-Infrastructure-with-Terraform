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
<img width="1904" height="346" alt="Screenshot 2026-01-08 210546" src="https://github.com/user-attachments/assets/4e9c23d9-9062-431c-b85c-987ddc53b77e" />


---

4️⃣ **NAT Gateway**

Security Objective: Controlled outbound access

NAT Gateway placed in public subnet

Private subnets route outbound traffic without inbound exposure

Prevents direct internet access to application and database tiers

<img width="1391" height="938" alt="Screenshot 2026-01-08 203541" src="https://github.com/user-attachments/assets/b0ca61db-08a7-4f41-bfed-e7c79c616bf0" />
<img width="1907" height="254" alt="Screenshot 2026-01-08 211030" src="https://github.com/user-attachments/assets/046d31b6-dc7a-4e49-a248-9d39fc9ef65b" />


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
<img width="1902" height="416" alt="Screenshot 2026-01-08 210847" src="https://github.com/user-attachments/assets/76723f37-4e0f-4fd4-abf7-638d2255cdb8" />



---

6️⃣ **Secure Instance Access (EICE)**

Security Objective: Eliminate bastion hosts and exposed SSH

EC2 Instance Connect Endpoint deployed in private subnet

SSH access without public IPs

Access controlled via IAM and security groups

<img width="954" height="470" alt="Screenshot 2026-01-08 203550" src="https://github.com/user-attachments/assets/1d7500dd-db71-4c72-995c-10a032eb3e57" />
<img width="1910" height="238" alt="Screenshot 2026-01-08 211051" src="https://github.com/user-attachments/assets/6599dc28-d19f-42e4-a732-55e23869112e" />


---

7️⃣ **Secrets Management**

Security Objective: Protect sensitive credentials

Database credentials stored in AWS Secrets Manager

Terraform references secrets using data sources

JSON secrets parsed securely using jsondecode()

No plaintext secrets in code or state files

<img width="1279" height="596" alt="Screenshot 2026-01-08 203449" src="https://github.com/user-attachments/assets/33186e31-3e3e-4932-8e88-d1622217ba71" />
<img width="1898" height="250" alt="Screenshot 2026-01-08 210912" src="https://github.com/user-attachments/assets/4d6e0c69-aa70-4917-969b-a3fedf6cc3ea" />


---


8️⃣ **RDS (MySQL)**

Security Objective: Secure data storage

RDS deployed in private data subnets

Credentials sourced from Secrets Manager

Security group restricts access to application layer only

Managed backups and patching

<img width="1145" height="830" alt="Screenshot 2026-01-08 203506" src="https://github.com/user-attachments/assets/b0c5c66c-0071-463a-8351-d0afc4858882" />
<img width="1905" height="265" alt="Screenshot 2026-01-08 211010" src="https://github.com/user-attachments/assets/72705b25-3eb3-45dd-a3ac-890c32f08e59" />


---


9️⃣ **IAM Roles & Instance Profiles**

Security Objective: Least-privilege access control

IAM role scoped to EC2 service

Explicit trust policy

S3 access via managed policy

No static credentials on EC2 instances

<img width="1383" height="933" alt="Screenshot 2026-01-08 203605" src="https://github.com/user-attachments/assets/b9f52fa6-2258-4be2-99f3-e1c1048a7374" />
<img width="1908" height="290" alt="Screenshot 2026-01-08 211150" src="https://github.com/user-attachments/assets/eb7f21a4-d06b-41f1-b4f8-d797ece773a7" />


---


🔟 **TLS & Certificate Management (ACM)**

Security Objective: Encrypt data in transit

ACM-provisioned SSL/TLS certificates

DNS validation via Route 53

Automated certificate validation

<img width="1393" height="938" alt="Screenshot 2026-01-08 203752" src="https://github.com/user-attachments/assets/d6283b91-776a-4cfd-85e0-9ebbe2fbe999" />
<img width="1909" height="270" alt="Screenshot 2026-01-08 211509" src="https://github.com/user-attachments/assets/a042b783-ba71-4a63-94dd-068f994d22b2" />


---


1️⃣1️⃣ **Application Load Balancer**

Security Objective: Secure traffic entry point

Public ALB as the only internet-facing component

HTTP redirected to HTTPS

TLS termination at ALB

Health checks for availability and resilience

<img width="1389" height="933" alt="Screenshot 2026-01-08 203743" src="https://github.com/user-attachments/assets/67442ff2-dd77-49bc-92d2-f5be317b39e0" />
<img width="1904" height="288" alt="Screenshot 2026-01-08 211425" src="https://github.com/user-attachments/assets/d32e105d-2c42-4ed1-a465-b4a54dae06b0" />
<img width="1640" height="387" alt="Screenshot 2026-01-08 211541" src="https://github.com/user-attachments/assets/67b07405-ff39-4c0e-a01f-47ae7fe8a37a" />


---


1️⃣2️⃣ **DNS Security (Route 53)**

Security Objective: Controlled traffic routing

Alias A record pointing directly to ALB

No IP exposure

<img width="920" height="500" alt="Screenshot 2026-01-08 203458" src="https://github.com/user-attachments/assets/284040fa-264e-4110-b817-fed4cbfc758d" />
<img width="1907" height="294" alt="Screenshot 2026-01-08 210947" src="https://github.com/user-attachments/assets/6a730b8f-a25d-41d4-9f84-4c41d0298a55" />


---


1️⃣3️⃣ **SNS Notifications**

Security Objective: Operational awareness

SNS topic for Auto Scaling events

Email notifications for scaling activity

<img width="1118" height="574" alt="Screenshot 2026-01-08 203407" src="https://github.com/user-attachments/assets/65208291-60de-463e-8ecb-c763e8410cc9" />
<img width="1907" height="138" alt="Screenshot 2026-01-08 210754" src="https://github.com/user-attachments/assets/8f5326a9-cec9-4a5c-aedf-d221da7227b8" />
<img width="1629" height="251" alt="Screenshot 2026-01-08 210809" src="https://github.com/user-attachments/assets/dc535ffb-d902-4975-95da-b4795db6bad6" />


---


1️⃣4️⃣ **Auto Scaling Group**

Security Objective: Resilience and availability

EC2 instances launched in private subnets

Immutable infrastructure via launch templates

User data scripts injected securely using templatefile()

ALB target group integration

<img width="1392" height="937" alt="Screenshot 2026-01-08 203731" src="https://github.com/user-attachments/assets/ccce2042-55fe-4b65-9b6d-5a4784310955" />
<img width="1906" height="283" alt="Screenshot 2026-01-08 211242" src="https://github.com/user-attachments/assets/81e2dbc9-0bcd-4d49-815e-aa9c3e566461" />
<img width="1046" height="278" alt="Screenshot 2026-01-08 211403" src="https://github.com/user-attachments/assets/b1541c29-15e9-47fe-8454-f772307ce9ba" />
<img width="1904" height="269" alt="Screenshot 2026-01-08 211336" src="https://github.com/user-attachments/assets/19b5018e-e8d2-447b-8492-e4fa2985fa38" />


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
<img width="1906" height="283" alt="Screenshot 2026-01-08 211242" src="https://github.com/user-attachments/assets/6ee8bd43-33bc-498a-b40e-8921ea48c40a" />


---

## Deployment & Validation:
- terraform init
- terraform plan
- terraform apply

<img width="1479" height="584" alt="Screenshot 2026-01-08 205048" src="https://github.com/user-attachments/assets/ad1fc772-7dc1-43d2-bc11-01cade73b0d3" />
<img width="1893" height="858" alt="Screenshot 2026-01-08 205810" src="https://github.com/user-attachments/assets/4205a447-f0e4-4699-af2b-c9f930962e7f" />
<img width="1619" height="983" alt="Screenshot 2026-01-08 211726" src="https://github.com/user-attachments/assets/3acc537e-8ed9-43cd-83c7-b311b6a7b336" />
<img width="1607" height="987" alt="Screenshot 2026-01-08 211814" src="https://github.com/user-attachments/assets/f7eb3694-29eb-407c-b626-3852643db77f" />


---


# Conclusion

This project highlights secure cloud infrastructure design on AWS using Terraform, emphasizing defense in depth, least privilege, and automation.
It reflects real-world security patterns used in enterprise and regulated environments.
