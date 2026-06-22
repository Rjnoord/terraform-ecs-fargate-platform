

resource "aws_lb" "app" {
    name = "ecs-fargate-alb"
    internal = false 
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.alb-sg.id
    ]

    subnets = [
        aws_subnet.public_subnet_A.id,
        aws_subnet.public_subnet_B.id
    ]
  
}

resource "aws_lb_target_group" "app" {
    name = "ecs-fargate-tg"
    port = 5000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.Main.id 

    health_check {
      path = "/health"
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app.arn

    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app.arn
    }
  
}

