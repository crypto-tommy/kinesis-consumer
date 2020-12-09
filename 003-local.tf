locals {
  tags = {
    Maintainer = "Tim"
    Module     = basename(abspath(path.root))
    Team       = "sec-it"
    Version    = "1.0.1"
  }

  cloudwatch_log_groups = {
    for item in var.cloudwatch_log_groups : item.name => item
  }

  consumer_configs = {
    for item in var.consumer_configs : item.identifier => merge(item, {
      dynamodb_table_name = "${var.project_name}-kinesis-stream-${item.identifier}-dynamodb-table"
    })
  }

}
