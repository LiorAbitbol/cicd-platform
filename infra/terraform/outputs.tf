output "alb_dns_name" {
  description = "Public ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}
