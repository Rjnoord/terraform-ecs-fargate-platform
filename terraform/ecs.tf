resource "aws_ecs_cluster" "Main" {
    name = "ecs-fargate-cluster"

    setting {
      name = "containerInsights"
      value = "enabled"
    }

    tags = {
      Name = "ecs-fargate-cluster"
    }
  
}

resource "aws_ecs_task_definition" "app" {
    family = "ecs-fargate-devops-app"
    requires_compatibilities = ["FARGATE"]

    network_mode = "awsvpc"

    cpu = 256
    memory = 512

    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([
      {
        name = "ecs-fargate-devops-app"
        image = "${aws_ecr_repository.app.repository_url}:latest"
        essential = true

        portMappings = [
          {
            containerPort = 5000
            hostPort = 5000
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group = aws_cloudwatch_log_group.ecs_logs.name
            awslogs-region = var.aws_region
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ])
  
}

resource "aws_ecs_service" "app" {
    name = "ecs-fargate-service"
    cluster = aws_ecs_cluster.Main.id
    task_definition = aws_ecs_task_definition.app.arn

    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = [
        aws_subnet.public_subnet_A.id,
        aws_subnet.public_subnet_B.id
      ]
      security_groups = [
        aws_security_group.ecs-sg.id
      ]
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.app.arn
      container_name = "ecs-fargate-devops-app"
      container_port = 5000
    }

  
}