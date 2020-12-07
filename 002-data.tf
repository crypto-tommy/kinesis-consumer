data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ecr_repository" "default" {
  name = local.fargate_image_name
}