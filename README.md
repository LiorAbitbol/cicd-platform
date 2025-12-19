# cicd-platform

A production-inspired CI/CD platform project built to demonstrate
modern software delivery practices using GitHub Actions, AWS ECS/Fargate,
and Infrastructure as Code.

---

## 🎯 Project Goals

- Build a realistic CI/CD platform from first principles
- Separate **confidence (CI)** from **risk (CD)**
- Avoid long-lived credentials using AWS OIDC
- Favor clarity, observability, and reproducibility over shortcuts

---

## 🏗️ Architecture Overview

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

## 📁 Repository Structure

```
.
├── app/                     # FastAPI application
├── docker/                  # Dockerfile
├── tests/                   # Unit tests
├── scripts/                 # Helper scripts
├── infra/                   # Infrastructure as Code
├── docs/                    # Runbooks and guides
├── .github/workflows/       # GitHub Actions pipelines
├── CHANGELOG.md
└── README.md
```

---

## ✅ Current State

- [x] FastAPI application with health endpoint
- [x] Dockerized application
- [x] Dedicated AWS VPC with public subnets
- [x] ECS Fargate runtime behind an ALB
- [x] CI-only GitHub Actions workflow (lint, tests, docker build)
- [x] Local Docker development workflow
- [x] Operator-grade documentation (runbooks)

---

## 🧪 Local Development

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

## ⚠️ Disclaimer

This repository is designed for learning, demonstration, and portfolio purposes.
It intentionally favors clarity over completeness and should not be used
as-is for production workloads without further hardening.

---

## 📜 License

MIT
