# -----------------------------
# Load existing ECR Repository
# -----------------------------l
data "aws_ecr_repository" "app" {
  name = var.ecr_repo_name   # Replace in terraform.tfvars
}

locals {
  image = "${data.aws_ecr_repository.app.repository_url}:latest"
}

# -----------------------------
# ECS Cluster
# -----------------------------
resource "aws_ecs_cluster" "ecs" {
  name = "my-ecs-cluster"
}

# -----------------------------
# IAM Execution Role
# -----------------------------
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-basic"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------------
# ECS Task Definition
# -----------------------------
resource "aws_ecs_task_definition" "task" {
  family                   = "my-ecs-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "app-container"
      image = local.image     # Pulls :latest from ECR
      essential = true

      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])
}

# -----------------------------
# ECS Service
# -----------------------------
resource "aws_ecs_service" "service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids          # Replace
    security_groups = var.security_group_ids  # Replace
    assign_public_ip = false
  }
}
