variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "cloudwatch_log_groups" {
  type = list(object({
    name           = string
    filter_pattern = string
  }))
}

variable "consumer_configs" {
  type = list(object({
    url        = string
    identifier = string
  }))
}

variable "fargate_subnets" {
  type = list(string)
}

variable "kinesis_stream_shard_count" {
  type = number
}
