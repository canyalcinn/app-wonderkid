resource "aws_api_gateway_rest_api" "wonderkid_api" {
  name = "MyWonderkidPotentialAPI"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.wonderkid_api.id
  parent_id   = aws_api_gateway_rest_api.wonderkid_api.root_resource_id
  path_part   = "analyze"
}

resource "aws_api_gateway_method" "lambda_post" {
  rest_api_id   = aws_api_gateway_rest_api.wonderkid_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.wonderkid_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_post.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.analyze_potential.invoke_arn
}
