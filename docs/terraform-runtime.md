# Terraform Runtime Lifecycle Guide

This document describes how to recreate and tear down the AWS runtime
for the **cicd-platform** project using Terraform.

Terraform owns all runtime infrastructure so the environment can be
recreated safely, repeatedly, and at low cost.

---

## Managed Resources

Terraform manages the following AWS resources:

- VPC with public subnets and internet gateway
- Security groups for ALB and ECS tasks
- Application Load Balancer and target group
- CloudWatch log group for ECS tasks
- Amazon ECR repository
- ECS cluster, task definition, and service

IAM roles used by GitHub Actions (OIDC) are intentionally managed outside
Terraform in the initial version.

---

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured locally (CLI or SSO)
- GitHub Actions CI/CD workflows already present in the repository

---

## Directory Structure

```
infra/terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

---

## Create the Runtime

From the repository root:

```bash
cd infra/terraform
terraform init
terraform apply
```

Terraform will output values including:

- ALB DNS name
- ECS cluster name
- ECS service name
- ECR repository URL

At this stage:
- The ECS service exists
- Desired task count defaults to **0**
- No application containers are running yet

This ensures `terraform apply` succeeds even before an image is deployed.

---

## Deploy the Application

Deploy the application using the GitHub Actions workflow:

- **Deploy (ECR -> ECS)**

This workflow will:
- Build and push a Docker image to ECR
- Register a new ECS task definition revision
- Update the ECS service to use the new revision

After the workflow completes, scale the service to run tasks:

```bash
terraform apply -var="desired_count=1"
```

---

## Validate Deployment

Use the ALB DNS name output by Terraform:

```bash
curl http://<alb_dns_name>/health
```

Expected response:

```json
{"status":"ok"}
```

You can also visit the ALB DNS name in a browser to view the HTML landing page.

---

## Tear Down the Runtime

To stop all AWS resources and eliminate ongoing costs:

```bash
terraform destroy
```

Terraform will remove all managed resources in the correct dependency order.

---

## State Management Notes

- Terraform state files are stored locally by default
- State files **must not** be committed to Git
- `.gitignore` should include:

```text
**/.terraform/
**/*.tfstate
**/*.tfstate.*
**/.terraform.lock.hcl
```

For team usage or long-term work, a remote backend (S3 + DynamoDB) is recommended.

---

## Design Notes

- Public subnets are used intentionally to avoid NAT Gateway cost
- ECS tasks do not receive public IPs and are reachable only via ALB
- Desired task count defaults to 0 for safe environment creation
- GitHub Actions remains the sole mechanism for application deployment

---

## Summary

This Terraform configuration allows the **cicd-platform** runtime to be:

- Created on demand
- Deployed via CI/CD
- Destroyed cleanly when not in use

This supports rapid experimentation while maintaining production-aligned architecture.
