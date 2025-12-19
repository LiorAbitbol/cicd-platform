# OIDC
OIDC (OpenID Connect) is a secure way for one system to prove its identity to another system without sharing passwords or long-lived secrets.


## Why this is important

### Security
* No stored secrets
* Credentials expire automatically
* Reduced blast radius

### Compliance
* Strong audit trail
* Clear identity attribution
* Easy to reason about access

### Operations
* No key rotation
* Fewer outages
* Less cognitive load


## The core problem OIDC solves

### The old way
* Create an AWS access key
* Store it as a GitHub secret
* Hope it does not leak
* Rotate it periodically 
#### Problems
* Long-lived credentials
* Secret sprawl 
* High blast radius
* Poor auditability

## The modern way
* GitHub proves its identity dynamically
* AWS issues short-lived credentials
* Nothing sensitive is stored


## OIDC flow
```
GitHub Actions
   |
   | 1. Requests an OIDC token (JWT)
   |
   v
GitHub OIDC Provider
   |
   | 2. Issues signed token (who, repo, branch, run id)
   |
   v
AWS STS
   |
   | 3. Validates token + trust policy
   |
   v
Temporary AWS Credentials
   |
   v
AWS APIs (ECR, ECS, etc.)
```


## OIDC token

The token contains claims, such as:
* Repository name
* GitHub org
* Branch
* Workflow name
* Environment

Example: AWS can be specified to only trust tokens from *this repo*, on *this branch*, for *this purpose* to provide least privilege access.


## What AWS needs to trust GitHub
AWS requires two things:

### 1. An OIDC identity provider
AWS knows:
* Where GitHub's identity service lives
* How to validate its signatures

For GitHub, the provider url is:
```
https://token.actions.githubusercontent.com
```

### 2. An IAM role with a trust policy
The trust policy says:
* Who can assume the role (GitHub)
* Under what conditions (repo, branch, environment)

Example:
```
"Condition": {
  "StringEquals": {
    "token.actions.githubusercontent.com:sub": "repo:your-org/cicd-platform:ref:refs/heads/main"
  }
}
```
