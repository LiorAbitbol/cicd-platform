# ECS Fargate Runtime Setup (Manual Baseline)

This document describes the manual creation of an ECS Fargate runtime
behind an Application Load Balancer (ALB).

This setup establishes a working baseline before introducing CI/CD automation
and Infrastructure as Code (IaC).

---

## Architecture Overview

Internet
↓
Application Load Balancer (HTTP :80)
↓
IP Target Group (port 8000, /health)
↓
ECS Service (Fargate)
↓
FastAPI container


---

## Prerequisites

- VPC with:
  - Two public subnets
  - Internet Gateway
  - Public route table
- Docker image pushed to Amazon ECR
- Health endpoint available at `/health`
- Application listens on port `8000`

---

## Step 1 – Create Security Groups

### ALB Security Group

**Service**
- EC2 → Security Groups → Create security group

**Settings**
- Name: `cicd-platform-alb-sg`
- VPC: `cicd-platform-vpc`

**Inbound**
| Type | Port | Source |
|----|----|----|
| HTTP | 80 | 0.0.0.0/0 |

**Outbound**
- Allow all (default)

---

### ECS Task Security Group

**Settings**
- Name: `cicd-platform-ecs-task-sg`
- VPC: `cicd-platform-vpc`

**Inbound**
| Type | Port | Source |
|----|----|----|
| Custom TCP | 8000 | `cicd-platform-alb-sg` |

**Outbound**
- Allow all

---

## Step 2 – Create CloudWatch Log Group

**Service**
- CloudWatch → Log groups → Create log group

**Settings**
- Name: `/ecs/cicd-platform-logs`
- Retention: 7 days

---

## Step 3 – Create ECS Cluster

**Service**
- ECS → Clusters → Create cluster

**Settings**
- Name: `cicd-platform`
- Infrastructure: AWS Fargate (serverless)

---

## Step 4 – Create ECS Task Execution Role

**Service**
- IAM → Roles → Create role

**Settings**
- Trusted entity: AWS service
- Use case: Elastic Container Service
- Permissions:
  - `AmazonECSTaskExecutionRolePolicy`
- Role name: `ecsTaskExecutionRole`

---

## Step 5 – Create ECS Task Definition

**Service**
- ECS → Task definitions → Create new task definition

**Task settings**
- Family: `cicd-platform`
- Launch type: Fargate
- OS: Linux
- CPU: 0.25 vCPU
- Memory: 0.5 GB
- Execution role: `ecsTaskExecutionRole`

---

### Container Configuration

- Name: `api`
- Image: Full ECR image URI
- Port mapping:
  - Container port: 8000 (TCP)

---

### Container Health Check

```
CMD-SHELL, python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health')" || exit 1
```


**Health check settings**
- Interval: 10
- Timeout: 5
- Retries: 3
- Start period: 30

---

### Logging

- Log driver: awslogs
- Log group: `/ecs/cicd-platform-logs`
- Region: us-east-1
- Stream prefix: ecs

---

## Step 6 – Create Target Group

**Service**
- EC2 → Target Groups → Create target group

**Settings**
- Target type: IP
- Protocol: HTTP
- Port: 8000
- VPC: `cicd-platform-vpc`

**Health checks**
- Path: `/health`
- Interval: 10
- Timeout: 5

---

## Step 7 – Create Application Load Balancer

**Service**
- EC2 → Load Balancers → Create load balancer

**Settings**
- Type: Application Load Balancer
- Name: `cicd-platform-alb`
- Scheme: Internet-facing
- Subnets:
  - `public-subnet-cicd-platform-1a`
  - `public-subnet-cicd-platform-1b`
- Security group: `cicd-platform-alb-sg`
- Listener:
  - HTTP :80 → Target group

---

## Step 8 – Create ECS Service

**Service**
- ECS → Clusters → `cicd-platform` → Services → Create

**Settings**
- Launch type: Fargate
- Service name: `cicd-platform-service`
- Desired tasks: 1
- Task definition: `cicd-platform`

**Networking**
- VPC: `cicd-platform-vpc`
- Subnets:
  - `public-subnet-cicd-platform-1a`
  - `public-subnet-cicd-platform-1b`
- Security group: `cicd-platform-ecs-task-sg`
- Public IP: Enabled

**Load balancing**
- ALB: `cicd-platform-alb`
- Listener: HTTP :80
- Target group: created TG
- Container: `api`
- Container port: 8000

**Health**
- Health check grace period: 60 seconds

---

## Validation

- ECS service shows RUNNING tasks
- Target group targets are HEALTHY
- ALB DNS responds:
  - `/`
  - `/health`

---

## Notes

- This runtime is intentionally deployed manually.
- All resources will be recreated using Terraform in later phases.
- No changes should be made via console after this baseline is established.
