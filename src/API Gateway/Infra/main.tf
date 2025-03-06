provider "aws" {
  region = "us-east-1"
}

resource "aws_api_gateway_rest_api" "user_preferences_api" {
  name        = "user-preferences-api"
  description = "API for managing user preferences"
}

resource "aws_api_gateway_resource" "user_preferences" {
  rest_api_id = aws_api_gateway_rest_api.user_preferences_api.id
  parent_id   = aws_api_gateway_rest_api.user_preferences_api.root_resource_id
  path_part   = "preferences"
}

resource "aws_api_gateway_method" "get_user_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.user_preferences_api.id
  resource_id   = aws_api_gateway_resource.user_preferences.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_user_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.user_preferences_api.id
  resource_id   = aws_api_gateway_resource.user_preferences.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id = aws_api_gateway_rest_api.user_preferences_api.id
  resource_id = aws_api_gateway_resource.user_preferences.id
  http_method = aws_api_gateway_method.post_user_preferences.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.user_preferences_lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_preferences_api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.user_preferences_lambda.function_name
}
