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
  name            = "${var.project_name}-ecs-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.arn

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.fargate_subnets
  }

  desired_count = aws_kinesis_stream.default.shard_count

  tags = local.tags
}

###

resource "aws_ecs_task_definition" "default" {
  family = "${var.project_name}-ecs-task"

  container_definitions = templatefile("statics/java-connector/service.json", {
    image_name = data.aws_ecr_repository.default.name
    image_url  = data.aws_ecr_repository.default.repository_url

    dynamodb_table_name       = local.dynamodb_table_name
    region_name               = data.aws_region.current.name
    kinesis_input_stream_name = aws_kinesis_stream.default.name
    destination_identifier    = ""
    destination_url           = var.destination_url
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
