output "task_definition_arn" {
  value = aws_ecs_task_definition.keycloak.arn
}

output "service_name" {
  value = aws_ecs_service.keycloak_service.name
}