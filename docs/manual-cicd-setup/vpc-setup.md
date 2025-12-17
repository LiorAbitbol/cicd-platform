# VPC Setup – Public-Facing Runtime (ECS / ALB)

This document describes the manual creation of a dedicated VPC suitable for
a public-facing ECS Fargate service behind an Application Load Balancer (ALB).

This VPC is intentionally simple and deterministic to establish a clear
networking baseline before introducing Infrastructure as Code (IaC).

---

## Architecture Overview

- One VPC (`10.0.0.0/16`)
- Two public subnets in different AZs
- Internet Gateway
- Public route table
- Auto-assigned public IPv4 addresses

This VPC supports:
- Internet-facing ALB
- ECS Fargate tasks with public IPs
- Direct ECR and internet access (no NAT required)

---

## Region

- **us-east-1**

---

## Step 1 – Create the VPC

**AWS Console**
- Service: VPC
- Section: Your VPCs
- Action: Create VPC
- Option: VPC only

**Settings**
- Name: `cicd-platform-vpc`
- IPv4 CIDR: `10.0.0.0/16`
- IPv6 CIDR: None
- Tenancy: Default

---

## Step 2 – Create Public Subnet (AZ A)

**Service**
- VPC → Subnets → Create subnet

**Settings**
- VPC: `cicd-platform-vpc`
- Subnet name: `public-subnet-cicd-platform-1a`
- Availability Zone: `us-east-1a`
- CIDR block: `10.0.1.0/24`

---

## Step 3 – Create Public Subnet (AZ B)

**Settings**
- VPC: `cicd-platform-vpc`
- Subnet name: `public-subnet-cicd-platform-1b`
- Availability Zone: `us-east-1b`
- CIDR block: `10.0.2.0/24`

---

## Step 4 – Enable Auto-Assign Public IPv4

For **each public subnet**:

1. Select the subnet
2. Actions → Edit subnet settings
3. Enable:
   - Auto-assign public IPv4 address
4. Save

This is required for ECS tasks to:
- Pull images from ECR
- Reach the internet
- Be reachable by the ALB

---

## Step 5 – Create Internet Gateway

**Service**
- VPC → Internet Gateways → Create internet gateway

**Settings**
- Name: `cicd-platform-igw`

---

## Step 6 – Attach Internet Gateway to VPC

1. Select `cicd-platform-igw`
2. Actions → Attach to VPC
3. Select `cicd-platform-vpc`
4. Attach

---

## Step 7 – Create Public Route Table

**Service**
- VPC → Route Tables → Create route table

**Settings**
- Name: `cicd-platform-public-rt`
- VPC: `cicd-platform-vpc`

---

## Step 8 – Add Internet Route

1. Select `cicd-platform-public-rt`
2. Routes → Edit routes
3. Add:

| Destination | Target |
|------------|--------|
| 0.0.0.0/0  | Internet Gateway (`cicd-platform-igw`) |

4. Save

---

## Step 9 – Associate Route Table with Public Subnets

1. Select `cicd-platform-public-rt`
2. Subnet associations → Edit subnet associations
3. Select:
   - `public-subnet-cicd-platform-1a`
   - `public-subnet-cicd-platform-1b`
4. Save

---

## Validation Checklist

Each public subnet must have:
- Auto-assign public IPv4: **Enabled**
- Route table: `cicd-platform-public-rt`
- Route: `0.0.0.0/0 → igw`

---

## Notes

- This VPC will later be recreated using Terraform.
- No NAT gateways or private subnets are used in this baseline by design.
