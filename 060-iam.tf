data "aws_iam_policy_document" "cloudwatch_asssume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_permission" {
  statement {
    actions   = ["kinesis:PutRecord"]
    resources = [aws_kinesis_stream.default.arn]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name_prefix        = "${var.project_name}-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_asssume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "cloudwatch" {
  name_prefix = "${var.project_name}-cloudwatch-policy"
  policy      = data.aws_iam_policy_document.cloudwatch_permission.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

#####################################################

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_permission" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name_prefix        = "${var.project_name}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "ecs_task_execution" {
  name_prefix = "${var.project_name}-ecs-task-execution-policy"
  policy      = data.aws_iam_policy_document.ecs_task_execution_permission.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}

###

data "aws_iam_policy_document" "ecs_task_permission" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      # "dynamodb:CreateTable",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem"
    ]
    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.dynamodb_table_name}"]
  }

  statement {
    actions = [
      "kinesis:ListShards",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator"
    ]
    resources = [aws_kinesis_stream.default.arn]
  }
}

resource "aws_iam_role" "ecs_task" {
  name_prefix        = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "ecs_task" {
  name_prefix = "${var.project_name}-ecs-task-role-policy"
  policy      = data.aws_iam_policy_document.ecs_task_permission.json
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task.arn
}
