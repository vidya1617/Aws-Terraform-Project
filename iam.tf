resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda-API-IAM-Role-Terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy_attachment" "API_policy1" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_policy_attachment" "API_policy2" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}
resource "aws_iam_policy_attachment" "API_policy3" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_policy_attachment" "API_policy4" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}
resource "aws_iam_policy_attachment" "API_policy5" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}
resource "aws_iam_policy_attachment" "API_policy6" {
  name       = "API-Lambda-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
resource "aws_iam_policy_attachment" "API_policy_logs" {
  name       = "API-Lambda-logs-policy"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
