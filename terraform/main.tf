resource "aws_default_vpc" "ecs_vpc" {

  tags = {
    env = var.env
  }
}

resource "aws_default_subnet" "eu-central-1a" {
  availability_zone = "eu-central-1a"

  tags = {
    env = var.env
  }
}

resource "aws_default_subnet" "eu-central-1b" {
  availability_zone = "eu-central-1b"


  tags = {
    env = var.env
  }
}

resource "aws_security_group" "ecs_sg" {

  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_default_vpc.ecs_vpc.id

  ingress {
    description = "Allow HTTP for all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "ecs_lb" {

  name               = "blockchain-api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_default_subnet.eu-central-1a.id, aws_default_subnet.eu-central-1b.id]
  tags = {
    env = var.env
  }
}


resource "aws_lb_target_group" "ecs_lb_tg" {

  name        = "tf-blockchain-api-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.ecs_vpc.id
}

resource "aws_lb_listener" "ecs_lb_listener" {

  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
  }
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name     = "blockchain-api-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "my-personal-web" {

  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "ecs_task_definition" {

  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.containerCpu
  memory                   = var.containerMempry
  container_definitions = jsonencode([
    {
      name      = var.appName
      image     = var.appImage
      cpu       = var.containerCpu
      memory    = var.containerMempry
      essential = true
      portMappings = [
        {
          containerPort = var.appPort
          hostPort      = var.appPort
        }
      ],
      environment = var.environment
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {

  name            = var.appName
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.replicaCount
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_default_subnet.eu-central-1a.id, aws_default_subnet.eu-central-1b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
    container_name   = var.appName
    container_port   = 80
  }

  tags = {
    env = var.env
  }
}



