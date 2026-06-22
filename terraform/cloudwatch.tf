resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/fargate-devops-app"
  retention_in_days = 14

  tags = {
    Name = "ecs-fargate-logs"
  }
}

