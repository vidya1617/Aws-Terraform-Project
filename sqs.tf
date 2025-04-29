resource "aws_sqs_queue" "sqs-queue" {
  name = "terraform-sqs-queue"
  delay_seconds = 120
  
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0

  sqs_managed_sse_enabled = true
}
resource "aws_lambda_event_source_mapping" "from_sqs" {
  event_source_arn = aws_sqs_queue.sqs-queue.arn
  function_name    = aws_lambda_function.lambda2.function_name
  batch_size       = 1
  enabled          = true
}

  
