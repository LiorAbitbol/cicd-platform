variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name prefix"
  default     = "cicd-platform"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.20.0.0/16"
}

variable "app_port" {
  type        = number
  description = "Container/listener port for the application"
  default     = 8000
}

variable "desired_count" {
  type        = number
  description = "ECS service desired count. Default 0 so apply works before first image push."
  default     = 0
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR repository name"
  default     = "cicd-platform"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "cicd-pipeline-cluster"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
  default     = "cicd-pipeline-task-service"
}

variable "task_family" {
  type        = string
  description = "ECS task definition family name"
  default     = "cicd-pipeline-task"
}

variable "container_name" {
  type        = string
  description = "Container name in task definition"
  default     = "api"
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch log group for ECS tasks"
  default     = "/ecs/cicd-pipeline-task"
}
