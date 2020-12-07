resource "aws_kinesis_stream" "default" {
  name             = "${var.project_name}-kinesis-stream"
  shard_count      = var.kinesis_stream_shard_count
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = local.tags
}

resource "aws_cloudwatch_log_subscription_filter" "default" {
  for_each = local.cloudwatch_log_groups

  name            = "${var.project_name}-kinesis-stream-filter"
  role_arn        = aws_iam_role.cloudwatch.arn
  log_group_name  = each.value.name
  filter_pattern  = each.value.filter_pattern
  destination_arn = aws_kinesis_stream.default.arn
  distribution    = "Random"
}
