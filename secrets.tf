resource "aws_secretsmanager_secret" "dynamodb_secret" {
  name        = "dynamodb_secret_terraform"
  description = "Secret for Dynamo"
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.dynamodb_secret.id
  secret_string = jsonencode({ "table_name" = "CSV_DATA"})
  
}
