resource "aws_ecs_task_definition" "keycloak" {
  family                   = "${var.service_name}-TD"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.image_uri
      portMappings = [{ containerPort = 8080, hostPort = 8080, protocol = "tcp" }]
    }
  ])
}

resource "aws_ecs_service" "keycloak_service" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.keycloak.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-xxxxxxx"]   # 修改为你的 VPC 子网
    security_groups = ["sg-xxxxxxx"]       # 修改为你的安全组
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.keycloak]
}