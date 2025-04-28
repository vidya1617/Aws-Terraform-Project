# Create API Gateway
resource "aws_api_gateway_rest_api" "terraform_api" {
  name        = "terraform-api-task"
  description = "API Gateway created using Terraform"
  binary_media_types = ["*/*"] 
}

# Create a Resource (Path: /details)
resource "aws_api_gateway_resource" "details_resource" {
  rest_api_id = aws_api_gateway_rest_api.terraform_api.id
  parent_id   = aws_api_gateway_rest_api.terraform_api.root_resource_id
  path_part   = "details"
}

# Create a GET Method for /details
resource "aws_api_gateway_method" "details_get" {
  rest_api_id   = aws_api_gateway_rest_api.terraform_api.id
  resource_id   = aws_api_gateway_resource.details_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create a post Method for /details
resource "aws_api_gateway_method" "details_post" {
  rest_api_id   = aws_api_gateway_rest_api.terraform_api.id
  resource_id   = aws_api_gateway_resource.details_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
# Integration for GET /details
resource "aws_api_gateway_integration" "lambda_integration1" {
  rest_api_id             = aws_api_gateway_rest_api.terraform_api.id
  resource_id             = aws_api_gateway_resource.details_resource.id
  http_method             = aws_api_gateway_method.details_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# Integration for POST /details
resource "aws_api_gateway_integration" "lambda_integration2" {
  rest_api_id             = aws_api_gateway_rest_api.terraform_api.id
  resource_id             = aws_api_gateway_resource.details_resource.id
  http_method             = aws_api_gateway_method.details_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda1.invoke_arn
}

# Permission for API Gateway to invoke GET Lambda
resource "aws_lambda_permission" "apigw_get_invoke" {
  statement_id  = "AllowAPIGatewayInvokeGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.terraform_api.execution_arn}/*/*"
}

# Permission for API Gateway to invoke POST Lambda
resource "aws_lambda_permission" "apigw_post_invoke" {
  statement_id  = "AllowAPIGatewayInvokePost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.terraform_api.execution_arn}/*/*"
}

# Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration1,
    aws_api_gateway_integration.lambda_integration2
  ]

  rest_api_id = aws_api_gateway_rest_api.terraform_api.id
}

resource "aws_api_gateway_stage" "dev_stage" {
  rest_api_id   = aws_api_gateway_rest_api.terraform_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  stage_name    = "dev1"
}
