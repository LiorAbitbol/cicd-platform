# Changelog

All notable changes to this project will be documented in this file.

This project is built incrementally to demonstrate a production-grade CI/CD platform
using GitHub Actions, AWS ECS/Fargate, and Infrastructure as Code,
following modern platform engineering and progressive delivery practices.

The format is inspired by Keep a Changelog,
and this project adheres loosely to Semantic Versioning.

---

## [Unreleased]

### Possible Extensions
- Infrastructure as Code (Terraform) for ECS runtime and networking
- Multi-environment promotion (dev → prod)
- Progressive delivery (canary or blue/green deployments)
- Automated rollback on failed health checks
- Observability gates using CloudWatch metrics and alarms
- GitOps-style deployment variant
- Reusable CI/CD workflow templates

---

## [0.2.0] – Secure CI/CD Platform Completion

### Added
- End-to-end CI/CD pipeline using GitHub Actions and AWS ECS/Fargate
- OIDC-based authentication between GitHub Actions and AWS (no static credentials)
- Automated Docker image publishing to Amazon ECR
- Automated ECS task definition registration and rolling service deployments
- Health-gated deployments behind an Application Load Balancer
- Public service validation via ALB DNS endpoint
- Simple HTML landing page for root endpoint (`/`)
- Clean, production-aligned repository structure
- Operator-grade documentation and runbooks for local and cloud workflows

### Notes
- This release completes the core CI/CD platform implementation.
- The system mirrors deployment patterns used by modern platform engineering teams.

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
- The `/health` endpoint is used for ALB and ECS health checks.
