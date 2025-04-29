resource "aws_s3_bucket" "bucket-for-csv" {
  bucket = "csv-uplods-bucket-terraform-vc"
}

resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda1.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-for-csv.arn
}

resource "aws_s3_bucket_notification" "trigger_lambda" {
  bucket = aws_s3_bucket.bucket-for-csv.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda1.arn
    events              = ["s3:ObjectCreated:*"]  # Trigger on all upload events
    filter_suffix       = ".csv"                 # Optional: only trigger on .csv files
    
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}
