data "archive_file" "make_zip1" {
  type        = "zip"
  source_file = "fetch_data_from_dynamoDB.py"
  output_path = "fetch_data_from_dynamoDB.zip"
}
resource "aws_lambda_function" "lambda" {
  function_name = "fetch-data-from-dunamoDB-Terraform"
  filename         = "${data.archive_file.make_zip1.output_path}"
  source_code_hash = "${data.archive_file.make_zip1.output_base64sha256}"
  role    = aws_iam_role.lambda_iam_role.arn
  handler = "fetch_data_from_dynamoDB.lambda_handler"
  runtime = "python3.9"
}

data "archive_file" "make_zip2" {
  type        = "zip"
  source_file = "s3_trigger_put.py"
  output_path = "s3_trigger_put.zip"
}
resource "aws_lambda_function" "lambda1" {
  function_name = "s3-trigger-put-Terraform"
  filename         = "${data.archive_file.make_zip2.output_path}"
  source_code_hash = "${data.archive_file.make_zip2.output_base64sha256}"
  role    = aws_iam_role.lambda_iam_role.arn
  handler = "s3_trigger_put.lambda_handler"
  runtime = "python3.9"
    environment {
        variables = {
        SECRET_NAME = aws_secretsmanager_secret.dynamodb_secret.name
        SQS_QUEUE_URL = aws_sqs_queue.sqs-queue.url
        }
    }
}


data "archive_file" "make_zip3" {
  type        = "zip"
  source_file = "sqs_file_delete.py"
  output_path = "sqs_file_delete.zip"
}
resource "aws_lambda_function" "lambda2" {
  function_name = "sqs_file_delete-Terraform"
  filename         = "${data.archive_file.make_zip3.output_path}"
  source_code_hash = "${data.archive_file.make_zip3.output_base64sha256}"
  role    = aws_iam_role.lambda_iam_role.arn
  handler = "sqs_file_delete.lambda_handler"
  runtime = "python3.9"
}


data "archive_file" "make_zip4" {
  type        = "zip"
  source_file = "upload_to_s3_from_api.py"
  output_path = "upload_to_s3_from_api.zip"
}
resource "aws_lambda_function" "lambda3" {
  function_name = "upload_to_s3_from_api-Terraform"
  filename         = "${data.archive_file.make_zip4.output_path}"
  source_code_hash = "${data.archive_file.make_zip4.output_base64sha256}"
  role    = aws_iam_role.lambda_iam_role.arn
  handler = "upload_to_s3_from_api.lambda_handler"
  runtime = "python3.9"
    environment {
        variables = {
        BUCKET_NAME = aws_s3_bucket.bucket-for-csv.bucket
        }
    }
}