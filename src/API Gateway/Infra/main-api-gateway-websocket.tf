

############################################################################
Cria lambdas para integração com websocket api
############################################################################
resource "aws_lambda_function" "connect_handler" {
  function_name = "ConnectHandler"
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "connect_handler.zip"  # Replace with the path to your Lambda deployment package

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.websocket_connections.name
    }
  }
}

resource "aws_lambda_function" "disconnect_handler" {
  function_name = "DisconnectHandler"
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "disconnect_handler.zip"  # Replace with the path to your Lambda deployment package

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.websocket_connections.name
    }
  }
}

resource "aws_lambda_function" "notification_handler" {
  function_name = "NotificationHandler"
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "notification_handler.zip"  # Replace with the path to your Lambda deployment package

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.websocket_connections.name
      API_GATEWAY_ENDPOINT = "https://${aws_apigatewayv2_api.websocket_api.id}.execute-api.us-east-1.amazonaws.com/production"
    }
  }
}



############################################################################
Cria websocket api
############################################################################

resource "aws_apigatewayv2_api" "websocket_api" {
  name                       = "WebSocketAPI"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "connect_integration" {
  api_id           = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.connect_handler.invoke_arn
}

resource "aws_apigatewayv2_integration" "disconnect_integration" {
  api_id           = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.disconnect_handler.invoke_arn
}

resource "aws_apigatewayv2_integration" "notification_integration" {
  api_id           = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.notification_handler.invoke_arn
}

resource "aws_apigatewayv2_route" "connect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect_integration.id}"
}

resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect_integration.id}"
}

resource "aws_apigatewayv2_route" "notification_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "notify"
  target    = "integrations/${aws_apigatewayv2_integration.notification_integration.id}"
}

resource "aws_apigatewayv2_stage" "production" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  name        = "production"
  auto_deploy = true
}