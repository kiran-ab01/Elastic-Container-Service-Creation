# Replace with your ECR repo name (WITHOUT URL)
ecr_repo_name = "deploy-aws-ecr"

# Replace with your existing subnet IDs (private)
subnet_ids = [
  "subnet-0abda569ac03ecd54",
  "subnet-047b8f6e14139357c"
]

# Replace with security group that allows ECS tasks
security_group_ids = [
  "sg-0b6fa222cc6ae9daa"
]
