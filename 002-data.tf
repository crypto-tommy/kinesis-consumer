data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "docker_registry_image" "default" {
  name = "crypto1tim/kinesis-data-stream-java-connector:latest"
}