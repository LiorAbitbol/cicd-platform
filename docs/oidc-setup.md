# GitHub Actions → AWS OIDC Setup (Smoke Test)

This document describes how to configure **OpenID Connect (OIDC)** between
GitHub Actions and AWS, and how to validate the setup using a safe smoke test.

This setup enables GitHub Actions to assume an AWS IAM role **without using
long-lived AWS access keys or secrets**.

---

## Overview

OIDC allows GitHub Actions to:
- Prove its identity to AWS at runtime
- Receive short-lived AWS credentials from STS
- Avoid storing AWS secrets in GitHub

This project uses OIDC as the foundation for secure CI/CD deployments.

---

## Prerequisites

- AWS account with IAM access
- GitHub repository: `cicd-platform`
- Default branch: `main`
- AWS region: `us-east-1`

---

## Step 1 – Create the GitHub OIDC Identity Provider

**AWS Console**
- Service: IAM
- Section: Identity providers
- Action: Add provider

**Settings**
- Provider type: OpenID Connect
- Provider URL:
  ```
  https://token.actions.githubusercontent.com
  ```
- Audience:
  ```
  sts.amazonaws.com
  ```

Create the provider.

---

## Step 2 – Create an IAM Role for GitHub Actions

**AWS Console**
- Service: IAM
- Section: Roles
- Action: Create role

**Trusted entity**
- Type: Web identity
- Identity provider: `token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

Proceed to permissions.

---

## Step 3 – Attach Smoke Test Permissions

Create and attach a minimal policy that allows identity verification only.

**Policy JSON**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SmokeTest",
      "Effect": "Allow",
      "Action": "sts:GetCallerIdentity",
      "Resource": "*"
    }
  ]
}
```

**Policy name**
```
cicd-platform-oidc-smoketest
```

Attach this policy to the role.

---

## Step 4 – Name the Role

**Role name**
```
cicd-platform-github-oidc
```

Create the role.

---

## Step 5 – Lock the Role to Repo and Branch

Edit the role **Trust relationship** and replace the policy with the following.

> Replace `<ACCOUNT_ID>` and `<GITHUB_OWNER>` if needed.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_OWNER>/cicd-platform:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

---

## Step 6 – GitHub Actions Smoke Test Workflow

Create the following workflow file:

**`.github/workflows/oidc-smoke-test.yml`**

```yaml
name: OIDC Smoke Test (AWS)

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<ACCOUNT_ID>:role/cicd-platform-github-oidc
          aws-region: us-east-1

      - name: Verify identity
        run: aws sts get-caller-identity
```

---

## Step 7 – Run the Smoke Test

GitHub:
- Navigate to **Actions**
- Select **OIDC Smoke Test (AWS)**
- Click **Run workflow**

### Success Criteria
- Workflow completes successfully
- Output shows the assumed IAM role and AWS account ID

---

## Common Errors & Fixes

### No OpenIDConnect provider found
- Ensure the provider URL is exactly:
  `https://token.actions.githubusercontent.com`

### Not authorized to perform sts:AssumeRoleWithWebIdentity
- Trust policy `sub` does not match repo or branch
- Workflow missing:
  ```yaml
  permissions:
    id-token: write
  ```

### AccessDenied on sts:GetCallerIdentity
- Policy not attached to the role

---

## Notes

- This smoke test validates identity only.
- No AWS resources are created or modified.
- This role will be expanded later for ECR and ECS access.

---

## Next Steps

- Add ECR permissions to the role
- Deploy container images via GitHub Actions
- Automate ECS service updates

This OIDC setup is the foundation for secure CD.
