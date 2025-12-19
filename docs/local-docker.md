# Local Docker Build & Run Guide

This document describes how to build, run, verify, and clean up the application
locally using Docker.

This workflow mirrors how the application runs in ECS/Fargate and is useful for:
- Verifying container behavior before deployment
- Debugging startup or health check issues
- Ensuring consistency between local, CI, and production environments

---

## Prerequisites

- Docker installed and running
- Port `8000` available on the local machine
- Commands executed from the **repository root**

---

## Step 1 – Build the Docker Image

Build the image using the project Dockerfile:

```bash
docker build -f docker/Dockerfile -t cicd-platform:local .
```

This command:
- Uses the Dockerfile located at `docker/Dockerfile`
- Tags the image as `cicd-platform:local`

Verify the image exists:

```bash
docker images | grep cicd-platform
```

---

## Step 2 – Run the Container Locally

Start the container in detached mode:

```bash
docker run -d \
  --name cicd-platform-local \
  -p 8000:8000 \
  cicd-platform:local
```

Options explained:
- `-d` runs the container in the background
- `--name` assigns a predictable container name
- `-p 8000:8000` maps the host port to the container port

Verify the container is running:

```bash
docker ps | grep cicd-platform-local
```

---

## Step 3 – Verify the Application

### Health endpoint

```bash
curl http://localhost:8000/health
```

Expected response:

```json
{"status":"ok"}
```

### Root endpoint (optional)

```bash
curl http://localhost:8000/
```

---

## Step 4 – View Container Logs (Optional)

To view application logs:

```bash
docker logs cicd-platform-local
```

These logs are equivalent to what is later captured in CloudWatch Logs
when running in ECS/Fargate.

---

## Step 5 – Stop and Remove the Container

### Stop the container

```bash
docker stop cicd-platform-local
```

### Remove the container

```bash
docker rm cicd-platform-local
```

Verify it has been removed:

```bash
docker ps -a | grep cicd-platform-local
```

No output indicates successful removal.

---

## Step 6 – Remove the Image (Optional Cleanup)

If you want to remove the local image as well:

```bash
docker rmi cicd-platform:local
```

---

## Notes

- If the application works locally using this process, it should behave
  identically when deployed to ECS/Fargate.
- This workflow is intentionally simple and does not use Docker Compose.
- A Makefile or helper scripts may be added later for convenience.
