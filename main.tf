terraform {
  backend "s3" {}
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

# -----------------------------
# ECS Cluster
# -----------------------------
resource "aws_ecs_cluster" "ecs" {
  name = "my-ecs-cluster-${var.env}"
}

# -----------------------------
# ECS Task Definition
# -----------------------------
resource "aws_ecs_task_definition" "task" {
  family                   = "my-ecs-task-${var.env}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = var.ecs_task_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([{
    name      = "app-container"
    image     = var.image_uri
    essential = true

    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# -----------------------------
# ECS Service
# -----------------------------
resource "aws_ecs_service" "service" {
  name            = "my-ecs-service-${var.env}"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = false
  }
}
