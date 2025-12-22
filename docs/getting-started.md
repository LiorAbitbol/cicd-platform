# Getting Started

This guide walks through the end-to-end lifecycle of the cicd-platform project:
from infrastructure creation, to application deployment, to clean teardown.

The workflow is intentionally explicit and repeatable.

---

## Prerequisites

Before starting, ensure you have:
* An AWS account with sufficient permissions
* Terraform ≥ 1.5 installed
* Docker installed locally
* GitHub repository with Actions enabled
* AWS OIDC role already configured for GitHub Actions

--- 

## Step 1 — Deploy the AWS Runtime (Terraform)

Terraform owns all AWS runtime infrastructure:
VPC, networking, ALB, ECS, ECR, and logging.

From the repository root:
```bash
cd infra/terraform
terraform init
terraform apply
```

This creates:
* A dedicated VPC with public subnets
* Application Load Balancer
* ECS cluster and service (with desired_count = 0)
* ECR repository
* CloudWatch log group

At this stage:
* No containers are running
* No application is deployed
* Costs are minimal

Terraform will output the ALB DNS name for later use.

---

## Step 2 — Deploy the Application (GitHub Actions)

Push a change to the repository (or manually trigger the workflow):

```bash
git commit -am "change: example update"
git push origin main
```

The GitHub Actions Deploy (ECR → ECS) workflow will:
1. Build the Docker image
2. Push the image to Amazon ECR
3. Register a new ECS task definition revision
4. Update the ECS service to use the new revision

At this point, the service exists but is still scaled to zero.

---

## Step 3 — Start the Service (Scale Up)

Once the image exists in ECR, scale the ECS service to run tasks:

```bash
cd infra/terraform
terraform apply -var="desired_count=1"
```

This will:
* Start a Fargate task
* Register it with the ALB target group
* Begin health checks

Within ~1 minute, the service should become healthy.

---

## Step 4 — Verify the Deployment

Use the ALB DNS name output by Terraform:

```bash
curl http://<alb_dns_name>/health
```

Expected response:

```json
{"status":"ok"}
```

You can also open the ALB DNS name in a browser to view the application landing page.

---

## Step 5 — Stop or Destroy

### Stop the service (keep infrastructure)

To stop all running containers but keep infrastructure:

```bash
terraform apply -var="desired_count=0"
```

This immediately stops compute costs.

### Destroy everything (full teardown)

To remove all AWS resources created by Terraform:

```bash
terraform destroy
```

This deletes:
* ECS service and cluster
* ALB and target group
* Security groups
* VPC and networking
* ECR repository
* CloudWatch log group

No ongoing AWS costs remain.

---

## Summary

The full lifecycle:

1. Create runtime → ```terraform apply```
2. Deploy app → GitHub Actions
3. Run service → ```terraform apply -var="desired_count=1"```
4. Stop or destroy → scale down or ```terraform destroy```

This workflow enables safe experimentation, repeatable environments, and cost control while maintaining production-aligned architecture.
