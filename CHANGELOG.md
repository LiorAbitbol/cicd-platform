# Changelog

All notable changes to this project will be documented in this file.

This project is built incrementally to demonstrate a production-grade CI/CD platform
using GitHub Actions, AWS ECS/Fargate, and Infrastructure as Code (Terraform),
following modern platform engineering and progressive delivery practices.

The format is inspired by Keep a Changelog,
and this project adheres loosely to Semantic Versioning.

---

## [Unreleased]

### Added
- OIDC-based CD workflow to build and push Docker images to ECR
- Automated ECS deployment workflow registering new task definitions and updating the service
- AWS OIDC deploy role permissions for ECR push and ECS service updates
- GitHub Actions deployment workflow (ECR -> ECS) using OIDC (no static credentials)
- Versioned ECS task definition template for repeatable deployments
- CI-only GitHub Actions workflow running ruff lint, pytest, and Docker build validation
- Python package structure for application code (`app/`)
- Minimal test coverage for `/health` endpoint

### Planned
- Manual AWS deployment (ECR + ECS/Fargate + ALB)
- CI pipeline (GitHub Actions): build, test, scan
- CD pipeline with OIDC-based AWS authentication
- Environment promotion (dev → prod)
- Progressive delivery (canary deployment)
- Automated health checks and rollback
- Observability gates (CloudWatch metrics)
- GitOps-style deployment variant
- Reusable CI/CD workflow templates
- Architecture diagrams and documentation

---

## [0.1.1] – ECS Fargate Runtime Baseline

### Added
- Dedicated VPC with two public subnets and internet gateway
- Public route table and subnet associations
- Security groups for ALB and ECS tasks
- ECS cluster, task definition, and service using AWS Fargate
- Application Load Balancer with IP target group
- Health checks configured at both container and ALB levels
- CloudWatch log group for ECS task logs

### Notes
- Runtime was intentionally deployed manually to establish a clear mental model
  before introducing Infrastructure as Code and CI/CD automation.
- This baseline will be recreated using Terraform in a later phase.

---

## [0.1.0] – Initial Local Application Setup

### Added
- FastAPI application with root (`/`) and health (`/health`) endpoints
- Dockerfile for containerizing the application
- Docker Compose configuration for local development
- Initial repository structure for app, infra, scripts, and workflows

### Notes
- This release establishes the local development baseline.
- No cloud infrastructure or CI/CD automation is included yet.
- The `/health` endpoint will be used later for ALB and ECS health checks.

---
