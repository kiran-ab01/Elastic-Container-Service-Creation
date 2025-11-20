env                =  "#{environment}"
aws_region         = "us-east-1"
# aws_profile removed, credentials passed via Octopus
ecs_task_role_arn  = "arn:aws:iam::741846357014:role/AWS-Destination-OIDC"
image_uri          = "226290659955.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0.3"
# subnet_ids         = ["subnet-0abda569ac03ecd54", "subnet-047b8f6e14139357c"]
# security_group_ids = ["sg-0b6fa222cc6ae9daa"]
desired_count      = 2
