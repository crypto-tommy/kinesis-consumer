resource "aws_ecs_cluster" "default" {
  name               = "${var.project_name}-ecs-cluster"
  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.tags
}

resource "aws_ecs_service" "default" {
  for_each = local.consumer_configs

  name            = "${var.project_name}-${each.value.identifier}-ecs-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default[each.key].arn

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.fargate_subnets
  }

  desired_count = aws_kinesis_stream.default.shard_count

  tags = local.tags
}

###

resource "aws_ecs_task_definition" "default" {
  for_each = local.consumer_configs

  family = "${var.project_name}-ecs-task"

  container_definitions = templatefile("statics/java-connector/service.json", {
    image_name = regex("[^/]+$",(regex("^[^:]+",data.docker_registry_image.default.name)))
    image_url  = data.docker_registry_image.default.name

    dynamodb_table_name       = each.value.dynamodb_table_name
    region_name               = data.aws_region.current.name
    kinesis_input_stream_name = aws_kinesis_stream.default.name
    destination_identifier    = each.value.identifier
    destination_url           = each.value.url
  })

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]

  tags = local.tags

  # Let terraform create the table, the image can create table by itself, avoid it.
  depends_on = [
    aws_dynamodb_table.default
  ]
}
