

resource "aws_apigatewayv2_api" "cr-ssrf-http-api" {
  name = "cr-ssrf-http-api"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_integration" "cr-ssrf-integration" {
  api_id           = aws_apigatewayv2_api.cr-ssrf-http-api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.cr-ssrf-lambda.invoke_arn
}


resource "aws_apigatewayv2_route" "cr-ssrf-route" {
  api_id    = aws_apigatewayv2_api.cr-ssrf-http-api.id
  route_key = "GET /cr-ssrf" 
  target    = "integrations/${aws_apigatewayv2_integration.cr-ssrf-integration.id}"
}


resource "aws_apigatewayv2_stage" "cr-ssrf-stage" {
  api_id     = aws_apigatewayv2_api.cr-ssrf-http-api.id
  name       = "default"
  auto_deploy = true
}


resource "aws_lambda_permission" "cr-ssrf-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cr-ssrf-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.cr-ssrf-http-api.execution_arn}/*/*/*"
}