# ------------------------
# ECS Cluster
# ------------------------
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = {
    Project = "ultimate-devops"
    Env     = var.env
  }
}

# ------------------------
# Application Load Balancer
# ------------------------
resource "aws_lb" "ecs_alb" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.app_sg_id]
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found"
      status_code  = "404"
    }
  }
}

# ------------------------
# Target Groups
# ------------------------
resource "aws_lb_target_group" "appointment" {
  name        = "tg-appointment"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "patient" {
  name        = "tg-patient"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# ------------------------
# Listener Rules
# ------------------------
resource "aws_lb_listener_rule" "appointment" {
  listener_arn = aws_lb_listener.frontend.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appointment.arn
  }

  condition {
    path_pattern {
      values = ["/appointment*"]
    }
  }
}

resource "aws_lb_listener_rule" "patient" {
  listener_arn = aws_lb_listener.frontend.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient.arn
  }

  condition {
    path_pattern {
      values = ["/patient*"]
    }
  }
}

# ------------------------
# ECS Task Definitions
# ------------------------
resource "aws_ecs_task_definition" "appointment" {
  family                   = "appointment-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role

  container_definitions = jsonencode([{
    name      = "appointment-container"
    image     = var.appointment_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_task_definition" "patient" {
  family                   = "patient-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role

  container_definitions = jsonencode([{
    name      = "patient-container"
    image     = var.patient_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 8081
      hostPort      = 8081
      protocol      = "tcp"
    }]
  }])
}

# ------------------------
# ECS Services
# ------------------------
resource "aws_ecs_service" "appointment" {
  name            = "appointment-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.appointment.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.app_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.appointment.arn
    container_name   = "appointment-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener_rule.appointment]
}

resource "aws_ecs_service" "patient" {
  name            = "patient-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.patient.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.app_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.patient.arn
    container_name   = "patient-container"
    container_port   = 8081
  }

  depends_on = [aws_lb_listener_rule.patient]
}
