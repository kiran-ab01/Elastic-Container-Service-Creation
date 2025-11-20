variable "env" {
  type        = string
  description = "Environment name (uat/prod)"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}



variable "ecs_task_role_arn" {
  type        = string
  description = "Existing IAM Role ARN for ECS task execution"
}

variable "image_uri" {
  type        = string
  description = "Full URI of the Docker image (including tag)"
}

# variable "subnet_ids" {
#  type        = list(string)
#  description = "Private Subnets for ECS Tasks"
# }



variable "desired_count" {
  type    = number
  default = 1
}
