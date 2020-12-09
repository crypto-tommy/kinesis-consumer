output "consumer_access_key_id" {
  value = aws_iam_access_key.consumer.id
}

output "consumer_access_key_secret" {
  value = aws_iam_access_key.consumer.secret
}
