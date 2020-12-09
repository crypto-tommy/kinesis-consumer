# hash_key based on sumologic java connector, https://github.com/SumoLogic/sumologic-kinesis-connector
resource "aws_dynamodb_table" "default" {
  for_each = local.consumer_configs

  name           = each.value.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "leaseKey"

  attribute {
    name = "leaseKey"
    type = "S"
  }

  tags = local.tags
}
