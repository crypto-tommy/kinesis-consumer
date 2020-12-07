locals {
  tags = {
    Maintainer = "Tim"
    Module     = basename(abspath(path.root))
    Team       = "sec-it"
    Version    = "1.0.0"
  }

  cloudwatch_log_groups = {
    for item in var.cloudwatch_log_groups : item.name => item
  }

  dynamodb_table_name = "${var.project_name}-kinesis-stream-dynamodb-table"

  fargate_image_name = "kinesis-stream-consumer"
}
