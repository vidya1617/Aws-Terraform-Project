resource "aws_dynamodb_table" "terraform-dynamodb" {
  name         = "CSV_DATA"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"
  range_key = "name"
    attribute {
    name = "ID"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }
}