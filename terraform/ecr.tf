resource "aws_ecr_repository" "app" {
  name                 = "ecs-fargate-devops-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecs-fargate-devops-app"
  }
}

