variable "ecr_repo_name" {
  type        = string
  description = "Existing ECR repository name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private Subnets for ECS Tasks"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Groups for ECS Tasks"
}
