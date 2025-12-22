# cicd-platform

A production-grade, reference CI/CD platform project built to demonstrate
modern software delivery practices using GitHub Actions, AWS Elastic Container Service (ECS),
and Infrastructure as Code (IaC).

See the **Documentation** section below for deployment, runtime, and teardown guides.

---

## What This Project Demonstrates

This project demonstrates how modern engineering teams design, secure, and operate
CI/CD systems in production environments.

Specifically, it shows:

- How to build CI and CD as **separate but connected systems**
- How to deploy to AWS without long-lived credentials using **OIDC**
- How container images, task definitions, and services interact in ECS
- How health checks propagate from container → service → load balancer
- How to reason about deployment safety, not just automation speed

The emphasis is on **understanding system boundaries**, not just assembling tools.

---

## Project Goals

- Build a realistic CI/CD platform from first principles
- Separate **confidence (CI)** from **risk (CD)**
- Avoid long-lived credentials using AWS OIDC
- Favor clarity, observability, and reproducibility over shortcuts

---

## Architecture Overview

High-level target architecture:

```
GitHub (Source)
  ↓
GitHub Actions (CI)
  - Lint
  - Tests
  - Docker build
  ↓
Artifact Registry (Amazon ECR)
  ↓
GitHub Actions (CD via OIDC)
  ↓
AWS ECS Fargate
  ↓
Application Load Balancer
```

---

## CI/CD Philosophy

This repository intentionally separates **Continuous Integration (CI)** from
**Continuous Deployment (CD)**:

- **CI** exists to build confidence:
  - Code quality
  - Test correctness
  - Artifact validity

- **CD** exists to manage risk:
  - Secure identity and access
  - Controlled rollouts
  - Health-gated deployments

Automation is introduced only after the runtime behavior is fully understood.
This mirrors how mature platform teams design delivery systems.

---

## Repository Structure

```
.
├── app/                      # FastAPI application source
├── tests/                    # Unit and integration tests
├── docker/                   # Container build assets
│   └── Dockerfile
├── infra/                    # Infrastructure and deployment artifacts
│   └── ecs/
│       └── task-definition.json
├── docs/                     # Runbooks, setup guides, and architecture notes   
├── scripts/                  # Helper and utility scripts
├── .github/
│   └── workflows/            # GitHub Actions CI/CD pipelines
│       ├── ci.yml
│       └── deploy.yml
├── .gitignore                # Git ignore rules
├── compose.yaml              # Local Docker Compose workflow
├── pyproject.toml            # Tooling configuration (ruff, pytest, etc.)
├── requirements-dev.txt      # Development and test dependencies
├── CHANGELOG.md              # Project change history
└── README.md                 # Project overview and documentation
```

---

## Documentation

The following guides describe how to operate and extend the platform:

### Core Workflows

- **Getting Started**  
  [`docs/getting-started.md`](docs/getting-started.md)
  End-to-end walkthrough for deploying, running, and tearing down the platform.

- **Terraform Runtime Lifecycle**  
  [`docs/terraform-runtime.md`](docs/terraform-runtime.md)
  Details how AWS infrastructure is created, scaled, and destroyed using Terraform.

### Security & Identity 

- **GitHub Actions OIDC Setup**  
  [`docs/oidc-setup.md`](docs/oidc-setup.md)
  Explains secure, credential-free authentication between GitHub Actions and AWS.

### Local Development 

- **Local Docker Development**  
  [`docs/local-docker.md`](docs/local-docker.md)
  Instructions for building and running the application locally with Docker.

---

## How to Reason About This System

At a high level, the delivery flow looks like:

1. Confidence (CI)
2. Immutable Artifact (Docker image)
3. Verified Identity (OIDC)
4. Deployment (ECS service update)
5. Health Validation
6. Traffic Routing (ALB)

Each stage introduces a boundary that reduces risk and increases observability. Understanding these boundaries is more important than any individual tool choice.

---

## Current State

- [x] FastAPI application with health endpoint
- [x] Dockerized application with deterministic builds
- [x] Dedicated AWS VPC with public subnets
- [x] ECS Fargate runtime behind an Application Load Balancer
- [x] CI pipeline (GitHub Actions) for linting, testing, and image validation
- [x] CD pipeline using GitHub Actions + AWS OIDC (no static credentials)
- [x] Automated ECR image publishing and ECS service deployments
- [x] Health-gated, rolling deployments via ECS services
- [x] Local Docker development workflow
- [x] Operator-grade documentation and runbooks

Together, these components form a complete, reproducible CI/CD platform suitable for reference and extension.

---

## Local Development

### Python (recommended)

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt -r requirements-dev.txt
ruff check .
pytest -q
```

### Docker

See [`docs/local-docker.md`](docs/local-docker.md) for full instructions.

---

## Optional Next Steps

This project is intentionally complete in its current form.
Possible future extensions include:

- Extending Terraform to manage IAM and GitHub OIDC resources
- Multi-environment promotion (dev → prod)
- Deployment safety features (canary / rollback automation)
- Observability enhancements (metrics and alerts)

These are extensions, not requirements, for understanding the core system.

---

## Disclaimer

This repository is designed for learning, demonstration, and portfolio purposes.
It intentionally favors clarity over completeness and should not be used
as-is for production workloads without further hardening.

---

## License

MIT
